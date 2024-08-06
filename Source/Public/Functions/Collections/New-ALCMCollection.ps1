function New-ALCMCollection {
	[CmdletBinding(
		SupportsShouldProcess,
		DefaultParameterSetName = 'AutoNaming'
	)]
	param (
		[Parameter(
			Mandatory,
			ValueFromPipeline
		)]
		[Microsoft.ConfigurationManagement.ManagementProvider.WqlQueryEngine.WqlResultObject[]]
		$Application,

		[Parameter(ParameterSetName = 'ManualNaming')]
		[Alias('Name')]
		[string]
		$CollectionName,

		[ValidateSet('User', 'Device')]
		[string]
		$CollectionType = 'User',

		[string]
		$ApplicationFolderName,

		[Parameter(Mandatory)]
		[Microsoft.ConfigurationManagement.ManagementProvider.WqlQueryEngine.WqlResultObject]
		$LimitingCollection,

		[ValidateSet('Manual', 'Periodic', 'Continuous', 'Both')]
		[Microsoft.ConfigurationManagement.ManagementProvider.CollectionRefreshType]
		$RefreshType,

		[Microsoft.ConfigurationManagement.ManagementProvider.WqlQueryEngine.WqlArrayItems]
		$RefreshSchedule,

		[Parameter(
			Mandatory,
			ParameterSetName = 'ManualNaming'
		)]
		[string]
		$ADGroupName,

		[Parameter(ParameterSetName = 'AutoNaming')]
		[ValidateLength(3,3)]
		[string]
		$ADGroupPrefix = 'PKG',

		[switch]
		$EnableException
	)
	begin {
		$AllNewCollectionsSplat = @{
			ErrorAction = 'Stop'
			CollectionType = $CollectionType
		}

		if ($RefreshType) { $AllNewCollectionsSplat.RefreshType = $RefreshType }

		if ($RefreshSchedule) { $AllNewCollectionsSplat.RefreshSchedule = $RefreshSchedule }

		$QueryPropertyNames = @(
			'ResourceID',
			'ResourceType',
			'Name'
		)

		switch ($CollectionType) {
			'Device' {
				$ApplicationsRootFolderPath = "DeviceCollection\Applications"
				$QueryDBTable = 'SMS_R_SYSTEM'
				$QueryForeignKey = 'SystemGroupName'
				$QueryPropertyNames = $QueryPropertyNames + @(
					'SMSUniqueIdentifier',
					'ResourceDomainORWorkgroup',
					'Client'
				)
			}
			'User' {
				$ApplicationsRootFolderPath = "UserCollection\Applications"
				$QueryDBTable = 'SMS_R_USER'
				$QueryForeignKey = 'UserGroupName'
				$QueryPropertyNames = $QueryPropertyNames + @(
					'UniqueUserName',
					'WindowsNTDomain'
				)
			}
		}

		$QueryPropertiesString = ($QueryPropertyNames | ForEach-Object { "$QueryDBTable.$_" }) -join ','
	}
	process {
		foreach ($App in $Application) {
			if (-Not $ApplicationFolderName) { $ApplicationFolderName = $App.LocalizedDisplayName }
			if ($PSCmdlet.ParameterSetName -eq 'AutoNaming') {
				$ADGroupName = "$ADGroupPrefix - $($App.LocalizedDisplayName)"
			}

			if (-Not $CollectionName) { $CollectionName = "$($App.LocalizedDisplayName) - $CollectionType" }

			$NewCollectionSplat = @{
				Name    = $CollectionName
				Comment = $CollectionName
			}

			$PublisherCollectionsPath = "$ApplicationsRootFolderPath\$($App.Manufacturer)"
			$AppCollectionsPath = "$PublisherCollectionsPath\$ApplicationFolderName"

			if ($null -eq (Get-CMFolder -FolderPath $AppCollectionsPath)) {
				if ($null -eq (Get-CMFolder -FolderPath $PublisherCollectionsPath)) {
					Invoke-PSFProtectedCommand -Action "Create folder for publisher [$($App.Manufacturer)] collections" -Target $PublisherCollectionsPath -ScriptBlock {
						New-CMFolder -Name $App.Manufacturer -ParentFolderPath $ApplicationsRootFolderPath -ErrorAction Stop | Out-Null
					} -Continue
				}

				Invoke-PSFProtectedCommand -Action "Create folder for app [$($App.LocalizedDisplayName)] collections" -Target $AppCollectionsPath -ScriptBlock {
					New-CMFolder -Name $ApplicationFolderName -ParentFolderPath $PublisherCollectionsPath -ErrorAction Stop | Out-Null
				} -Continue
			}

			if (Get-CMCollection -Name $NewCollectionSplat.Name -CollectionType $CollectionType) {
				Write-PSFMessage -Level Warning -Message "A $CollectionType collection named [$($NewCollectionSplat.Name)] already exists"
			} else {
				Invoke-PSFProtectedCommand -Action "Create [$($NewCollectionSplat.Name)] $CollectionType collection" -Target $NewCollectionSplat.Name -ScriptBlock {
					$LimitingCollection | New-CMCollection @AllNewCollectionsSplat @NewCollectionSplat | Move-CMObject -FolderPath $AppCollectionsPath
				} -Continue

				$Query = @"
SELECT $QueryPropertiesString
FROM $QueryDBTable
WHERE $QueryDBTable.$QueryForeignKey = "$env:USERDOMAIN\\$ADGroupName"
"@

				$MRSplat = @{
					CollectionName  = $NewCollectionSplat.Name
					QueryExpression = $Query
					RuleName        = "AD Query - $ADGroupName"
					ErrorAction     = 'Stop'
				}
				Invoke-PSFProtectedCommand -Action "Create query membership rule [$($MRSplat.RuleName)] with this query: [$Query]" -Target $NewCollectionSplat.Name -ScriptBlock {
					switch ($CollectionType) {
						'Device' { Add-CMDeviceCollectionQueryMembershipRule @MRSplat }
						'User' { Add-CMUserCollectionQueryMembershipRule @MRSplat }
					}
				}
			}
		}
	}
}