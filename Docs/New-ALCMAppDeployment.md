---
external help file: Larner.ConfigManager-help.xml
Module Name: Larner.ConfigManager
online version:
schema: 2.0.0
---

# New-ALCMAppDeployment

## SYNOPSIS

Creates an application deployment Config Manager

## SYNTAX

### AutoNaming (Default)

```
New-ALCMAppDeployment -Application <WqlResultObject[]> [-DeployPurpose <String>] [-DeployAction <String>]
 [-CollectionType <String>] [-UserNotification <String>] [-EnableException] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### ManualNaming

```
New-ALCMAppDeployment -Application <WqlResultObject[]> [-DeployPurpose <String>] [-DeployAction <String>]
 -CollectionName <String> [-UserNotification <String>] [-EnableException] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

Creates an application deployment for an existing application in Config Manager.

## EXAMPLES

### Example 1: Create an available device-based deployment

```powershell
New-ALCMAppDeployment -Application (Get-CMApplication PowerShell) -CollectionType Device
```

Creates an application deployment of `PowerShell` to the `PowerShell - Device` collection

### Example 2: Create available device-based deployments using the pipeline

```powershell
'Git', 'PowerShell' | ForEach-Object { Get-CMApplication -Name $_ } | New-ALCMAppDeployment -CollectionType Device
```

Creates application deployments for the `PowerShell` and `Git` applications using the pipeline, for the `PowerShell - Device` and `Git - Device` collections respectively

### Example 3: Create a required deployment

```powershell
New-ALCMAppDeployment -Application (Get-CMApplication TaxInterest) -DeployPurpose Required
```

Creates a `Required` application deployment for the `TaxInterest` application to the `TaxInterest - Device` collection

### Example 4: Create a deployment for an app with an exisiting available deployment

```powershell
New-ALCMAppDeployment -Application (Get-CMApplication 'Citrix Workspace LTSR') -CollectionName 'Citrix Workspace LTSR - Required' -DeployPurpose Required
```

## PARAMETERS

### -Application

Specify an application object to deploy.
To get this object, use the [Get-CMApplication](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/get-cmapplication) cmdlet.

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

### -DeployPurpose

Specify the deployment purpose:

- `Available`: The user sees the application in Software Center. They can install it on demand.
- `Required`: The client automatically installs the app according to the schedule that you set. If the application isn't hidden, a user can track its deployment status. They can also use Software Center to install the application before the deadline

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Available
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeployAction

Specify the deployment action, either to install or uninstall the application.
If competing deployments target the same device, the Install action takes priority.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Install
Accept pipeline input: False
Accept wildcard characters: False
```

### -CollectionType

Specify the type of collection to deploy to.
This is used to auto-determine the name of the collection to deploy to.

```yaml
Type: String
Parameter Sets: AutoNaming
Aliases:

Required: False
Position: Named
Default value: User
Accept pipeline input: False
Accept wildcard characters: False
```

### -CollectionName

Specify the name of the collection to which this application is deployed.

Default is a collection named `"$($Application.LocalizedDisplayName) - $CollectionType"`

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

### -UserNotification

Specifies the type of user notification.

- `DisplayAll`: Display in Software Center and show all notifications.
- `DisplaySoftwareCenterOnly`: Display in Software Center, and only show notifications of computer restarts.
- `HideAll`: Hide in Software Center and all notifications.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: DisplaySoftwareCenterOnly
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

You can pipe Config Manager applications from [Get-CMApplication](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/get-cmapplication) or [New-ALCMApplication](New-ALCMApplication.md) to this function.

## OUTPUTS

### Microsoft.ConfigurationManagement.ManagementProvider.WqlQueryEngine.WqlResultObject

## NOTES

Contains these predefined GUI settings for [New-CMApplicationDeployment](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/new-cmapplicationdeployment):

- **CollectionName**: `"$($Application.LocalizedDisplayName) - $CollectionType"` or `$CollectionName` if that parameter is used
- **Action**: Install
- **Schedule the application to be available at**: Now
- **User Notifications**: `Display in Software Center, and only show notifications for computer restarts`
- **Commit changes at deadline or during a maintenance window**: Yes

## RELATED LINKS
