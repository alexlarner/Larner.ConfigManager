function New-ALCMAppADGroup {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [Alias('Name')]
        [string[]]
        $AppName,

        [ValidateLength(3,3)]
		[string]
        $ADGroupPrefix = 'PKG',

        [switch]
        $EnableException
    )

    begin {
        $SplitDomain = $env:USERDNSDOMAIN.Split('.')
        $AllGroupsSplat = @{
            Path          = "OU=Packages,OU=CM,DC=$($SplitDomain[0]),DC=$($SplitDomain[1])"
            GroupScope    = 'Global'
            GroupCategory = 'Security'
            ErrorAction   = 'Stop'
        }
    }

    process {
        foreach ($Name in $AppName) {
            Invoke-PSFProtectedCommand -Action "Create Application AD Group" -Target $ADGroupName -ScriptBlock {
                New-ADGroup @AllGroupsSplat -Name "$ADGroupPrefix - $Name" -Description $Description
            }
        }
    }
}