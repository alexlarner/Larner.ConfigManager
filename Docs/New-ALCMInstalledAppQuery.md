---
external help file: Larner.ConfigManager-help.xml
Module Name: Larner.ConfigManager
online version:
schema: 2.0.0
---

# New-ALCMInstalledAppQuery

## SYNOPSIS

Creates a query in Config Manager to detect applications in Add Remove Programs that match a Display Name pattern.

## SYNTAX

```
New-ALCMInstalledAppQuery [-Name] <String[]> [[-DisplayNamePattern] <String>]
 -LimitingCollection <WqlResultObject> [-EnableException] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Use this function to create a query in Configuration Manager and move it to the 'Software' query folder.

Configuration Manager queries define a WMI Query Language (WQL) expression to get information from the site database based on the criteria you provide.
WQL is similar to SQL, but still goes through the SMS Provider instead of directly to the database.
So WQL still abides by your role-based access configuration.

## EXAMPLES

### Example 1: Create a query for one app

```powershell
New-ALCMInstalledAppQuery -Name Git
```

Creates a query named `Git` that looks for applications with a display name like `Git` in Add/Remove Programs

### Example 2: Create queries for multiple apps

```powershell
New-ALCMInstalledAppQuery -Name Git, Brave
```

Creates queries for `Git` & `Brave`

### Example 3: Create queries for multiple apps using the pipeline

```powershell
'Git', 'Brave' | New-ALCMInstalledAppQuery
```

Creates queries for `Git` & `Brave` using the pipeline

### Example 4: Create a query with a custom SQL match pattern

```powershell
New-ALCMInstalledAppQuery -Name FileZilla -DisplayNamePattern 'FileZilla%'
```

Creates a query named `FileZilla` that looks for applications with a display name like `FileZilla%` in Add/Remove Programs

### Example 5: Create a query with different limiting collection

```powershell
New-ALCMInstalledAppQuery -Name Brave -LimitingCollection (Get-CMDeviceCollection -Name $LimitingCollectionName)
```

Creates a query named `Brave` that looks for applications with a display name like `Brave` in Add/Remove Programs on devices in the `$LimitingCollectionName` collection.

## PARAMETERS

### -Name

Specify the name of the query.

This should be the display name of the application in its `Uninstall` key.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -DisplayNamePattern

Specify the WQL pattern to match the display names from Add Remove Programs.
It will automatically be surrounded in double quotes in the query.

This defaults to the value provided in the **Name** parameter.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: True
```

### -LimitingCollection

Specify an object for the limiting collection.
To get this object, use the [Get-CMCollection](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/get-cmcollection) cmdlet.

```yaml
Type: WqlResultObject
Parameter Sets: (All)
Aliases:

Required: True
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

You can pipe the display names of applications from Add/Remove Programs to this function, so long as they do not need a separate display name pattern for the query.

## OUTPUTS

### Microsoft.ConfigurationManagement.ManagementProvider.WqlQueryEngine.WqlResultObject

## NOTES

Contains these predefined GUI settings for New-CMQuery:

- **Object Type**: `System Resource`
- **Comments**: `Looks for applications with a display name like '$DisplayNamePattern' in Add/Remove Programs`

This uses the [Microsoft created query](https://learn.microsoft.com/en-us/mem/configmgr/core/servers/manage/create-queries#computers-with-a-specific-software-package-installed)

## RELATED LINKS
