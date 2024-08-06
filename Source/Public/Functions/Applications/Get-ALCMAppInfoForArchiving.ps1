function Get-ALCMAppInfoForArchiving {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ParameterSetName = 'Name'
        )]
        [string[]]
        $AppName,

        [Parameter(
			Mandatory,
			ValueFromPipeline,
            ParameterSetName = 'Object'
		)]
		[Microsoft.ConfigurationManagement.ManagementProvider.WqlQueryEngine.WqlResultObject[]]
		$Application
    )
    process {
        if ($AppName) {
            $Application = $AppName | ForEach-Object { Get-CMApplication $_ }
        }

        foreach ($App in $Application) {
            $App | Format-List LocalizedDisplayName, Manufacturer, SoftwareVersion

            $App |
                Get-CMDeploymentType |
                    Add-ALCMDeploymentTypeXMLInfo |
                        Format-List
        }
    }
}