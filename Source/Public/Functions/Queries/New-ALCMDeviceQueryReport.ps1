function New-ALCMDeviceQueryReport {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [Alias('QueryName')]
        [string[]]
        $Name,

        [string]
        $Path = "$env:USERPROFILE\Documents",

        [switch]
        $EnableException
    )

    begin {
        Set-Location

        if (-Not (Test-Path $Path)) {
            Invoke-PSFProtectedCommand -Action 'Create export folder' -Target $Path -ScriptBlock {
                New-Item -Path $Path -ItemType Directory -ErrorAction Stop
            }
        }
    }
    process {
        if (Test-PSFFunctionInterrupt) { return }

        foreach ($QueryName in $Name) {
            Set-Location $script:CMDrive

            $UTCDateTime = (Get-Date).ToUniversalTime()

            Invoke-PSFProtectedCommand -Action 'Get query results' -Target $QueryName -ScriptBlock {
                $QueryResults = Get-CMQuery -Name $QueryName -ErrorAction Stop | Invoke-CMQuery -ErrorAction Stop
            } -Continue

            if ($null -eq $QueryResults) { Continue }

            $DeviceNames = $QueryResults.SMS_R_System.NetbiosName | Sort-Object -Unique

            $ExportName = "$QueryName - Device Report - $($UTCDateTime.ToString('yyyy-MM-ddTHH-mm-ssZ')).txt"
            $ExportPath = Join-Path $Path $ExportName

            Set-Location

            Invoke-PSFProtectedCommand -Action "Export list of $($DeviceNames.Count) device names from query results to [$ExportPath]" -Target $DeviceNames -ScriptBlock {
                $DeviceNames | Out-File $ExportPath -ErrorAction Stop
            }

            $ForExcel = [PSCustomObject]@{
                DeviceCount = $DeviceNames.Count
                UTCDateTime = $UTCDateTime
            }

            $ExcelPath = Join-Path $Path "$QueryName - Device Report Summary.xlsx"

            $ExcelSplat = @{
                Path          = $ExcelPath
                TableName     = 'Summary'
                AutoSize      = $true
                AutoNameRange = $true
            }

            if (Test-Path $ExcelPath) {
                Invoke-PSFProtectedCommand -Action "Append new data to existing spreadsheet at [$ExcelPath]" -Target $ForExcel -ScriptBlock {
                    $ForExcel | Export-Excel @ExcelSplat -Append
                }
            } else {
                $ChartDef = New-ExcelChartDefinition -XRange UTCDateTime -YRange DeviceCount -Title 'Device Count' -ChartType LineMarkers -NoLegend

                Invoke-PSFProtectedCommand -Action 'Create object for new spreadsheet' -ScriptBlock {
                    $Excel = $ForExcel | Export-Excel @ExcelSplat -ExcelChartDefinition $ChartDef -PassThru
                } -Continue

                $Excel.Sheet1.Drawings[0].DataLabel.ShowValue = $true
                $Excel.Sheet1.Drawings[0].DataLabel.Fill.Color = 'White'

                Invoke-PSFProtectedCommand -Action "Export spreadsheet to [$ExcelPath]" -Target $Excel -ScriptBlock {
                    Export-Excel -ExcelPackage $Excel
                }
            }
        }
    }
    end {
        Set-Location $script:CMDrive
    }
}