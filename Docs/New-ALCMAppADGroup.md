---
external help file: Larner.ConfigManager-help.xml
Module Name: Larner.ConfigManager
online version:
schema: 2.0.0
---

# New-ALCMAppADGroup

## SYNOPSIS

Creates a AD group for a Config Manager App Deployment

## SYNTAX

```
New-ALCMAppADGroup [-AppName] <String[]> [[-ADGroupPrefix] <String>] [-EnableException]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Creates a AD group under `/CM/Packages` for a Config Manager App Deployment.

## EXAMPLES

### Example 1: Create an AD group

```powershell
New-ALCMAppADGroup -AppName 'ClickShare Desktop App Machine-Wide Installer'
```

Creates a `PKG - ClickShare Desktop App Machine-Wide Installer` AD group.

### Example 2: Create an AD group with a different prefix

```powershell
New-ALCMAppADGroup -AppName 'Update-PrinterServerMapping' -ADGroupPrefix 'UTL'
```

Creates a `UTL - Update-PrinterServerMapping` AD group

## PARAMETERS

### -AppName

The name of the app to make the AD group for

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Name

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -ADGroupPrefix

Specify the 3-letter prefix to use for the AD Group Name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: PKG
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

The name of the app to make the AD group for

## OUTPUTS

### None

## NOTES

## RELATED LINKS
