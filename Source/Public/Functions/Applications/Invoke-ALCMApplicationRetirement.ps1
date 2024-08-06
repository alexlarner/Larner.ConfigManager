function Invoke-ALCMApplicationRetirement {
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

        [ValidateScript({
            if ($_.PSObject.Properties.Name -notcontains 'Dependencies') {
                $ErrorMessage = 'Object must contain a ''Dependencies'' property populated with the output from: Get-ALCMApplicationDependency -Application `$_ -OutputType ModelName'
                throw $ErrorMessage
            } else { $true }
        })]
        [Microsoft.ConfigurationManagement.ManagementProvider.WqlQueryEngine.WqlResultObject[]]
        $AllApplicationsWithDependencies,

        [Microsoft.ConfigurationManagement.ManagementProvider.WqlQueryEngine.WqlResultObject[]]
        $AllCollections = (Get-CMCollection),

        [string]
        $RetiredAppFolderPath = 'Application\Retired Applications'
    )
    begin {
        $ADGroupNameRegex = """$env:USERDOMAIN\\\\(?<ADGroupName>.+)"""
        if (-Not $AllApplicationsWithDependencies) {
            Invoke-PSFProtectedCommand -Action 'Get all applications' -ScriptBlock {
                $AllApps = Get-CMApplication -ErrorAction Stop
            }

            Write-PSFMessage "Getting all dependencies for all [$($AllApps.Count)] apps. This will take a little over 10 minutes." -Level Critical
            $AllApplicationsWithDependencies = $AllApps |
                ForEach-Object {
                    Add-Member -InputObject $_ -NotePropertyName 'Dependencies' -NotePropertyValue (Get-ALCMApplicationDependency -Application $_ -OutputType ModelName) -PassThru
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
            Write-PSFMessage -Level Critical -Message "Getting all dependent applications for [$($App.LocalizedDisplayName)]"
            $DependentApps = $Application | Get-ALCMDependentApplication -AllApplicationsWithDependencies $AllApplicationsWithDependencies

            if ($DependentApps) {
                Write-PSFMessage -Level Critical -Message "Removing dependent applications for [$($App.LocalizedDisplayName)]"
                $Application | Remove-ALCMDependentApplication -AllApplicationsWithDependencies $AllApplicationsWithDependencies
            }

            $Collections = Get-CMDeployment -SoftwareName $App.LocalizedDisplayName | ForEach-Object { Get-CMCollection -ID $_.CollectionID }

            if ($Collections) {
                Write-PSFMessage -Level Critical -Message "Found $($Collections.Count) collections:`r`n$($Collections.Name -join "`r`n")"

                Write-PSFMessage -Level Critical -Message 'Filtering out the collections that are tied to other apps as well'
                $Collections = $Collections |
                    Where-Object {
                        $null -eq (
                            Get-CMDeployment -CollectionName $_.Name -FeatureType Application |
                                Where-Object SoftwareName -ne $App.LocalizedDisplayName
                        )
                    }
            }

            if ($Collections) {
                Write-PSFMessage -Level Critical -Message 'Getting the AD groups mentioned in any of the queries tied to the collections'
                $ADGroupNames = $Collections |
                    Select-Object -ExpandProperty CollectionRules |
                        Where-Object QueryExpression -match $ADGroupNameRegex |
                            ForEach-Object { $Matches.ADGroupName } |
                                Select-Object -Unique |
                                    Sort-Object
            }

            if ($ADGroupNames) {
                Write-PSFMessage -Level Critical -Message "These $($ADGroupNames.Count) AD groups were found:`r`n$($ADGroupNames -join "`r`n")"

                foreach ($Name in $ADGroupNames) {
                    $ADGroup = Get-ADGroup $Name -Properties Description

                    if ($ADGroup) {
                        $Splat = @{
                            DisplayName    = "DEL - $($Name)"
                            SamAccountName = "DEL - $($Name)"
                            Confirm        = $true
                        }
                        Write-PSFMessage -Level Critical -Message "Marking [$Name] for deletion"
                        $ADGroup | Set-ADGroup @Splat
                    }
                }
            }

            if ($Collections) {
                $CollectionRelationships = Get-ALCMDependentCollection -Collection $Collections -AllCollections $AllCollections -OutputType Object
                if ($CollectionRelationships.Exclude) {
                    $CollectionRelationships |
                        Where-Object Exclude |
                            ForEach-Object {
                                Write-PSFMessage -Level Critical -Message "Removing [$($_.Input.Name)] from [$($_.Exclude.Name)]'s Exclude membership rule"
                                $_.Input | Remove-CMCollectionExcludeMembershipRule -ExcludeCollection $_.Exclude -Confirm:$true
                            }
                }

                if ($CollectionRelationships.Include) {
                    $CollectionRelationships |
                        Where-Object Include |
                            ForEach-Object {
                                Write-PSFMessage -Level Critical -Message "Removing [$($_.Input.Name)] from [$($_.Include.Name)]'s Include membership rule"
                                $_.Input | Remove-CMCollectionIncludeMembershipRule -IncludeCollection $_.Include -Confirm:$true
                            }
                }

                Write-PSFMessage -Level Critical -Message 'Filtering out the collections that still are being used as an Include/Exclude collection for another collection'
                $Collections = $Collections | Where-Object { $null -eq (Get-ALCMDependentCollection -Collection $_ -AllCollections $AllCollections) }

                foreach ($Collection in $Collections) {
                    Write-PSFMessage -Level Critical -Message "Disabling the refresh on [$($Collection.Name)]"
                    $Collection | Set-CMCollection -RefreshType None -Confirm:$true

                    $RootFolder = switch ($Collection.CollectionType) {
                        1 { 'UserCollection'  }
                        2 { 'DeviceCollection' }
                    }

                    Write-PSFMessage -Level Critical -Message "Moving [$($Collection.Name)] to the Retired Collections folder"
                    $Collection | Move-CMObject -FolderPath "$RootFolder\Retired Collections"
                }
            }

            $Deployments = Get-CMDeployment -SoftwareName $App.LocalizedDisplayName

            if ($Deployments) {
                Write-PSFMessage -Level Critical -Message "Removing the deployments on [$($App.LocalizedDisplayName)]"
                $Deployments | Remove-CMDeployment -Confirm:$true
            }

            Write-PSFMessage -Level Critical -Message "Moving [$($App.LocalizedDisplayName)] to the Retired Applications folder"
            $App | Move-CMObject -FolderPath $RetiredAppFolderPath

            Write-PSFMessage -Level Critical -Message "Go to the [$RetiredAppFolderPath] folder in the console and retire the app"
        }
    }
}