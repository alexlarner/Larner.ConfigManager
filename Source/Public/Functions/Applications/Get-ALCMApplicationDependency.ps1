function Get-ALCMApplicationDependency {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(
            Mandatory,
            ParameterSetName = 'Object',
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [Microsoft.ConfigurationManagement.ManagementProvider.WqlQueryEngine.WqlResultObject[]]
        $Application,

        [Parameter(
            Mandatory,
            ParameterSetName = 'Name',
            ValueFromPipeline
        )]
        [Alias('Name')]
        [string[]]
        $ApplicationName,

        [ValidateSet('ModelName', 'ApplicationObject', 'Name')]
        [string]
        $OutputType = 'ApplicationObject',

        [switch]
        $EnableException
    )
    process {
        if ($PSCmdlet.ParameterSetName -eq 'Name') {
            $Application = foreach ($AppName in $ApplicationName) {
                Invoke-PSFProtectedCommand -Action "Get application object for [$AppName]" -ScriptBlock {
                    Get-CMApplication -Name $AppName -ErrorAction Stop
                } -Continue
            }
        }

        foreach ($App in $Application) {
            $DeploymentType = Invoke-PSFProtectedCommand -Action "Get deployment types for [$($App.LocalizedDisplayName)]" -Target $App -ScriptBlock {
                $App | Get-CMDeploymentType -ErrorAction Stop
            } -Continue

            foreach ($DeployType in ($DeploymentType | Where-Object NumberOfDependedDTs -gt 0)) {
                $DependencyDeploymentType = Invoke-PSFProtectedCommand -Action "Get dependency group and its related deployment type of the depended app for the [$($DeployType.LocalizedDisplayName)] deployment type of the [$($App.LocalizedDisplayName)] app" -Target $DeployType -ScriptBlock {
                    $DeployType | Get-CMDeploymentTypeDependencyGroup | Get-CMDeploymentTypeDependency -ErrorAction Stop
                } -Continue

                foreach ($AppModelName in ($DependencyDeploymentType.AppModelName | Select-Object -Unique)) {
                    if ($OutputType -ne 'ModelName') {
                        $DependencyApp = Invoke-PSFProtectedCommand -Action "Get the application with a model name of [$AppModelName], because it is a dependency for [$($App.LocalizedDisplayName)]" -ScriptBlock {
                            Get-CMApplication -ModelName $AppModelName -ErrorAction Stop
                        } -Continue
                    }

                    switch ($OutputType) {
                        'ApplicationObject' { $DependencyApp }
                        'ModelName' { $AppModelName }
                        'Name' { $DependencyApp.LocalizedDisplayName }
                    }
                }
            }
        }
    }
}