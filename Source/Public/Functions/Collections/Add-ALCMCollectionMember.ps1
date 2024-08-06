function Add-ALCMCollectionMember {
    [CmdletBinding(
        DefaultParameterSetName = 'AutoNaming',
        SupportsShouldProcess
    )]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [Alias('Name')]
        [string[]]
        $MemberName,

        [Parameter(
            ParameterSetName = 'AutoNaming',
            Mandatory
        )]
        [string]
        $AppName,

        [Parameter(
            ParameterSetName = 'ManualNaming',
            Mandatory
        )]
        [string]
        $CollectionName,

        [Parameter(ParameterSetName = 'AutoNaming')]
        [ValidateLength(3,3)]
		[string]
        $ADGroupPrefix = 'PKG',

        [Parameter(ParameterSetName = 'ManualNaming')]
        [string]
        $ADGroupName,

        [ValidateSet('Device', 'User')]
        [string]
        $CollectionType = 'User',

        [switch]
        $Wait,

        [int]
        $RefreshRateInSeconds = 300,

        [switch]
        $EnableException
    )

    begin {
        if ($PSCmdlet.ParameterSetName -eq 'AutoNaming') {
            switch ($CollectionType) {
                'Device' {
                    $PSBoundParameters.CollectionName = "$AppName - Device"
                }
                'User' {
                    $PSBoundParameters.CollectionName = "$AppName - User"
                }
            }
            $ADGroupName = "$ADGroupPrefix - $AppName"
        } else {
            if (-Not $ADGroupName) {
                $ADGroupName = "$ADGroupPrefix - $CollectionName"
            }
        }

        Invoke-PSFProtectedCommand -Action "Get AD group" -Target $ADGroupName -ScriptBlock {
            $ADGroup = Get-ADGroup $ADGroupName -ErrorAction Stop
        } -Continue

        $MemberNames = [System.Collections.Generic.List[string]]::New()
        $ADObjects = [System.Collections.Generic.List[PSObject]]::New()

        if (-Not $CollectionName) {
            $CollectionName = "$AppName - "
        }
    }
    process {
        foreach ($Name in $MemberName) {
            $MemberNames.Add($Name)

            Invoke-PSFProtectedCommand -Action "Get AD $($CollectionType.ToLower())" -Target $Name -ScriptBlock {
                $ADObject = switch ($CollectionType) {
                    'Device' { Get-ADComputer $Name -ErrorAction Stop }
                    'User' { Get-ADUser $Name -ErrorAction Stop }
                }
                $ADObjects.Add($ADObject)
            } -Continue
        }
    }
    end {
        Invoke-PSFProtectedCommand -Action "Add $($CollectionType.ToLower())s to [$ADGroupName] AD group" -Target $ADObjects -ScriptBlock {
            $ADGroup | Add-ADGroupMember -Members $ADObjects -ErrorAction Stop
        } -Continue

        if ($Wait) {
            $PassThruParams = $PSBoundParameters | ConvertTo-PSFHashtable -Include CollectionName, CollectionType, RefreshRateInSeconds, Verbose
            Wait-ALCMCollectionMember @PassThruParams -MemberName $MemberNames
        }
    }
}