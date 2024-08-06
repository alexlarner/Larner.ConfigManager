function Get-ALCMOrphanedEmptyDeviceCollections {
    [CmdletBinding(DefaultParameterSetName = 'Pipeline')]
    [OutputType([string])]
    param (
        [Parameter(ParameterSetName = 'Export')]
        [string]
        $Name = 'Orphaned Empty Device Collections',

        [Parameter(
            Mandatory,
            ParameterSetName = 'Export'
        )]
        [string]
        $DestinationFolder,

        [Microsoft.ConfigurationManagement.ManagementProvider.WqlQueryEngine.WqlResultObject[]]
        $AllCollections = (Get-CMCollection -ErrorAction Stop),

        [switch]
        $EnableException
    )

    $EmptyDeviceCollections = $AllCollections |
        Where-Object MemberCount -eq 0 |
            Where-Object CollectionType -eq 2
    $EmptyDeviceCollectionReferences = Get-ALCMCollectionReference -Collection $EmptyDeviceCollections -AllCollections $AllCollections -ExcludeDisabledDeployments -ExcludeRetiredApps

    $OrphanedCollectionNames = $EmptyDeviceCollectionReferences |
        Where-Object -Not RelatedCollections |
            Where-Object -Not Application |
                Select-Object -ExpandProperty Collection |
                    Sort-Object

    if ($DestinationFolder) {
        $OrphanRelationships = Get-ALCMCollectionReference -CollectionName $OrphanedCollectionNames -AllCollections $AllCollections

        Set-Location

        if (-Not (Test-Path $DestinationFolder)) {
            Invoke-PSFProtectedCommand -Action 'Create folder' -Target $DestinationFolder -ScriptBlock {
                New-Item -Path $DestinationFolder -ItemType Directory -ErrorAction Stop
            } -ErrorEvent {
                Return
            }
        }

        $Path = Join-Path $DestinationFolder "$Name - $((Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH-mm-ssZ')).xlsx"

        $Splat = @{
            Path          = $Path
            WorkSheetName = 'Collections'
            TableName     = 'Orphans'
            AutoSize      = $true
            AutoNameRange = $true
            ErrorAction   = 'Stop'
        }

        Invoke-PSFProtectedCommand -Action "Exporting to [$Path]" -Target $OrphanRelationships -ScriptBlock {
            $OrphanRelationships | Export-Excel @Splat
        }

        Set-Location $script:CMDrive
    } else {
        $OrphanedCollectionNames
    }
}

