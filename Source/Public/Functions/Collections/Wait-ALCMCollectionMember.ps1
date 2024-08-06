function Wait-ALCMCollectionMember {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [Alias('Name')]
        [string[]]
        $MemberName,

        [Parameter(Mandatory)]
        [string]
        $CollectionName,

        [ValidateSet('Device', 'User')]
        [string]
        $CollectionType = 'User',

        [int]
        $RefreshRateInSeconds = 300,

        [switch]
        $EnableException
    )

    begin {
        $MemberNames = [System.Collections.Generic.List[string]]::New()

        $CurrentLocation = (Get-Location).Path
        if ($CurrentLocation -ne $script:CMDrive) {
            Set-Location $script:CMDrive
        }

        Invoke-PSFProtectedCommand -Action "Get names of current CM collection members" -Target $CollectionName -ScriptBlock {
            $CollectionMemberNames = switch ($CollectionType) {
                'Device' { Get-CMDevice -CollectionName $CollectionName -ErrorAction Stop | Select-Object -ExpandProperty Name }
                'User' { Get-CMUser -CollectionName $CollectionName -ErrorAction Stop | ForEach-Object { $_.SMSID.Split('\')[1] } }
            }
        } -Continue
    }

    process {
        foreach ($Name in $MemberName) {
            if ($Name -in $CollectionMemberNames) {
                Write-PSFMessage "[$Name] is already in the [$CollectionName] collection"
            } else {
                $MemberNames.Add($Name)
            }
        }
    }

    end {
        $MissingMemberNames = @($MemberNames | Where-Object { $_ -notin $CollectionMemberNames })

        $ItemTypeForMessage = if ($MissingMemberNames.Count -gt 1) {
            $CollectionType.ToLower() + 's'
        } else {
            $CollectionType.ToLower()
        }

        while ($MissingMemberNames.Count -gt 0) {
            Write-PSFMessage "Looking for $($MissingMemberNames.Count) $ItemTypeForMessage ($($MissingMemberNames -join ', ')) in the [$CollectionName] collection"

            Invoke-PSFProtectedCommand -Action "Update $CollectionType Collection Membership" -Target $CollectionName -ScriptBlock {
                Invoke-CMCollectionUpdate -Name $CollectionName -ErrorAction Stop
            }

            Write-PSFMessage "Waiting for collection to finish updating until $((Get-Date).AddSeconds($RefreshRateInSeconds).ToLongTimeString())"
            Start-Sleep $RefreshRateInSeconds

            Invoke-PSFProtectedCommand -Action "Get names of current CM collection members" -Target $CollectionName -ScriptBlock {
                $CollectionMemberNames = switch ($CollectionType) {
                    'Device' { Get-CMDevice -CollectionName $CollectionName -ErrorAction Stop | Select-Object -ExpandProperty Name }
                    'User' { Get-CMUser -CollectionName $CollectionName -ErrorAction Stop | ForEach-Object { $_.SMSID.Split('\')[1] } }
                }
            } -RetryCount 3 -Continue

            if ($null -eq ($MemberNames | Where-Object { $_ -notin $CollectionMemberNames })) { break }

            $MissingMemberNames = @($MemberNames | Where-Object { $_ -notin $CollectionMemberNames })

            $ItemTypeForMessage = if ($MissingMemberNames.Count -gt 1) {
                $CollectionType.ToLower() + 's'
            } else {
                $CollectionType.ToLower()
            }
        }

        if ($CurrentLocation -ne $script:CMDrive) { Set-Location $CurrentLocation }
    }
}