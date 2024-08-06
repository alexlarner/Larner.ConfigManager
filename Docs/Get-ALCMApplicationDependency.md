---
external help file: Larner.ConfigManager-help.xml
Module Name: Larner.ConfigManager
online version:
schema: 2.0.0
---

# Get-ALCMApplicationDependency

## SYNOPSIS

Gets the dependencies that an application has

## SYNTAX

### Object

```
Get-ALCMApplicationDependency -Application <WqlResultObject[]> [-OutputType <String>] [-EnableException]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name

```
Get-ALCMApplicationDependency -ApplicationName <String[]> [-OutputType <String>] [-EnableException] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Gets the dependencies that an application has.

To get the applications have the specified application as a dependency, use [Get-ALCMDependentApplication](Get-ALCMDependentApplication.md).

## EXAMPLES

### Example 1: Get the applications that list this app as a dependecy

```powershell
Get-ALCMApplicationDependency -ApplicationName 'Flex-Excel Client'
```

### Example 2: Get the model name of the applications that list this app as a dependecy

```powershell
Get-CMApplication -Name 'ListenTalk Firmware' | Get-ALCMApplicationDependency -OutputType ModelName
```

## PARAMETERS

### -Application

The application object to get the dependency relationships from.

To get this object, use the [Get-CMApplication](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/get-cmapplication) cmdlet.

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

### -ApplicationName

The name of the application to get its dependency relationships.

```yaml
Type: String[]
Parameter Sets: Name
Aliases: Name

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -OutputType

The type of object to return in the ouput.

The `ModelName` of the application or the full object.

Choosing `ApplicationObject` will cause the function to run:

```powershell
Get-CMApplication -ModelName $AppModelName
```

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: ApplicationObject
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

The name of the application or an object with a Name property

### Microsoft.ConfigurationManagement.ManagementProvider.WqlQueryEngine.WqlResultObject[]

The application object, i.e. the output of [Get-CMApplication](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/get-cmapplication)

## OUTPUTS

### [String](https://learn.microsoft.com/en-us/dotnet/api/system.string)

The model name of the application

### Microsoft.ConfigurationManagement.ManagementProvider.WqlQueryEngine.WqlResultObject

The application object, i.e. the same type as the output of `Get-CMApplication -ModelName $AppModelName`

## NOTES

## RELATED LINKS

[Get-ALCMDependentApplication](Get-ALCMDependentApplication.md)