---
external help file: Larner.ConfigManager-help.xml
Module Name: Larner.ConfigManager
online version:
schema: 2.0.0
---

# Remove-ALCMApplication

## SYNOPSIS

Removes an application and its device collections from Config Manager.

## SYNTAX

```
Remove-ALCMApplication [-Application] <WqlResultObject[]> [-EnableException] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

Use this function to remove an application and its collections from Config Manager.

This assumes that the collections are named like at least one of these:

- `$Application.LocalizedDisplayName`
- `"$($Application.LocalizedDisplayName) - Device"`
- `"$($Application.LocalizedDisplayName) - User"`

## EXAMPLES

### Example 1: Removes an app

```powershell
Remove-ALCMApplication -Application (Get-CMApplication PowerShell)
```

Removes the `PowerShell` application and any of these collections if they exist:

- `PowerShell`
- `PowerShell - Device`
- `PowerShell - User`

### Example 2: Removes multiple apps

```powershell
$Apps = 'Git', 'PowerShell' | ForEach-Object { Get-CMApplication -Name $_ }
Remove-ALCMApplication $Apps
```

Removes the `Git` and `PowerShell` applications and their collections

### Example 3: Removes multiple apps using the pipeline

```powershell
'Git', 'PowerShell' | ForEach-Object { Get-CMApplication -Name $_ } | Remove-ALCMApplication
```

Removes the `Git` and `PowerShell` applications and their collections, using the pipeline

## PARAMETERS

### -Application

Specify an application object to remove.
To get this object, use the [Get-CMApplication](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/get-cmapplication) cmdlet.

```yaml
Type: WqlResultObject[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
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

### Microsoft.ConfigurationManagement.ManagementProvider.WqlQueryEngine.WqlResultObject

You can pipe Config Manager applications from [Get-CMApplication](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/get-cmapplication) or [New-CMApplication](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/new-cmapplication) to this function.

## OUTPUTS

### None

## NOTES

## RELATED LINKS
