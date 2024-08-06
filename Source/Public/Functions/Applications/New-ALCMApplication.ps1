function New-ALCMApplication {
	[CmdletBinding(
		SupportsShouldProcess,
		DefaultParameterSetName = 'PatchMyPC'
	)]
	param (
		[Parameter(Mandatory)]
		[ValidateLength(1,256)]
		[string]
		$Name,

		[string]
		$ApplicationFolderName,

		[Parameter(Mandatory)]
		[ValidateLength(1,256)]
		[string]
		$Publisher,

		[Parameter(
			Mandatory,
			ParameterSetName = 'Scratch'
		)]
		[Parameter(
			Mandatory,
			ParameterSetName = 'ScratchScriptDetection'
		)]
		[ValidateLength(1,64)]
		[string]
		$SoftwareVersion,

		[Parameter(
			Mandatory,
			ParameterSetName = 'Scratch'
		)]
		[Parameter(
			Mandatory,
			ParameterSetName = 'ScratchScriptDetection'
		)]
		[ValidateLength(1,2048)]
		[string]
		$Description,

		[Parameter(ParameterSetName = 'Scratch')]
		[Parameter(ParameterSetName = 'ScratchScriptDetection')]
		[string]
		$InstallCommand = 'Deploy-Application.exe',

		[Parameter(ParameterSetName = 'Scratch')]
		[Parameter(ParameterSetName = 'ScratchScriptDetection')]
		[string]
		$UninstallCommand = 'Deploy-Application.exe -DeploymentType Uninstall',

		[Parameter(
			Mandatory,
			ParameterSetName = 'Scratch'
		)]
		[Microsoft.ConfigurationManagement.PowerShell.Framework.DetectionClause[]]
		$DetectionClause,

		[Parameter(ParameterSetName = 'ScratchScriptDetection')]
		[ValidateSet('PowerShell', 'VBScript', 'JavaScript')]
		[string]
		$ScriptLanguage = 'PowerShell',

		[Parameter(
			Mandatory,
			ParameterSetName = 'ScratchScriptDetection'
		)]
		[string]
		$ScriptText,

		[Parameter(
			Mandatory,
			ParameterSetName = 'Scratch'
		)]
		[Parameter(
			Mandatory,
			ParameterSetName = 'ScratchScriptDetection'
		)]
		[string[]]
		$Keyword,

		[Parameter(ParameterSetName = 'Scratch')]
		[Parameter(ParameterSetName = 'ScratchScriptDetection')]
		[ValidateScript({
			if ($_.Exists) {
				$AllowableExtensions = '.DLL', '.EXE', '.ICO', '.JPG', '.PNG'
				if ($_.Extension -in $AllowableExtensions) {
					$true
				} else {
					throw "$_ must have one of these file extensions: $($AllowableExtensions -join ', ')"
				}
			} else { throw "$_ does not exist" }
		})]
		[System.IO.FileInfo]
		$IconFile,

		[Parameter(ParameterSetName = 'Scratch')]
		[Parameter(ParameterSetName = 'ScratchScriptDetection')]
		[ValidateLength(1,128)]
		[string]
		$UserDocumentationLinkText,

		[Parameter(ParameterSetName = 'Scratch')]
		[Parameter(ParameterSetName = 'ScratchScriptDetection')]
		[ValidateLength(1,256)]
		[string]
		$UserDocumentationLink,

		[Parameter(ParameterSetName = 'Scratch')]
		[Parameter(ParameterSetName = 'ScratchScriptDetection')]
		[ValidateLength(1,128)]
		[string]
		$PrivacyPolicyURL,

		[Parameter(
			Mandatory,
			ParameterSetName = 'Scratch'
		)]
		[Parameter(
			Mandatory,
			ParameterSetName = 'ScratchScriptDetection'
		)]
		[ValidateScript({
			if ($_.Exists) { $true } else { throw "$_ does not exist" }
		})]
		[System.IO.DirectoryInfo]
		$InstallMediaFolder,

		[Parameter(
			Mandatory,
			ParameterSetName = 'Scratch'
		)]
		[Parameter(
			Mandatory,
			ParameterSetName = 'ScratchScriptDetection'
		)]
		[int]
		$EstimatedRuntimeMins,

		[Parameter(
			Mandatory,
			ParameterSetName = 'Scratch'
		)]
		[Parameter(
			Mandatory,
			ParameterSetName = 'ScratchScriptDetection'
		)]
		[ValidateRange(15,65535)]
		[int]
		$MaximumRuntimeMins,

		[Parameter(ParameterSetName = 'Scratch')]
		[Parameter(ParameterSetName = 'ScratchScriptDetection')]
		[DateTime]
		$ReleaseDate = (Get-Date),

		[string[]]
		$DistributionPointGroupName = @('01 - All DPs'),

		[ValidateScript({
			$Folder = Get-CMFolder -FolderPath (Join-Path 'Application' $_)
			if ($Folder) {
				$true
			} else {
				throw "$_ does not exist"
			}
		})]
		[string]
		$ApplicationsRootFolderPath = 'Vendor',

		[ValidateLength(3,3)]
		[string]
		$ADGroupPrefix = 'PKG',

		[ValidateSet('Available', 'Required')]
		[string]
		$DeployPurpose = 'Available',

		[ValidateSet('DisplayAll', 'DisplaySoftwareCenterOnly', 'HideAll')]
		[string]
		$UserNotification = 'DisplaySoftwareCenterOnly',

		[ValidateSet('Device', 'User')]
		[string[]]
		$CollectionType = @('Device', 'User'),

		[ValidateScript({ $null -ne (Get-CMCollection -Name $_) })]
		[string]
		$CollectionNameOverride,

		[switch]
		$AddPackagingTeamDeployment,

		[switch]
		$EnableException
	)
	begin {
		$PackagingTeamCollectionName = 'Packaging Team'
	}
	process {
		$CurrentExistence = @{}

		#Region AD Group Creation

		if (-Not $CollectionNameOverride) {
			foreach ($CollType in $CollectionType) {
				$ADGroupName = "$ADGroupPrefix - $Name"

				try {
					Set-Location
					Get-ADGroup $ADGroupName -ErrorAction Stop | Out-Null
				} catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
					Invoke-PSFProtectedCommand -Action "Create Application AD Group [$ADGroupName]" -Target $ADGroupName -ScriptBlock {
						$NewAppSplat = $PSBoundParameters | ConvertTo-PSFHashtable -Include Name, ADGroupPrefix -Inherit
						New-ALCMAppADGroup @NewAppSplat
					}
				} catch {
					Write-PSFMessage -Level Warning -Message "Failed while looking for an AD group [$ADGroupName]" -ErrorRecord $_
				} finally {
					Set-Location $script:CMDrive
				}
			}
		}

		#EndRegion AD Group Creation

		$CMApp = Get-CMApplication $Name

		$ApplicationsRootFolderFullPath = Join-Path 'Application' $ApplicationsRootFolderPath
		$PublisherApplicationsPath = Join-Path $ApplicationsRootFolderFullPath $Publisher
		$NameForApplicationLevelFolders = if ($ApplicationFolderName) { $ApplicationFolderName } else { $Name }
		$ApplicationPath = "$PublisherApplicationsPath\$NameForApplicationLevelFolders"

		$CurrentExistence = @{
			ApplicationFolder           = $null -ne (Get-CMFolder -FolderPath $ApplicationPath)
			PublisherApplicationsFolder = $null -ne (Get-CMFolder -FolderPath $PublisherApplicationsPath)
			Application                 = $null -ne $CMApp
			Collection                  = @{}
			DeploymentType              = $false
			Deployment                  = @{}
		}

		if ($CurrentExistence.Application) { $CurrentExistence.DeploymentType = ($null -ne (Get-CMDeploymentType -ApplicationName $Name))}

		Write-PSFMessage 'Creating list of collections to check for'

		$CollectionsToCheck = @{}

		if ($CollectionNameOverride) {
			$CollectionsToCheck.Override = $CollectionNameOverride
		} else {
			foreach ($Type in $CollectionType) {
				$CollectionsToCheck.$Type = "$Name - $Type"
			}
		}

		if ($AddPackagingTeamDeployment) { $CollectionsToCheck.PackagingTeam = $PackagingTeamCollectionName }

		Write-PSFMessage "Getting collection status for these kinds of collections [$($CollectionsToCheck.Keys -join ', ')] for [$Name]"
		foreach ($CollHashToCheck in $CollectionsToCheck.GetEnumerator()) {
			$CollectionNickname = $CollHashToCheck.Key
			$CollectionName = $CollHashToCheck.Value

			Write-PSFMessage "Checking if [$CollectionName] collection exists"
			$CurrentExistence.Collection.$CollectionNickname = $null -ne (Get-CMCollection -Name $CollectionName)

			# Look for the deployment only if the application & collection exist
			$CurrentExistence.Deployment.$CollectionNickname = if ($CurrentExistence.Application -and $CurrentExistence.Collection.$CollectionNickname) {
				Write-PSFMessage "Checking for a deployment of [$Name] to [$CollectionName]"
				$null -ne (Get-CMApplicationDeployment -Name $Name -CollectionName $CollectionName)
			} else { $false }

		}

		Write-PSFMessage "Current Packaging Status is:`n$($CurrentExistence | ConvertTo-Json)" -Target $CurrentExistence

		if (-Not $CurrentExistence.ApplicationFolder) {
			Invoke-PSFProtectedCommand -Action "Create CM application folders" -Target $PublisherApplicationsPath -ScriptBlock {
				New-ALCMAppFolders -ApplicationFolderName $NameForApplicationLevelFolders -Publisher $Publisher -ApplicationsRootFolderPath $ApplicationsRootFolderPath | Out-Null
			} -Continue
		}

		if (-Not $CurrentExistence.Application) {
			$AppDisplayInfoSplat = @{
				Title             = $Name
				LanguageID        = 1033
				Description       = $Description
				Keyword           = $Keyword
				ErrorAction       = 'Stop'
			}

			if ($IconFile) { $AppDisplayInfoSplat.IconLocationFile = $IconFile.FullName }
			if ($PrivacyPolicyURL) { $AppDisplayInfoSplat.PrivacyUrl = $PrivacyPolicyURL }
			if ($UserDocumentationLinkText) { $AppDisplayInfoSplat.LinkText = $UserDocumentationLinkText }
			if ($UserDocumentationLink) { $AppDisplayInfoSplat.UserDocumentation = $UserDocumentationLink }

			Invoke-PSFProtectedCommand -Action "Create Application Display Info for [$Name]" -Target $Name -ScriptBlock {
				$DisplayInfo = New-CMApplicationDisplayInfo @AppDisplayInfoSplat
			} -Continue

			$NewApplicationSplat = @{
				AppCatalog        = $DisplayInfo
				AutoInstall       = $true
				DefaultLanguageID = 1033
				Name              = $Name
				Publisher         = $Publisher
				ReleaseDate       = $ReleaseDate
				SoftwareVersion   = $SoftwareVersion
				ErrorAction       = 'Stop'
			}

			Invoke-PSFProtectedCommand -Action "Create new CM application [$Name]" -Target $Name -ScriptBlock {
				$CMApp = New-CMApplication @NewApplicationSplat
				Write-Output $CMApp
				$CMApp | Move-CMObject -FolderPath $ApplicationPath
			} -Continue
		}

		if (-Not $CurrentExistence.DeploymentType) {
			$DeploymentTypeSplat = @{
				ContentLocation           = $InstallMediaFolder.FullName
				DeploymentTypeName        = $Name
				EstimatedRuntimeMins      = $EstimatedRuntimeMins
				InstallationBehaviorType  = 'InstallForSystem'
				InstallCommand            = $InstallCommand
				LogonRequirementType      = 'WhetherOrNotUserLoggedOn'
				MaximumRuntimeMins        = $MaximumRuntimeMins
				RebootBehavior            = 'NoAction' # This corresponds to the "No Specific Action" the the bottom dropdown of the "User Experience"
				UninstallCommand          = $UninstallCommand
				UserInteractionMode       = 'Hidden'
				ErrorAction               = 'Stop'
			}

			switch ($PSCmdlet.ParameterSetName) {
				'Scratch' { $DeploymentTypeSplat.AddDetectionClause = $DetectionClause }
				'ScratchScriptDetection' {
					$DeploymentTypeSplat.ScriptLanguage = $ScriptLanguage
					$DeploymentTypeSplat.ScriptText = $ScriptText
				}
			}

			Invoke-PSFProtectedCommand -Action "Add script deployment type to [$Name]" -Target $Name -ScriptBlock {
				$DeploymentType = $CMApp | Add-CMScriptDeploymentType @DeploymentTypeSplat
			} -Continue

			Invoke-PSFProtectedCommand -Action "Distribute [$Name] application to distribution point groups" -Target $CMApp -ScriptBlock {
				$CMApp | Start-CMContentDistribution -DistributionPointGroupName $DistributionPointGroupName
			} # This is needed so that the App Deployment can be created
		}

		if (-Not $CollectionNameOverride) {
			foreach ($CollType in $CollectionType) {
				if (-Not $CurrentExistence.Collection.$CollType) {
					Invoke-PSFProtectedCommand -Action "Create $CollType collection for [$Name]" -Target $Name -ScriptBlock {
						$Splat = @{
							Application = $CMApp
							ADGroupPrefix = $ADGroupPrefix
							CollectionType = $CollType
						}
						if ($ApplicationFolderName) { $Splat.ApplicationFolderName = $ApplicationFolderName }
						New-ALCMCollection @Splat
					}
				}
			}
		}

		$MissingDeployments = @($CurrentExistence.Deployment.GetEnumerator() | Where-Object Value -eq $false | Select-Object -ExpandProperty Key)

		if ($MissingDeployments) {
			$AllAppDeploymentSplat = @{
				Application = $CMApp
				UserNotification = $UserNotification
			}

			foreach ($MissingDeployment in $MissingDeployments) {
				$AppDeploymentSplat = @{}
				switch ($MissingDeployment) {
					'PackagingTeam' {
						$AppDeploymentSplat.CollectionName = $PackagingTeamCollectionName
						$AppDeploymentSplat.DeployPurpose = 'Available'
					}
					'Override' {
						$AppDeploymentSplat.CollectionName = $CollectionNameOverride
						$AppDeploymentSplat.DeployPurpose = $DeployPurpose
					}
					default {
						$AppDeploymentSplat.CollectionType = $MissingDeployment
						$AppDeploymentSplat.DeployPurpose = $DeployPurpose
					}
				}
				New-ALCMAppDeployment @AllAppDeploymentSplat @AppDeploymentSplat | Out-Null
			}
		}
	}
}