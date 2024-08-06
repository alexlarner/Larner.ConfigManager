---
external help file: Larner.ConfigManager-help.xml
Module Name: Larner.ConfigManager
online version:
schema: 2.0.0
---

# Get-ALCMAppInfoForArchiving

## SYNOPSIS

Gets the info needed about an app to determine how to archive it

## SYNTAX

### Name

```
Get-ALCMAppInfoForArchiving -AppName <String[]> [<CommonParameters>]
```

### Object

```
Get-ALCMAppInfoForArchiving -Application <WqlResultObject[]> [<CommonParameters>]
```

## DESCRIPTION

Gets these from the app:

- **LocalizedDisplayName**
- **Manufacturer**
- **SoftwareVersion**

Gets these from each of the app's deployment types:

- **LocalizedDisplayName**
- **Location**
- **InstallCommandLine**
- **UninstallCommandLine**

## EXAMPLES

### Example 1

```powershell
Get-ALCMAppInfoForArchiving -AppName 'Cisco Secure Client - AnyConnect VPN'
```

```Output
LocalizedDisplayName : Cisco Secure Client - AnyConnect VPN
Manufacturer         : Cisco Systems, Inc.
SoftwareVersion      : 5.1.3.62

LocalizedDisplayName : Cisco Secure Client - AnyConnect VPN
Location             : \\[Root CM Install Media Path]\Cisco Systems, Inc\Cisco Secure Client - AnyConnect VPN\5.1.3.62\
InstallCommandLine   : Deploy-Application.exe
UninstallCommandLine : Deploy-Application.exe -DeploymentType Uninstall
```

## PARAMETERS

### -AppName

The name of the application

```yaml
Type: String[]
Parameter Sets: Name
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Application

The application to get the info about.

To get this object, use the [Get-CMApplication](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/get-cmapplication) cmdlet.

```yaml
Type: WqlResultObject[]
Parameter Sets: Object
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### [String[]](https://learn.microsoft.com/en-us/dotnet/api/system.string)

The name of the application

### Microsoft.ConfigurationManagement.ManagementProvider.WqlQueryEngine.WqlResultObject[]

The application object from [Get-CMApplication](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/get-cmapplication).

## OUTPUTS

### None

## NOTES

## RELATED LINKS

[Add-ALCMDeploymentTypeXMLInfo](Add-ALCMDeploymentTypeXMLInfo.md)
