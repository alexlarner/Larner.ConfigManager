---
external help file: Larner.ConfigManager-help.xml
Module Name: Larner.ConfigManager
online version:
schema: 2.0.0
---

# Add-ALCMCollectionMember

## SYNOPSIS

Adds a user/device to a CM collection

## SYNTAX

### AutoNaming (Default)

```
Add-ALCMCollectionMember -MemberName <String[]> -AppName <String> [-ADGroupPrefix <String>]
 [-CollectionType <String>] [-Wait] [-RefreshRateInSeconds <Int32>] [-EnableException] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### ManualNaming

```
Add-ALCMCollectionMember -MemberName <String[]> -CollectionName <String> [-ADGroupName <String>]
 [-CollectionType <String>] [-Wait] [-RefreshRateInSeconds <Int32>] [-EnableException] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

Adds a user/device to a CM collection by adding it to the related AD group.

Due to the lag time between AD syncing within itself then syncing with CM, it generally takes at least 15 minutes before the user/device appears in the CM collection, so you can use the Wait parameter to wait until the user/device appears in the collection.

## EXAMPLES

### Example 1: Add by app name

```powershell
Add-ALCMCollectionMember -MemberName $env:USERNAME -AppName 'Snagit 2023' -CollectionType User
```

Adds the current user to the AD group `PKG - Snagit 2023` which adds them to the `Snagit 2023 - User` user collection

### Example 2: Add by collection name and wait until it appears

```powershell
Add-ALCMCollectionMember -MemberName $env:COMPUTERNAME -CollectionName 'Camtasia 2022' -Wait -Verbose -RefreshRateInSeconds 600
```

Adds the current device to the AD group `PKG - Camtasia 2022` which adds them to the `Camtasia 2022 - Device` user collection and waits until the user is found in the collection, giving status updates every 10 minutes.

### Example 3: Add multiple devices via the pipeline

```powershell
$Computers | Add-ALCMCollectionMember -CollectionName 'Microsoft Azure Information Protection UNINSTALL' -CollectionType Device
```

Adds the test machines in $Computers to the `PKG - Microsoft Azure Information Protection UNINSTALL` AD Group which adds them to the `Microsoft Azure Information Protection UNINSTALL` device collection

### Example 4: Add by collection name and AD group name override

```powershell
Add-ALCMCollectionMember -MemberName $env:USERNAME -CollectionName Minitab -ADGroupName 'TRK - MiniTab Users'
```

Adds the current user to the AD group `TRK - MiniTab Users` which adds them to the `Minitab` user collection

## PARAMETERS

### -MemberName

Specify name of the device name or the username

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Name

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -AppName

Specify the name of the app.
This will be used to determine the name of the AD group and the collection

```yaml
Type: String
Parameter Sets: AutoNaming
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CollectionName

Specify the name of the collection

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

### -ADGroupName

Specify the name of the AD group if it is something other than `PKG - $CollectionName`

```yaml
Type: String
Parameter Sets: ManualNaming
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CollectionType

Specify the type of the item you are adding

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

### -Wait

Specify this if you want to suppress the command prompt or retain the window until the user/device appears in the collection.

Use with -Verbose if you want to see status updates with every refresh.

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

### -RefreshRateInSeconds

The number of seconds to wait for the collection to finish updating before checking for the user/device to appear in the collection

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 300
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

### [String](https://learn.microsoft.com/en-us/dotnet/api/system.string)

The name of the user or device to add.

## OUTPUTS

### None

## NOTES

## RELATED LINKS

[New-ALCMCollection](New-ALCMCollection.md)

[Wait-ALCMCollectionMember](Wait-ALCMCollectionMember.md)
