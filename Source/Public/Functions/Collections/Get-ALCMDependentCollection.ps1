function Get-ALCMDependentCollection {
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

        [Microsoft.ConfigurationManagement.ManagementProvider.WqlQueryEngine.WqlResultObject[]]
        $AllCollections = (Get-CMCollection -ErrorAction Stop),

        [ValidateSet('Name', 'Object')]
        [string[]]
        $OutputType = 'Name',

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
            $ExcludeCollections = $AllCollections |
                Where-Object {
                    $_.CollectionRules.ExcludeCollectionID -contains $Coll.CollectionID
                }

            $IncludeCollections = $AllCollections |
                Where-Object {
                    $_.CollectionRules.IncludeCollectionID -contains $Coll.CollectionID
                }


            if ($null -ne $ExcludeCollections -or $null -ne $IncludeCollections) {
                [PSCustomObject]@{
                    Input = switch ($OutputType) {
                        'Name' { $Coll.Name }
                        'Object' { $Coll }
                    }
                    Exclude = switch ($OutputType) {
                        'Name' { $ExcludeCollections | Select-Object -ExpandProperty Name }
                        'Object' { $ExcludeCollections }
                    }
                    Include = switch ($OutputType) {
                        'Name' { $IncludeCollections | Select-Object -ExpandProperty Name }
                        'Object' { $IncludeCollections }
                    }
                }
            }
        }
    }
}