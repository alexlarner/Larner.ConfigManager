function New-ALCMAppDeployment {
	[CmdletBinding(
		DefaultParameterSetName = 'AutoNaming',
		SupportsShouldProcess
	)]
	[OutputType([Microsoft.ConfigurationManagement.ManagementProvider.WqlQueryEngine.WqlResultObject])]
	param (
		[Parameter(
			Mandatory,
			ValueFromPipeline
		)]
		[Microsoft.ConfigurationManagement.ManagementProvider.WqlQueryEngine.WqlResultObject[]]
		$Application,

		[ValidateSet('Available', 'Required')]
		[string]
		$DeployPurpose = 'Available',


		[ValidateSet('Install', 'Uninstall')]
		[string]
		$DeployAction = 'Install',

		[Parameter(ParameterSetName = 'AutoNaming')]
		[ValidateSet('User', 'Device')]
		[string]
		$CollectionType = 'User',

		[Parameter(
			Mandatory,
			ParameterSetName = 'ManualNaming'
		)]
		[string]
		$CollectionName,

		[ValidateSet('DisplayAll', 'DisplaySoftwareCenterOnly', 'HideAll')]
		[string]
		$UserNotification = 'DisplaySoftwareCenterOnly',

		[switch]
		$EnableException
	)
	begin {
		$AppDeploymentSplat = @{
			DeployAction                       = $DeployAction
			DeployPurpose                      = $DeployPurpose
			AvailableDateTime                  = (Get-Date)
			UserNotification                   = $UserNotification
			PersistOnWriteFilterDevice         = $true
			ErrorAction                        = 'Stop'
		}
	}
	process {
		foreach ($App in $Application) {
			$AppDeploymentSplat.CollectionName = if ($CollectionName) { $CollectionName } else { "$($App.LocalizedDisplayName) - $CollectionType" }
			Invoke-PSFProtectedCommand -Action "Create [$DeployPurpose] [$DeployAction] [$CollectionType] application deployment of [$($App.LocalizedDisplayName)] to [$($AppDeploymentSplat.CollectionName)]" -Target $App -ScriptBlock {
				$App | New-CMApplicationDeployment @AppDeploymentSplat
			}
		}
	}
}