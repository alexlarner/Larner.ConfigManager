---
external help file: Larner.ConfigManager-help.xml
Module Name: Larner.ConfigManager
online version:
schema: 2.0.0
---

# New-ALDeployAppScript

## SYNOPSIS

Copies and customizes a `Deploy-Application` script (from [PSAppDeployToolkit](https://psappdeploytoolkit.com/docs/)) to include an application's metadata.

## SYNTAX

```
New-ALDeployAppScript [-Name] <String> [-Publisher] <String> [-SoftwareVersion] <String>
 [-InstallMediaRootFolder] <String> [-ToolkitFolder] <String> [-Force] [-EnableException] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

Use this function as a starting point for creating an application using the [PSAppDeployToolkit](https://psappdeploytoolkit.com/docs/).

It will create a folder under `$InstallMediaRootFolder\$Publisher\$Name\$SoftwareVersion` and copy the the contents of `$ToolkitFolder` to it.

It also populates these variables in the script:

- `appVendor` = `$Publisher`
- `appName` = `$Name`
- `appVersion` = `$SoftwareVersion`
- `appScriptDate` = `(Get-Date).ToShortDateString()`
- `appScriptAuthor` = `$env:USERFULLNAME`

## EXAMPLES

### Example 1: Create new Deploy-Application script

```powershell
New-ALDeployAppScript -Name Maven -Publisher 'Apache Software Foundation' -SoftwareVersion 3.8.4 -InstallMediaRootFolder 'C:\Install Media' -ToolkitFolder C:\Toolkit
```

Create a folder at `C:\Install Media\Apache Software Foundation\Maven\3.8.4`, copy the contents of `C:\Toolkit`, and update the metadata variables in the newly created Deploy-Application.ps1.

C:\Toolkit

### Example 2: Overwrite existing Deploy-Application script

```powershell
New-ALDeployAppScript -Name IDM -Publisher Honeywell -SoftwareVersion 4.9.0 -InstallMediaRootFolder 'C:\Install Media' -ToolkitFolder C:\Toolkit -Force
```

Creata a folder at `C:\Install Media\Honeywell\IDM\4.9.0`, copy the contents of `C:\Toolkit`, **overwriting** the toolkit contents that already exist there, and update the metadata variables in the newly created Deploy-Application.ps1.

## PARAMETERS

### -Name

The name of the application.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Publisher

Specify the name of the application's publisher.
Generally the name of the `Publisher` in the `Uninstall` key.

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

### -SoftwareVersion

The version number of the application.
Generally the version number from the `DisplayVersion` on the `Uninstall` key or the version number on the properties of the app's main EXE.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InstallMediaRootFolder

The root folder for CM's application content.
The Deploy App script will be a created in a folder under `$InstallMediaRootFolder\$Publisher\$Name\$SoftwareVersion`.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: C:\Install Media
Accept pipeline input: False
Accept wildcard characters: False
```

### -ToolkitFolder

The path to the Toolkit folder in the PSAppDeployToolkit folder to use.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force

Use to overwrite any PSAppDeployToolkit files that already exist in the target location.

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

### None

## OUTPUTS

### None

## NOTES

## RELATED LINKS
