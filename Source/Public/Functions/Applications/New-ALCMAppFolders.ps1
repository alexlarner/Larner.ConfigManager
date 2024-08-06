function New-ALCMAppFolders {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(ValueFromPipeline)]
        [string[]]
        $ApplicationFolderName,

        [Parameter(Mandatory)]
        [ValidateLength(1,256)]
        [string]
        $Publisher,

        [ValidateScript({
            $Folder = Get-CMFolder -FolderPath (Join-Path 'Application' $_)
            if ($Folder) {
                $true
            } else {
                throw "$_ does not exist"
            }
        })]
        [string]
        $ApplicationsRootFolderPath = 'Vendor',

        [switch]
        $EnableException
    )
    begin {
        $ApplicationsRootFolderFullPath = Join-Path 'Application' $ApplicationsRootFolderPath
        $PublisherApplicationsPath = Join-Path $ApplicationsRootFolderFullPath $Publisher

        if ($null -eq (Get-CMFolder -FolderPath $PublisherApplicationsPath)) {
            Invoke-PSFProtectedCommand -Action "Create CM folder for [$Publisher] applications" -Target $PublisherApplicationsPath -ScriptBlock {
                New-CMFolder -Name $Publisher -ParentFolderPath $ApplicationsRootFolderFullPath -ErrorAction Stop
            } -Continue
        }
    }
    process {
        foreach ($AppFolderName in $ApplicationFolderName) {
            $ApplicationPath = "$PublisherApplicationsPath\$AppFolderName"

            if ($null -eq (Get-CMFolder -FolderPath $ApplicationPath)) {
                Invoke-PSFProtectedCommand -Action "Create CM folder for [$AppFolderName] applications" -Target $ApplicationPath -ScriptBlock {
                    New-CMFolder -Name $AppFolderName -ParentFolderPath $PublisherApplicationsPath -ErrorAction Stop
                } -Continue
            }
        }
    }
}