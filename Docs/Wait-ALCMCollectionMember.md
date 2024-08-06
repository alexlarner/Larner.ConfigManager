---
external help file: Larner.ConfigManager-help.xml
Module Name: Larner.ConfigManager
online version:
schema: 2.0.0
---

# Wait-ALCMCollectionMember

## SYNOPSIS

Wait for a user/device to appear in a CM collection

## SYNTAX

```
Wait-ALCMCollectionMember [-MemberName] <String[]> [-CollectionName] <String> [[-CollectionType] <String>]
 [[-RefreshRateInSeconds] <Int32>] [-EnableException] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Wait for a user/device to appear in a CM collection, with status updates every 5 minutes or the time specified by **RefreshRateInSeconds**.

## EXAMPLES

### Example 1: Wait for a user to show up in a collection

```powershell
Wait-ALCMCollectionMember -MemberName $env:USERNAME -CollectionName 'PowerShell - User'
```

Waits for the current user to show up in the `PowerShell - User` collection

### Example 2: Wait for a user to show up in a collection and check every 10 minutes

```powershell
Wait-ALCMCollectionMember -MemberName $env:USERNAME -CollectionName 'Oracle Java SE Development Kit 11 - Device' -Verbose -RefreshRateInSeconds 600
```

Waits for the current user to show up in the `Oracle Java SE Development Kit 11 - Device` collection, giving status updates every 10 minutes.

### Example 3: Wait for multiple devices to show up in a collection

```powershell
Wait-ALCMCollectionMember -MemberName $MachineNames -CollectionName 'Microsoft Visual Studio Code - Device' -CollectionType Device
```

Waits for the machines in `$MachineNames` to show up in the `Microsoft Visual Studio Code - Device` device collection

## PARAMETERS

### -MemberName

Specify name of the device name or the username

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Name

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -CollectionName

Specify the name of the collection

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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
Position: 3
Default value: User
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
Position: 4
Default value: 300
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

### [String](https://learn.microsoft.com/en-us/dotnet/api/system.string)

The user name or device name to wait for

## OUTPUTS

### None

## NOTES

## RELATED LINKS

[Add-ALCMCollectionMember](Add-ALCMCollectionMember.md)
