function Remove-ALCMDependentApplication {
    [CmdletBinding(
        SupportsShouldProcess,
        DefaultParameterSetName = 'Object',
        ConfirmImpact = 'High'
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

        [switch]
        $EnableException
    )
    begin {
        if (-Not $AllApplicationsWithDependencies) {
            Invoke-PSFProtectedCommand -Action 'Get all applications' -ScriptBlock {
                $AllApps = Get-CMApplication -ErrorAction Stop
            } -Confirm:$false

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
                } -Continue -Confirm:$false
            }
        }

        foreach ($App in $Application) {
            $AppRelationships = $App | Get-ALCMDependentApplication -AllApplicationsWithDependencies $AllApplicationsWithDependencies -OutputType Object

            foreach ($DependentApp in $AppRelationships.RequiredBy) {
                # I decided to not go with this code, because even though it's cleaner, it's hard to get good logging from.

                <#
                $DependencyGroups = $DependentApp |
                    Get-CMDeploymentType |
                        Where-Object NumberOfDependedDTs -gt 0 |
                            Get-CMDeploymentTypeDependencyGroup |
                                Where-Object { (Get-CMDeploymentTypeDependency -InputObject $_).AppModelName -eq $App.ModelName } |
                                    Remove-CMDeploymentTypeDependencyGroup
                #>

                Invoke-PSFProtectedCommand -Action "Get deployment types for [$($DependentApp.LocalizedDisplayName)]" -Target $DependentApp -ScriptBlock {
                    $DeploymentTypes = $DependentApp | Get-CMDeploymentType -ErrorAction Stop
                } -Continue -Confirm:$false

                $DeploymentTypes = $DeploymentTypes | Where-Object NumberOfDependedDTs -gt 0

                $DependencyGroups = foreach ($DeployType in $DeploymentTypes) {
                    Invoke-PSFProtectedCommand -Action "Get the dependency group for the [$($DeployType.LocalizedDisplayName)] deployment type on [$($DependentApp.LocalizedDisplayName)]" -Target $DeployType -ScriptBlock {
                        Get-CMDeploymentTypeDependencyGroup -InputObject $DeployType -ErrorAction Stop
                    } -Continue -Confirm:$false
                }

                Write-PSFMessage "Filtering the dependency groups down to the ones that list [$($App.LocalizedDisplayName)] as the dependency"
                $DependencyGroups = $DependencyGroups | Where-Object { (Get-CMDeploymentTypeDependency -InputObject $_).AppModelName -eq $App.ModelName }

                foreach ($DependGroup in $DependencyGroups) {
                    Invoke-PSFProtectedCommand -Action "Deleting [$($DependGroup.GroupName)] dependency group on [$($DependentApp.LocalizedDisplayName)]" -Target $DependGroup -ScriptBlock {
                        Remove-CMDeploymentTypeDependencyGroup -InputObject $DependGroup -ErrorAction Stop -Confirm:$false -Force
                    }
                }
            }
        }
    }
}