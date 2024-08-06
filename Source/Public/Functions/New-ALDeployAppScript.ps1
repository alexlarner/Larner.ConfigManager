function New-ALDeployAppScript {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
		[string]
        $Name,

		[Parameter(Mandatory)]
		[string]
        $Publisher,

		[Parameter(Mandatory)]
		[string]
        $SoftwareVersion,

        [Parameter(Mandatory)]
        [string]
        $InstallMediaRootFolder,

        [Parameter(Mandatory)]
        [string]
        $ToolkitFolder,

        [switch]
        $Force,

        [switch]
        $EnableException
    )

    if ((Get-Location).Path -eq $script:CMDrive) {
        Set-Location
    }

    $InstallSourceFolder = Join-Path -Path $InstallMediaRootFolder -ChildPath $Publisher -AdditionalChildPath $Name, $SoftwareVersion

    $ScriptPath = Join-Path -Path $InstallSourceFolder -ChildPath 'Deploy-Application.ps1'

    if ((-Not (Test-Path $ScriptPath)) -or $Force) {
        if (-Not (Test-Path $InstallSourceFolder)) {
            Invoke-PSFProtectedCommand -Action 'Create install source folder' -Target $InstallSourceFolder -ScriptBlock {
                New-Item -Path $InstallSourceFolder -ItemType Directory -ErrorAction Stop | Out-Null
            }
        }
        Invoke-PSFProtectedCommand -Action "Copy toolkit folder contents to install source folder [$InstallSourceFolder]" -Target "$ToolkitFolder\*" -ScriptBlock {
            Copy-Item -Path "$ToolkitFolder\*" -Destination $InstallSourceFolder -Recurse -Force -ErrorAction Stop
        }
    }

    Invoke-PSFProtectedCommand -Action 'Get Deploy-Application script contents' -Target $ScriptPath -ScriptBlock {
        $ScriptContents = Get-Content $ScriptPath -ErrorAction Stop
    }

    $AppVariablesToPopulate = @{
        'Vendor' = $Publisher
        'Name' = $Name
        'Version' = $SoftwareVersion
    }

    foreach ($VarName in $AppVariablesToPopulate.Keys) {
        $ScriptContents = $ScriptContents.Replace("[String]`$app$VarName = ''", "[String]`$app$VarName = '$($AppVariablesToPopulate.$VarName)'")
    }

    $ScriptContents = $ScriptContents.Replace(
        "[String]`$appScriptDate = 'XX/XX/20XX'",
        "[String]`$appScriptDate = '$((Get-Date).ToShortDateString())'"
    )

    $ScriptContents = $ScriptContents.Replace(
        "[String]`$appScriptAuthor = '<author name>'",
        "[String]`$appScriptAuthor = '$env:USERFULLNAME'"
    )


    Invoke-PSFProtectedCommand -Action 'Saving updated Deploy-Application script' -Target $ScriptPath -ScriptBlock {
        $ScriptContents | Out-File -FilePath $ScriptPath -Force -ErrorAction Stop
    }

    Set-Location $script:CMDrive
}