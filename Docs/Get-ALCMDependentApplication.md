---
external help file: Larner.ConfigManager-help.xml
Module Name: Larner.ConfigManager
online version:
schema: 2.0.0
---

# Get-ALCMDependentApplication

## SYNOPSIS

Gets the applications that depend on the given application

## SYNTAX

### Object (Default)

```
Get-ALCMDependentApplication -Application <WqlResultObject[]>
 [-AllApplicationsWithDependencies <WqlResultObject[]>] [-OutputType <String[]>] [-EnableException] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### Name

```
Get-ALCMDependentApplication -ApplicationName <String[]>
 [-AllApplicationsWithDependencies <WqlResultObject[]>] [-OutputType <String[]>] [-EnableException] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Gets the applications that depend on the given application

If `-AllApplicationsWithDependencies` is not specified, the function will take over 10 minutes to run because it has to look for dependencies on every app.

To get the dependencies a given application has, use [Get-ALCMApplicationDependency](Get-ALCMApplicationDependency.md).

## EXAMPLES

### Example 1: Get the dependent application names

```powershell
Get-CMApplication 'Microsoft 365 Apps for Enterprise x64' | Get-ALCMDependentApplication -AllApplicationsWithDependencies $AllApplicationsWithDependencies -OutputType Name
```

```Output
Office Timeline
Azure DevOps Integration Tool for Office 2019
Corptax Office
```

### Example 2: Get the dependent application objects

```powershell
Get-ALCMDependentApplication -ApplicationName 'Microsoft Office 2016 ProPlus' -AllApplicationsWithDependencies $AllApplicationsWithDependencies -OutputType Object | Format-Table LocalizedDisplayName, Manufacturer, SoftwareVersion, DateLastModified, DateCreated -AutoSize
```

```Output
LocalizedDisplayName                          Manufacturer SoftwareVersion DateLastModified     DateCreated
--------------------                          ------------ --------------- ----------------     -----------
Microsoft Office 2016 Language Pack - Spanish                              8/8/2018 8:57:14 AM  3/29/2017 2:13:35 PM
SAP BusinessObjects 2,8                       SAP          2.8.0.2058      4/29/2022 7:08:07 AM 3/9/2020 2:24:17 PM
```

## PARAMETERS

### -Application

The application object to get the dependency relationships from. To get this object, use the [Get-CMApplication](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/get-cmapplication) cmdlet.

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
$AllApplicationsWithDependencies = Get-CMApplication |
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

### -OutputType

The type of properties to return in the ouput; the **LocalizedDisplayName** of the applications or the full object.

Setting the `-OutputType` to `Name` is not more efficient. It just expands the **LocalizedDisplayName** on the **Requires** & **RequiredBy** objects.

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

The name of the application or an object with a **Name** property

### Microsoft.ConfigurationManagement.ManagementProvider.WqlQueryEngine.WqlResultObject[]

The application object, i.e. the output of [Get-CMApplication](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/get-cmapplication)

## OUTPUTS

### [String](https://learn.microsoft.com/en-us/dotnet/api/system.string)

The **LocalizedDisplayName** of the application

### Microsoft.ConfigurationManagement.ManagementProvider.WqlQueryEngine.WqlResultObject

The application object, i.e. the same type as the output of `Get-CMApplication -ModelName $AppModelName`

## NOTES

## RELATED LINKS

[Get-ALCMApplicationDependency](Get-ALCMApplicationDependency.md)
