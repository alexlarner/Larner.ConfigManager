---
external help file: Larner.ConfigManager-help.xml
Module Name: Larner.ConfigManager
online version:
schema: 2.0.0
---

# Remove-ALCMDependentApplication

## SYNOPSIS

Removes any dependency groups that contain the specified application.

## SYNTAX

### Object (Default)

```
Remove-ALCMDependentApplication -Application <WqlResultObject[]>
 [-AllApplicationsWithDependencies <WqlResultObject[]>] [-EnableException] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Name

```
Remove-ALCMDependentApplication -ApplicationName <String[]>
 [-AllApplicationsWithDependencies <WqlResultObject[]>] [-EnableException] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

Removes any dependency groups that contain the specified application by looking through all applications with dependencies.

This does not remove the dependencies that the given application has. It only removes the dependencies that other apps have on it.

If `AllApplicationsWithDependencies` is not specified, **the function will take over 10 minutes to run** because it has to look for dependencies on every app.

## EXAMPLES

### Example 1: Remove dependencies from an app

```powershell
Remove-ALCMDependentApplication -ApplicationName 'Microsoft Silverlight'
```

Removes any dependency that any app has on `Microsoft Silverlight`. This does **not** remove any dependencies that `Microsoft Silverlight` has.

### Example 2: Remove dependencies from an app using a saved list of all the apps and their dependencies

```powershell
Remove-ALCMDependentApplication -ApplicationName 'Crystal XI Runtime' -AllApplicationsWithDependencies $AllApplicationsWithDependencies
```

Removes any dependency that any app has on `Crystal XI Runtime`. This does **not** remove any dependencies that `Crystal XI Runtime` has.

### Example 3: Remove dependencies from apps matching a wildcard search

```powershell
Get-CMApplication -Name 'Microsoft Visual C++*' | Remove-ALCMDependentApplication -AllApplicationsWithDependencies $AllApplicationsWithDependencies
```

Removes any dependency that any app has on any app whose name starts with `Microsoft Visual C++`. This does **not** remove any dependencies that any `Microsoft Visual C++*` app has.

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

### -AllApplicationsWithDependencies

An array containing all the applications in the environment that have dependencies.
The application objects must contain a custom added property called **Dependencies**.
To get this array use this code which will **take over 10 minutes to run**:

```powershell
Get-CMApplication |
    ForEach-Object {
        Add-Member -InputObject $_ -NotePropertyName 'Dependencies' -NotePropertyValue (Get-ALCMApplicationDependency -Application $_ -OutputType ModelName)
    } |
        Where-Object Dependencies
```

```yaml
Type: WqlResultObject[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
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

### None

## NOTES

This uses [Get-ALCMDependentApplication](Get-ALCMDependentApplication.md) to get the application's relationships.

## RELATED LINKS

[Get-ALCMDependentApplication](Get-ALCMDependentApplication.md)