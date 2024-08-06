---
external help file: Larner.ConfigManager-help.xml
Module Name: Larner.ConfigManager
online version:
schema: 2.0.0
---

# New-ALCMCollection

## SYNOPSIS

Creates a device/user collection and a query membership rule for it in Config Manager.

## SYNTAX

### AutoNaming (Default)

```
New-ALCMCollection -Application <WqlResultObject[]> [-CollectionType <String>]
 [-ApplicationFolderName <String>] -LimitingCollection <WqlResultObject> [-RefreshType <CollectionRefreshType>]
 [-RefreshSchedule <WqlArrayItems>] [-ADGroupPrefix <String>] [-EnableException] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### ManualNaming

```
New-ALCMCollection -Application <WqlResultObject[]> [-CollectionName <String>] [-CollectionType <String>]
 [-ApplicationFolderName <String>] -LimitingCollection <WqlResultObject> [-RefreshType <CollectionRefreshType>]
 [-RefreshSchedule <WqlArrayItems>] -ADGroupName <String> [-EnableException] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

Use this function to create a device/user collection based on a specific limiting collection.
The limiting collection determines which devices can be a member of the device collection that you create.
For instance, when you use the All Systems collection as the limiting collection, the new collection can include any device in the Configuration Manager hierarchy.

A new collection cannot be created if a collection with the same name but a different type (User/Device) exists.

This function also creates a query membership rule.
A query rule lets you dynamically update the membership of a collection based on a query that is run on a schedule.

The collection will be created in a collection subfolder at `"[Device/User]Collection\Applications\$($App.Manufacturer)\$($Application.LocalizedDisplayName)"`.
The folders will be created if they don't exist.

## EXAMPLES

### Example 1: Create a user collection

```powershell
New-ALCMCollection -Application (Get-CMApplication 'Oracle Java SE Development Kit 8')
```

Creates a user collection called `Oracle Java SE Development Kit 8 - User` for the `Oracle Java SE Development Kit 8` application

### Example 2: Create a device collection

```powershell
New-ALCMCollection -Application (Get-CMApplication PowerShell) -CollectionType Device
```

Creates a device collection called `PowerShell - Device` for the `PowerShell` application

### Example 3: Create multiple collections

```powershell
'Git', 'PowerShell' | ForEach-Object { Get-CMApplication -Name $_ } | New-ALCMCollection -CollectionType Device
```

Creates device collections for the `PowerShell` and `Git` applications using the pipeline, called `PowerShell - Device` and `Git - Device` respectively

### Example 4: Create a collection and override the name of its folder

```powershell
New-ALCMCollection -Application (Get-CMApplication 'Snagit 2023') -ApplicationFolderName Snagit -CollectionType Device
```

Creates a device collection called `Snagit 2023 - Device` for the `Snagit 2023` application with the application-level device collection folder name overridden to `Snagit`

### Example 5: Create a collection that points to a non-PKG AD group

```powershell
New-ALCMCollection -Application (Get-CMApplication 'ManageEngine UEMS - Agent') -ADGroupName 'TRK - Remote Access Plus User'
```

Creates a user collection with the normal naming `ManageEngine UEMS - Agent - User`, but that queries off a different AD group `TRK - Remote Access Plus User`.

### Example 6: Create a collection with a different limiting collection

```powershell
$Splat = @{
    Application        = (Get-CMApplication PowerShell)
    LimitingCollection = (Get-CMDeviceCollection -Name $CollectionName)
    CollectionType     = 'Device'
}
New-ALCMCollection @Splat
```

Creates a device collection called `PowerShell - Device` for the `PowerShell` application, overriding the default limiting collection to be `$CollectionName`

### Example 7: Create a collection with a different refresh interval

```powershell
$Splat = @{
    Application     = (Get-CMApplication PowerShell)
    RefreshType     = 'Periodic'
    RefreshSchedule = (New-CMSchedule -RecurInterval Days -RecurCount 3)
    CollectionType  = 'Device'
}
New-ALCMCollection @Splat
```

Creates a device collection called `PowerShell - Device` for the `PowerShell` application that refreshes every 3 days instead of the default 7 days.

### Example 8: Create a device collection for a required deployment when the standard collection already exists

```powershell
$AppName = 'Citrix Workspace LTSR'
$CollectionName = "$AppName - Required"

$Splat = @{
    Application = (Get-CMApplication $AppName)
    ApplicationFolderName = 'Citrix Workspace'
    ADGroupName = "PKG - $CollectionName"
    CollectionName = $CollectionName
    CollectionType = 'Device'
}

New-ALCMCollection @Splat
```

Creates a device collection called `Citrix Workspace LTSR - Required` for an application that already has the standard collection (`Citrix Workspace LTSR - Device`).

## PARAMETERS

### -Application

Specify an application object to deploy.
To get this object, use the [Get-CMApplication](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/get-cmapplication) cmdlet.

This is used to:

- Find the corresponding AD group
- Name the new application & vendor device collection folders
- Name the new query membership rule

```yaml
Type: WqlResultObject[]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -CollectionName

Specify the name for the new collection.

The default is the Localized Display Name of the application appended with the collection type, i.e. `"$($Application.LocalizedDisplayName) - $CollectionType"`

```yaml
Type: String
Parameter Sets: ManualNaming
Aliases: Name

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CollectionType

Specify the type of collection to create. The collection type will be appended to the end of the collection name, i.e. `"$($Application.LocalizedDisplayName) - $CollectionType"`

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: User
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApplicationFolderName

Specify a name for the device collection app folder, to override the default name `$Application.LocalizedDisplayName`.
The maximum length is 256 characters.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
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

### -RefreshType

Specify how the collection membership is updated:

- `Manual` (1): An administrator manually triggers a membership update in the Configuration Manager console or with the [Invoke-CMCollectionUpdate](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/invoke-cmcollectionupdate) cmdlet.
- `Periodic` (2): The site does a full update on a schedule. It doesn't use incremental updates. If you don't specify a type, this value is the default.
- `Continuous` (4): The site periodically evaluates new resources and then adds new members. This type is also known as an incremental update. It doesn't do a full update on a schedule.
- `Both` (6): A combination of both `Periodic` and `Continuous`, with both incremental updates and a full update on a schedule.

If you specify either `Periodic` or `Both`, use the **RefreshSchedule** parameter to set the schedule.

The default value is `Periodic`.

```yaml
Type: CollectionRefreshType
Parameter Sets: (All)
Aliases:
Accepted values: None, Manual, Periodic, Continuous, Both

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RefreshSchedule

If you set the **RefreshType** parameter to either `Periodic` or `Both`, use this parameter to set the schedule.
Specify a schedule object for when the site runs a full update of the collection membership.
To get this object, use the [New-CMSchedule](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/new-cmschedule) cmdlet, i.e.

```powershell
New-CMSchedule -RecurInterval Days -RecurCount 3
```

The default value is 1 week.

```yaml
Type: WqlArrayItems
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ADGroupName

Specify the name of the AD group to look for in the query.

The default is `"$ADGroupPrefix - $($App.LocalizedDisplayName)"`.

```yaml
Type: String
Parameter Sets: ManualNaming
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ADGroupPrefix

Specify the 3-letter prefix of the AD Group's name

```yaml
Type: String
Parameter Sets: AutoNaming
Aliases:

Required: False
Position: Named
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

### Microsoft.ConfigurationManagement.ManagementProvider.WqlQueryEngine.WqlResultObject

You can pipe Config Manager applications from [Get-CMApplication](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/get-cmapplication) or [New-CMApplication](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/new-cmapplication) to this function.

## OUTPUTS

### Microsoft.ConfigurationManagement.ManagementProvider.WqlQueryEngine.WqlResultObject

The collection object returned from [New-CMCollection](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/new-cmcollection).

## NOTES

The query membership rule is set to see if the device/user is in the `$ADGroupName` AD group.

## RELATED LINKS
