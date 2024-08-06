function Get-ALCMCollectionReference {
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
        $Collection,

        [Parameter(
            Mandatory,
            ParameterSetName = 'Name',
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [Alias('Name')]
        [string[]]
        $CollectionName,

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
    process {
        if ($PSCmdlet.ParameterSetName -eq 'Name') {
            $Collection = foreach ($CollName in $CollectionName) {
                Invoke-PSFProtectedCommand -Action "Getting collection object for [$CollName]" -ScriptBlock {
                    Get-CMCollection -Name $CollName -ErrorAction Stop
                } -Continue
            }
        }

        foreach ($Coll in $Collection) {
            $RelatedCollections = $Coll |
                # Should this be recursive?
                Get-ALCMDependentCollection -AllCollections $AllCollections -OutputType Object |
                    ForEach-Object {
                        $_.Exclude
                        $_.Include
                    } |
                        Write-Output

            <#
            The Write-Output is there to enumerate arrays, so we don't get a 2-dimensional array that won't filter to unique properly, i.e.
            'a', @('a', 'b', 'c') | select -Unique
            #>

            $Deployments = foreach ($Name in ($Coll.Name, $RelatedCollections.Name | Write-Output | Select-Object -Unique)) {
                Invoke-PSFProtectedCommand -Action "Get deployments attached to the [$Name] collection" -ScriptBlock {
                    Get-CMDeployment -CollectionName $Name -ErrorAction Stop
                } -Continue
            }

            Write-PSFMessage "Found [$($Deployments.Count)] deployments" -Target $Deployments

            if ($ExcludeDisabledDeployments) {
                Write-PSFMessage "Filtering out the disabled deployments from the [$($Deployments.Count)] deployments" -Target $Deployments
                $Deployments = $Deployments | Where-Object Enabled
            }

            $AppNames = $Deployments.ApplicationName | Select-Object -Unique

            Write-PSFMessage "Found [$($AppNames.Count)] apps: [$($AppNames -join ', ')]"

            $Applications = if ($OutputType -eq 'Object' -or $ExcludeRetiredApps) {
                foreach ($AppName in $AppNames) {
                    Invoke-PSFProtectedCommand -Action "Getting app details for [$AppName]" -Target $AppName -ScriptBlock {
                        Get-CMApplication -Name $AppName
                    } -Continue
                }
            } else {
                $AppNames
            }

            if ($ExcludeRetiredApps) {
                $Applications = $Applications | Where-Object -Not IsExpired
            }

            switch ($OutputType) {
                'Name' {
                    [PSCustomObject]@{
                        Collection = $Coll.Name
                        RelatedCollections = $RelatedCollections.Name
                        # Deployments is not listed because it doesn't have a 'Name' property
                        Applications = if ($ExcludeRetiredApps) { $Applications.LocalizedDisplayName } else { $Applications }
                    }
                }
                'Object' {
                    [PSCustomObject]@{
                        RelatedCollections = $RelatedCollections
                        Deployments = $Deployments
                        Applications = $Applications
                    }
                }
            }
        }
    }
}