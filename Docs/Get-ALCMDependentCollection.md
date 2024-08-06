---
external help file: Larner.ConfigManager-help.xml
Module Name: Larner.ConfigManager
online version:
schema: 2.0.0
---

# Get-ALCMDependentCollection

## SYNOPSIS

Gets the collections are linked to the given collection.

## SYNTAX

### Object (Default)

```
Get-ALCMDependentCollection -Collection <WqlResultObject[]> [-AllCollections <WqlResultObject[]>]
 [-OutputType <String[]>] [-EnableException] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name

```
Get-ALCMDependentCollection -CollectionName <String[]> [-AllCollections <WqlResultObject[]>]
 [-OutputType <String[]>] [-EnableException] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Gets the collections that use the given collection as a include/exclude membership rule.

## EXAMPLES

### Example 1: Get dependent collections

```powershell
Get-ALCMDependentCollection -CollectionName 'Deny - ManageEngine UEMS - Agent - Device' | Format-List
```

```Output
Input   : Deny - ManageEngine UEMS - Agent - Device
Exclude : ManageEngine UEMS - Agent - Device
Include :
```

### Example 2: Get dependent collections using a saved list of all collections

```powershell
Get-CMCollection -Name 'Druva inSync - Device' | Get-ALCMDependentCollection -AllCollections $AllCollections | Format-List
```

```Output
Input   : Druva inSync - Device
Exclude : Druva inSync Uninstall
Include :
```

## PARAMETERS

### -Collection

The collection object to get the dependent collections for. To get this object, use the [Get-CMCollection](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/get-cmcollection) cmdlet.

```yaml
Type: WqlResultObject[]
Parameter Sets: Object
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -CollectionName

The name of the collection to get the dependent collections for.

```yaml
Type: String[]
Parameter Sets: Name
Aliases: Name

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -AllCollections

Specify a variable containing all the collections in the environment, i.e. the output of [Get-CMCollection](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/get-cmcollection)

If this is not specified, all the collections will be gathered which takes about 2 minutes.

This is so that you can get all the collections once, save them to a variable, then run this function multiple times with different parameters.

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

### -OutputType

The type of properties to return in the ouput. i.e. The **name**s from the collections, or the full collection objects.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Name
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

The name of the collection or an object with a **Name** property

### Microsoft.ConfigurationManagement.ManagementProvider.WqlQueryEngine.WqlResultObject[]

The collection object, i.e. the output of [Get-CMCollection](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/get-cmcollection)

## OUTPUTS

### PSCustomObject[]

Contains these properties:

- **Input**
- **Exclude**
- **Include**

## NOTES

The `-OutputType` parameter should be removed, and a `ToString()` override should be set on each of the properties of the returned object.

## RELATED LINKS

[Get-ALCMCollectionReference](Get-ALCMCollectionReference.md)
