---
external help file: Larner.ConfigManager-help.xml
Module Name: Larner.ConfigManager
online version:
schema: 2.0.0
---

# Group-ALCMInstalledAppQueryResults

## SYNOPSIS

Gets the results of an installed app query and groups it by software name & version or just the name.

## SYNTAX

```
Group-ALCMInstalledAppQueryResults [-QueryName] <String[]> [[-GroupOn] <String>] [[-SortOn] <String>]
 [-EnableException] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Gets the results of an installed app query and groups it by software name & version or just the name.

## EXAMPLES

### Example 1: Get the query report

```powershell
Get-ALCMQueryReport -QueryName 'Adobe Acrobat'
```

### Example 2: Get the query report grouped and sorted by the software version

```powershell
Get-ALCMQueryReport -QueryName 'Adobe Acrobat' -GroupOn 'Software Version'
```

### Example 3: Get the query report sorted on version name

```powershell
Get-ALCMQueryReport -QueryName 'Adobe Acrobat' -GroupOn 'Software Version' -SortOn Name
```

## PARAMETERS

### -QueryName

The name of the query to get the results from.

The query must retrieve at least these properties:

- **SMS_G_System_INSTALLED_SOFTWARE.ARPDisplayName**
- **SMS_G_System_INSTALLED_SOFTWARE.ProductVersion**

Any query created by [New-ALCMInstalledAppQuery](New-ALCMInstalledAppQuery.md) is guaranteed to work.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GroupOn

The property to group the results on. `-Software Version` will actually group them first by software name then by the software version.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Software Name
Accept pipeline input: False
Accept wildcard characters: False
```

### -SortOn

The property to sort the results on:

- `Count`: The number of devices the app is installed on
- `Name`: The version number of the application

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Count
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

### None

## OUTPUTS

### None

## NOTES

## RELATED LINKS

[New-ALCMInstalledAppQuery](New-ALCMInstalledAppQuery.md)
