---
external help file: Larner.ConfigManager-help.xml
Module Name: Larner.ConfigManager
online version:
schema: 2.0.0
---

# Get-ALCMApplicationReference

## SYNOPSIS

Get the dependencies for the given app and any apps that depend on it

## SYNTAX

### Object (Default)

```text
Get-ALCMApplicationReference -Application <WqlResultObject[]>
 [-AllApplicationsWithDependencies <WqlResultObject[]>] [-OutputType <String[]>] [-EnableException] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### Name

```text
Get-ALCMApplicationReference -ApplicationName <String[]>
 [-AllApplicationsWithDependencies <WqlResultObject[]>] [-OutputType <String[]>] [-EnableException] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Get the dependencies for the given app using [Get-ALCMApplicationDependency](Get-ALCMApplicationDependency.md) and any apps that depend on it using [Get-ALCMDependentApplication](Get-ALCMDependentApplication.md)

## EXAMPLES

### Example 1: Get the references for an app

```powershell
Get-ALCMApplicationReference -ApplicationName 'Snagit 2024'
```

```Output
Application Requires         RequiredBy
----------- --------         ----------
Snagit 2024 Snagit Uninstall
```

### Example 2: Get the references for an app using a saved list of all apps with dependencies

```powershell
Get-ALCMApplicationReference -ApplicationName 'ListenTALK' -AllApplicationsWithDependencies $AllApplicationsWithDependencies
```

```Output
Application Requires                     RequiredBy
----------- --------                     ----------
ListenTALK  Microsoft Expression Encoder ListenTALK Firmware
```

## PARAMETERS

### -AllApplicationsWithDependencies

An array containing all the applications in the environment that have dependencies.

The application objects must contain a custom added property called **Dependencies**.

To get this array use this code which will take over 10 minutes to run:

```powershell
Get-CMApplication |
    ForEach-Object {
        Add-Member -InputObject $_ -NotePropertyName 'Dependencies' -NotePropertyValue (Get-ALCMApplicationDependency -Application $_ -OutputType ModelName) -Passthru
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

### -Application

The application to get the references for.

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

The name of the application to get the references for.

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

### -EnableException

Replaces user friendly yellow warnings with bloody red exceptions of doom!

Use this if you want the function to throw terminating errors you want to catch.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputType

The type of properties to return in the ouput. i.e. Should they be the names from the objects, or should the be the full objects.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:
Accepted values: Name, Object

Required: False
Position: Named
Default value: None
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Microsoft.ConfigurationManagement.ManagementProvider.WqlQueryEngine.WqlResultObject[]

The application object from [Get-CMApplication](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/get-cmapplication).

### System.String[]

The name of the application

## OUTPUTS

### System.Object

### PSCustomObject[]

Contains these properties:

- **Application**
- **Requires**
- **RequiredBy**

## NOTES

## RELATED LINKS

[Get-ALCMApplicationDependency](Get-ALCMApplicationDependency.md)

[Get-ALCMDependentApplication](Get-ALCMDependentApplication.md)
