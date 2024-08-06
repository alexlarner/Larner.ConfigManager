---
external help file: Larner.ConfigManager-help.xml
Module Name: Larner.ConfigManager
online version:
schema: 2.0.0
---

# New-ALCMAppFolders

## SYNOPSIS

Creates the application folders for the vendor and application if they don't exist.

## SYNTAX

```
New-ALCMAppFolders [[-ApplicationFolderName] <String[]>] [-Publisher] <String>
 [[-ApplicationsRootFolderPath] <String>] [-EnableException] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Creates the application folders for the vendor and application if they don't exist.

This should only be used for PatchMyPC applications, where the folders are needed first, so the `Move application to custom folder` can be set on the applications in PatchMyPC.

## EXAMPLES

### Example 1: Create app folders

```powershell
New-ALCMAppFolders -ApplicationFolderName 'Oracle Java SE Development Kit' -Publisher 'Oracle Corporation'
```

Creates these if they don't exist:

- `Oracle Corporation` folder under the `Vendor` applications folder.
- `Oracle Java SE Development Kit` folder under the `Oracle Corporation` applications folder.

### Example 2: Create app folders under a different root folder

```powershell
New-ALCMAppFolders -ApplicationFolderName 'VLC Media Player' -Publisher VideoLAN -ApplicationsRootFolderPath Testing
```

Creates these if they don't exist:

- `VideoLAN` folder under the `Testing` applications folder.
- `VLC Media Player` folder under the `VideoLAN` applications folder.

### Example 3: Create multiple app folders for the same publisher

```powershell
New-ALCMAppFolders -ApplicationFolderName 'Logitech Options', 'Logitech Unifying Software' -Publisher Logitech
```

Creates these if they don't exist:

- `Logitech` folder under the `Vendor` applications folder.
- `Logitech Options` & `Logitech Unifying Software` folders under the `Logitech` applications folder.

### Example 4: Create multiple app folders for the same publisher using the pipeline

```powershell
'Camtasia', 'Snagit' | New-ALCMAppFolders -Publisher 'TechSmith Corporation'
```

Creates these if they don't exist:

- `TechSmith Corporation` folder under the `Vendor` applications folder.
- `Camtasia` & `Snagit` folders under the `TechSmith Corporation` applications folder.

## PARAMETERS

### -ApplicationFolderName

Specify the name for the application folder.

Generally the name of the application in PatchMyPC minus any version specific info, i.e. `Oracle Java SE Development Kit` instead of `Oracle Java SE Development Kit 8 (x64)`.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Publisher

The exact name of the publisher in PatchMyPC.

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

### -ApplicationsRootFolderPath

Specifies the folder path to the root application folder: the folder containing all the application vendors` folders.

Do not include the site code (i.e. the result of `"$(Get-PSDrive -PSProvider CMSITE):\"`) or the object type (i.e. `Application`)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Vendor
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

The name for the application's folder (not the publisher level folder).

## OUTPUTS

### None

## NOTES

## RELATED LINKS
