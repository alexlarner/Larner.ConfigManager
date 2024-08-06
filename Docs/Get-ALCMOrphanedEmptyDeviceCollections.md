---
external help file: Larner.ConfigManager-help.xml
Module Name: Larner.ConfigManager
online version:
schema: 2.0.0
---

# Get-ALCMOrphanedEmptyDeviceCollections

## SYNOPSIS

Gets the empty device collections that are not related to any other collection and do not have a deployment linked.

## SYNTAX

### Pipeline (Default)

```
Get-ALCMOrphanedEmptyDeviceCollections [-AllCollections <WqlResultObject[]>] [-EnableException]
 [<CommonParameters>]
```

### Export

```
Get-ALCMOrphanedEmptyDeviceCollections [-Name <String>] -DestinationFolder <String>
 [-AllCollections <WqlResultObject[]>] [-EnableException] [<CommonParameters>]
```

## DESCRIPTION

Gets the empty device collections that are not listed as an include/exclude for any other collections and do not have a deployment linked.

## EXAMPLES

### Example 1: Get the orphaned empty collections and output to the console

```powershell
Get-ALCMOrphanedEmptyDeviceCollections
```

### Example 2: Get the orphaned empty collections and export them to a Excel spreadsheet

```powershell
Get-ALCMOrphanedEmptyDeviceCollections -DestinationFolder "$env:USERPROFILE\Downloads" -AllCollections $AllCollections
```

Creates an Excel spreadsheet with a WorkSheetName of `Collections` and a TableName of `Orphans` at `"$env:USERPROFILE\Downloads\Orphaned Empty Device Collections - $((Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH-mm-ssZ')).xlsx"`

## PARAMETERS

### -Name

The name for the exported file. This name will be appended with a UTC timestamp, i.e. `"$Name - $((Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH-mm-ssZ')).xlsx"`

```yaml
Type: String
Parameter Sets: Export
Aliases:

Required: False
Position: Named
Default value: Orphaned Empty Device Collections
Accept pipeline input: False
Accept wildcard characters: False
```

### -DestinationFolder

The folder to place the export in. It will be created if it doesn't exist.

```yaml
Type: String
Parameter Sets: Export
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AllCollections

Specify a variable containing all the collections in the environment, i.e. the output of [Get-CMCollection](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/get-cmcollection)

If this is not specified, all the collections will be gathered which takes about 2 minutes.

```yaml
Type: WqlResultObject[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: (Get-CMCollection -ErrorAction Stop)
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### [String](https://learn.microsoft.com/en-us/dotnet/api/system.string)

The names of the orphaned empty collections

## NOTES

## RELATED LINKS

[Get-ALCMCollectionReference](Get-ALCMCollectionReference.md)