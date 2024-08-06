---
external help file: Larner.ConfigManager-help.xml
Module Name: Larner.ConfigManager
online version:
schema: 2.0.0
---

# Invoke-ALCMApplicationRetirement

## SYNOPSIS

Retires an app

## SYNTAX

### Object

```
Invoke-ALCMApplicationRetirement -Application <WqlResultObject[]>
 [-AllApplicationsWithDependencies <WqlResultObject[]>] [-AllCollections <WqlResultObject[]>]
 [-RetiredAppFolderPath <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name

```
Invoke-ALCMApplicationRetirement -ApplicationName <String[]>
 [-AllApplicationsWithDependencies <WqlResultObject[]>] [-AllCollections <WqlResultObject[]>]
 [-RetiredAppFolderPath <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Retires an app with these steps:

- Remove any dependency relationships that other apps have on the app
- Mark AD groups for deletion
- For collections that aren't attached to any other app:
    - Remove it as an Exclude/Include membership rule for any other collection
    - Disable the refresh on the collection
    - Move it to the User/Device `Retired Collections` folder
- Remove deployments
- Move app to the retired apps folder

You will still need to manually right-click the app and hit `Retire`

## EXAMPLES

### Example 1: Retire a CM app

```powershell
Invoke-ALCMApplicationRetirement -Application (Get-CMApplication 'DAX Studio 3.0.5')
```

### Example 2: Retire a CM app via the pipeline

```powershell
Get-CMApplication 'DAX Studio*' | Invoke-ALCMApplicationRetirement
```

## PARAMETERS

### -Application

The application object to retire. To get this object, use the [Get-CMApplication](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/get-cmapplication) cmdlet.

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
Default value: (Get-CMCollection)
Accept pipeline input: False
Accept wildcard characters: False
```

### -RetiredAppFolderPath

The path in CM to the `Retired Applications` folder. It must exist.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Application\Retired Applications
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

[Get-ALCMDependentApplication](Get-ALCMDependentApplication.md)

[Get-ALCMDependentCollection](Get-ALCMDependentCollection.md)

[Remove-ALCMDependentApplication](Remove-ALCMDependentApplication.md)
