function Group-ALCMInstalledAppQueryResults {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string[]]
        $QueryName,

        [ValidateSet('Software Name', 'Software Version')]
        [string]
        $GroupOn = 'Software Name',

        [ValidateSet('Count', 'Name')]
        [string]
        $SortOn = 'Count',

        [switch]
        $EnableException
    )
    process {
        foreach ($QName in $QueryName) {
            Invoke-PSFProtectedCommand -Action "Get [$QName] query" -ScriptBlock {
                $Query = Get-CMQuery -Name $QName -ErrorAction Stop
            } -Continue


            Invoke-PSFProtectedCommand -Action "Invoke query" -Target $Query -ScriptBlock {
                $QueryResults = $Query | Invoke-CMQuery -ErrorAction Stop
            } -Continue

            switch ($GroupOn) {
                'Software Name' {
                    $QueryResults.SMS_G_System_INSTALLED_SOFTWARE | Group-Object ARPDisplayName | Sort-Object $SortOn -Descending
                }
                'Software Version' {
                    $UniqueSoftwareNames = $QueryResults.SMS_G_System_INSTALLED_SOFTWARE.ARPDisplayName | Select-Object -Unique
                    foreach ($SoftwareName in $UniqueSoftwareNames) {
                        Write-Host $SoftwareName -ForegroundColor Green
                        $QueryResults.SMS_G_System_INSTALLED_SOFTWARE | Where-Object ARPDisplayName -eq $SoftwareName | Group-Object ProductVersion | Sort-Object $SortOn -Descending
                    }
                }
            }
        }
    }
}