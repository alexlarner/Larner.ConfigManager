function Get-ALCMApplicationReference {
    [CmdletBinding(
        SupportsShouldProcess,
        DefaultParameterSetName = 'Object'
    )]
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

        [ValidateScript({
            if ($_.PSObject.Properties.Name -notcontains 'Dependencies') {
                $ErrorMessage = 'Object must contain a ''Dependencies'' property populated with the output from: Get-ALCMApplicationDependency -Application `$_ -OutputType ModelName'
                throw $ErrorMessage
            } else { $true }
        })]
        [Microsoft.ConfigurationManagement.ManagementProvider.WqlQueryEngine.WqlResultObject[]]
        $AllApplicationsWithDependencies,

        [ValidateSet('Name', 'Object')]
        [string[]]
        $OutputType = 'Name',

        [switch]
        $EnableException
    )
    begin {
        if (-Not $AllApplicationsWithDependencies) {
            Invoke-PSFProtectedCommand -Action 'Get all applications' -ScriptBlock {
                $AllApps = Get-CMApplication -ErrorAction Stop
            }

            Write-PSFMessage "Getting all dependencies for all [$($AllApps.Count)] apps. This will take a little over 10 minutes." -Level Critical
            $AllApplicationsWithDependencies = $AllApps |
                ForEach-Object {
                    Add-Member -InputObject $_ -NotePropertyName 'Dependencies' -NotePropertyValue (Get-ALCMApplicationDependency -Application $_ -OutputType ModelName)
                } |
                    Where-Object Dependencies
        }
    }
    process {
        if (Test-PSFFunctionInterrupt) {
            return
        }

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

            $HasDependencies = ($DeploymentType.NumberOfDependedDTs | Measure-Object -Maximum).Maximum -gt 0
            $IsADependency = ($DeploymentType.NumberOfDependentDTs | Measure-Object -Maximum).Maximum -gt 0

            $RequiresApp = if ($HasDependencies) {
                $App | Get-ALCMApplicationDependency
            }

            $RequiredByApp = if ($IsADependency) {
                $App | Get-ALCMDependentApplication -AllApplicationsWithDependencies $AllApplicationsWithDependencies -OutputType Object
            }

            switch ($OutputType) {
                'Name' {
                    [PSCustomObject]@{
                        Application = $App.LocalizedDisplayName
                        Requires = $RequiresApp.LocalizedDisplayName
                        RequiredBy = $RequiredByApp.LocalizedDisplayName
                    }
                }
                'Object' {
                    [PSCustomObject]@{
                        Application = $App
                        Requires = $RequiresApp
                        RequiredBy = $RequiredByApp
                    }
                }
            }
        }
    }
}