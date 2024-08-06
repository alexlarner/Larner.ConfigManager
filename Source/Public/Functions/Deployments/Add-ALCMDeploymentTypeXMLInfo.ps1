function Add-ALCMDeploymentTypeXMLInfo {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [Microsoft.ConfigurationManagement.ManagementProvider.WqlQueryEngine.WqlResultObject[]]
        $DeploymentType
    )
    begin {
        Set-Location
    }
    process {
        foreach ($DT in $DeploymentType) {
            if (-Not $DT.SDMPackageXML) {
                Write-PSFMessage -Level Warning -Message "SDMPackageXML is blank for $($DT.LocalizedDisplayName)"
                Continue
            }

            [xml]$XML = $DT.SDMPackageXML

            $InstallCommandLine = $XML.AppMgmtDigest.DeploymentType.Installer.InstallAction.Args.Arg |
                Where-Object Name -eq 'InstallCommandLine' |
                    Select-Object -ExpandProperty '#text'

            $UninstallCommandLine = $XML.AppMgmtDigest.DeploymentType.Installer.UninstallAction.Args.Arg |
                Where-Object Name -eq 'InstallCommandLine' |
                    Select-Object -ExpandProperty '#text'

            $InstallLocation = $XML.AppMgmtDigest.DeploymentType.Installer.Contents.Content.Location

            $InstallMediaExists = Test-Path $InstallLocation

            $NewProps = @{
                Location = $XML.AppMgmtDigest.DeploymentType.Installer.Contents.Content.Location
                InstallMediaExists = $InstallMediaExists
                InstallCommandLine = $InstallCommandLine
                UninstallCommandLine = $UninstallCommandLine
            }

            $DT | Add-Member -NotePropertyMembers $NewProps -Force

            $DT.PSObject.TypeNames.Insert(0, 'ALDeploymentType')

            $DT
        }
    }
    end {
        Set-Location $script:CMDrive
    }
}