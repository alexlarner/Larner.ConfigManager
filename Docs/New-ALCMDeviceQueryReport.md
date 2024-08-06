---
external help file: Larner.ConfigManager-help.xml
Module Name: Larner.ConfigManager
online version:
schema: 2.0.0
---

# New-ALCMDeviceQueryReport

## SYNOPSIS

Creates a report of the devices in a Config Manager query

## SYNTAX

```
New-ALCMDeviceQueryReport [-Name] <String[]> [[-Path] <String>] [-EnableException] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

Creates a text file:

- Listing all the names of the devices for a given query
    - With 1 row per name
- Named like `[Query Name] - Device Report - [UTC Time].txt`

Also creates/appends to a Excel spreadsheet:

- Listing the count of the machines for the query and the UTC Date & Time
    - In a 2-column table (`Count` & `UTCDateTime`)
- Including a line graph to track the count over time
- Named like `[Query Name] - Device Report Summary.xlsx`

## EXAMPLES

### Example 1: Create reports for the a single query

```powershell
New-ALCMDeviceQueryReport -Name 'Microsoft Azure Information Protection'
```

- Creates a text file named `"Microsoft Azure Information Protection - Device Report - $($UTCDateTime.ToString('yyyy-MM-ddTHH-mm-ssZ')).txt"` listing all the devices found by the query
- Creates a Excel spreadsheet named `Microsoft Azure Information Protection - Device Report Summary.xlsx` listing & graphing the count of the devices and the date of the query invocation.
    - If the file already exists, the new data will simply be appended.
- Both are created in the `$env:USERPROFILE\Documents` folder.

### Example 2: Create reports for multiple queries

```powershell
'Camtasia', 'Snagit' | New-ALCMDeviceQueryReport -Path C:\Temp
```

- Creates two text files each listing all the devices found by their query, named:
    - `"Camtasia - Device Report - $($UTCDateTime.ToString('yyyy-MM-ddTHH-mm-ssZ')).txt"`
    - `"Snagit - Device Report - $($UTCDateTime.ToString('yyyy-MM-ddTHH-mm-ssZ')).txt"`
- Creates two Excel spreadsheets name listing & graphing the count of the devices and the date of the query invocation, named:
    - `Camtasia - Device Report Summary.xlsx`
    - `Snagit - Device Report Summary.xlsx`
    - If the file already exists, the new data will simply be appended.
- Both are created in the `C:\Temp` folder.

## PARAMETERS

### -Name

The name of the query to get the devices from

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: QueryName

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Path

The path to the folder to place the reports in.
It will be created if it does not exist.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: $env:USERPROFILE\Documents
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnableException

Replaces user friendly yellow warnings with bloody red exceptions of doom! Use this if you want the function to throw terminating errors you want to catch.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf

Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### [String[]](https://learn.microsoft.com/en-us/dotnet/api/system.string)

The names of the queries to get the devices from

## OUTPUTS

### None

## NOTES

## RELATED LINKS

[New-ALCMInstalledAppQuery](New-ALCMInstalledAppQuery.md)
