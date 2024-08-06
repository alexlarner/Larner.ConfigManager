function Remove-ALCMApplication {
	[CmdletBinding(
		SupportsShouldProcess,
		ConfirmImpact = 'High'
	)]
	param (
		[Parameter(
			Mandatory,
			ValueFromPipeline
		)]
		[Microsoft.ConfigurationManagement.ManagementProvider.WqlQueryEngine.WqlResultObject[]]
		$Application,

		[switch]
		$EnableException
	)
	process {
		foreach ($App in $Application) {
			Invoke-PSFProtectedCommand -Action "Remove [$($App.LocalizedDisplayName)]'s deployments" -ScriptBlock {
				Get-CMDeployment -SoftwareName $App.LocalizedDisplayName | Remove-CMDeployment -Force -ErrorAction Stop
			} -Continue

			Invoke-PSFProtectedCommand -Action "Remove [$($App.LocalizedDisplayName)]'s device collections" -ScriptBlock {
				$App.LocalizedDisplayName,
				"$($App.LocalizedDisplayName) - Device",
				"$($App.LocalizedDisplayName) - User" | ForEach-Object {
					Get-CMCollection -Name $_ | Remove-CMCollection -Force -ErrorAction Stop
				}
			} -Continue

			Invoke-PSFProtectedCommand -Action "Remove application [$($App.LocalizedDisplayName)]" -Target $App.LocalizedDisplayName -ScriptBlock {
				$Application | Remove-CMApplication -Force -ErrorAction Stop
			} -Continue
		}
	}
}
