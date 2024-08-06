function Get-ALADGroupCMConnection {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [string[]]
        $Name,

        [ValidateSet('Name', 'Object')]
        [string]
        $OutputType = 'Name',

        [switch]
        $ExcludeDisabledDeployments,

        [switch]
        $ExcludeRetiredApps,

        [Microsoft.ConfigurationManagement.ManagementProvider.WqlQueryEngine.WqlResultObject[]]
        $AllCollections = (Get-CMCollection -ErrorAction Stop),

        [switch]
        $EnableException
    )
    begin {
        $Regex = """$env:USERDOMAIN\\\\(?<ADGroupName>.+)"""
        foreach ($Collection in $AllCollections) {
            Write-PSFMessage "Parsing AD group name from the queries tied to the [$($Collection.Name)] collection" -Target $Collection
            $ADGroupNames = $Collection.CollectionRules |
                Where-Object QueryExpression -match $Regex |
                    ForEach-Object { $Matches.ADGroupName } |
                        Select-Object -Unique

            $Collection | Add-Member -NotePropertyName ADGroupNames -NotePropertyValue $ADGroupNames -Force
        }
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }

        foreach ($ADGroupName in $Name) {
            Write-PSFMessage "GroupName is [$ADGroupName]"

            $DirectlyRelatedCollections = $AllCollections | Where-Object { $ADGroupName -in $_.ADGroupNames }

            $IndirectCollections = if ($DirectlyRelatedCollections) {
                $DirectlyRelatedCollections |
                    Get-ALCMDependentCollection -AllCollections $AllCollections -OutputType Object |
                        ForEach-Object {
                            $_.Exclude
                            $_.Include
                        } | Write-Output
            }

            <#
            The Write-Output is there to enumerate arrays, so we don't get a 2-dimensional array that won't filter to unique properly, i.e.
            'a', @('a', 'b', 'c') | select -Unique
            #>
            $CollectionNames = $DirectlyRelatedCollections.Name, $IndirectCollections.Name | Write-Output | Select-Object -Unique

            $Deployments = foreach ($CollectionName in $CollectionNames) {
                Invoke-PSFProtectedCommand -Action "Get deployments attached to the [$CollectionName] collection" -ScriptBlock {
                    Get-CMDeployment -CollectionName $CollectionName -ErrorAction Stop
                } -Continue
            }

            if ($ExcludeDisabledDeployments) {
                $Deployments = $Deployments | Where-Object Enabled
            }

            $AppNames = $Deployments.ApplicationName | Select-Object -Unique

            $Applications = if ($OutputType -eq 'Object' -or $ExcludeRetiredApps) {
                foreach ($AppName in $AppNames) {
                    Invoke-PSFProtectedCommand -Action "Getting app details for [$AppName]" -ScriptBlock {
                        Get-CMApplication -Name $AppName
                    } -Continue
                }
            } else {
                $AppNames
            }

            switch ($OutputType) {
                'Name' {
                    [PSCustomObject]@{
                        ADGroup = $ADGroupName
                        DirectCollections = $DirectlyRelatedCollections.Name
                        IndirectCollections = $IndirectCollections.Name
                        # Deployments is not listed because it doesn't have a 'Name' property
                        Applications = if ($ExcludeRetiredApps) { $Applications.LocalizedDisplayName } else { $Applications }
                    }
                }
                'Object' {
                    if ($ExcludeRetiredApps) {
                        $Applications = $Applications | Where-Object -Not IsExpired
                    }

                    [PSCustomObject]@{
                        ADGroup =  $ADGroupName
                        DirectCollections = $DirectlyRelatedCollections
                        IndirectCollections = $IndirectCollections
                        Deployments = $Deployments
                        Applications = $Applications
                    }
                }
            }
        }
    }
}