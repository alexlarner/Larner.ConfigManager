function New-ALCMInstalledAppQuery {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [string[]]
        $Name,

        [SupportsWildcards()]
        [string]
        $DisplayNamePattern,

        [Parameter(Mandatory)]
        [Microsoft.ConfigurationManagement.ManagementProvider.WqlQueryEngine.WqlResultObject]
        $LimitingCollection,

        [switch]
        $EnableException
    )
    process {
        foreach ($QueryName in $Name) {
            $Operator = '='
            if ($DisplayNamePattern) {
                if ($DisplayNamePattern -like '*%*') {
                    $Operator = 'like'
                }
            } else {
                $DisplayNamePattern = $QueryName
            }
            $Splat = @{
                Name = $QueryName
                Comment = "Looks for applications with a display name $Operator `"$DisplayNamePattern`" in Add/Remove Programs"
                TargetClassName = 'SMS_R_System'
                LimitToCollectionId = $LimitingCollection.CollectionID
                Expression = @"
select
    SMS_R_System.NetbiosName,
    SMS_G_System_INSTALLED_SOFTWARE.ARPDisplayName,
    SMS_G_System_INSTALLED_SOFTWARE.Publisher,
    SMS_G_System_INSTALLED_SOFTWARE.ProductVersion,
    SMS_G_System_INSTALLED_SOFTWARE.UninstallString
from
    SMS_R_System
    inner join SMS_G_System_INSTALLED_SOFTWARE on SMS_G_System_INSTALLED_SOFTWARE.ResourceId = SMS_R_System.ResourceId
where
    SMS_G_System_INSTALLED_SOFTWARE.ARPDisplayName $Operator "$DisplayNamePattern"
"@
                ErrorAction = 'Stop'
            }

            Invoke-PSFProtectedCommand -Action "Creating CM query that [$($Splat.Comment)]" -Target $Splat.Name -ScriptBlock {
                $Query = New-CMQuery @Splat
            } -Continue

            Invoke-PSFProtectedCommand -Action "Moving CM query that [$($Splat.Comment)]" -Target $Splat.Name -ScriptBlock {
                $Query | Move-CMObject -FolderPath "$script:CMDrive`Query\Software"
            } -Continue
        }
    }
}