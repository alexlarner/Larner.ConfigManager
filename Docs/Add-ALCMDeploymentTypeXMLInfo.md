---
external help file: Larner.ConfigManager-help.xml
Module Name: Larner.ConfigManager
online version:
schema: 2.0.0
---

# Add-ALCMDeploymentTypeXMLInfo

## SYNOPSIS

Parses some properties from the **SDMPackageXML** and adds them as new properties on the input object

## SYNTAX

```
Add-ALCMDeploymentTypeXMLInfo [-DeploymentType] <WqlResultObject[]> [<CommonParameters>]
```

## DESCRIPTION

Parses **Location**, **InstallCommandLine**, and **UninstallCommandLine** from the **SDMPackageXML** and adds them as new properties on the input object.

## EXAMPLES

### Example 1

```powershell
Get-CMApplication 'Adobe Acrobat' | Get-CMDeploymentType | Add-ALCMDeploymentTypeXMLInfo | Format-List
```

```Output
LocalizedDisplayName : Adobe Acrobat
Location             : \\[Root CM Install Media Path]\Adobe\Adobe Acrobat\24.002.20857\
InstallMediaExists   : True
InstallCommandLine   : Deploy-Application.exe
UninstallCommandLine : Deploy-Application.exe -DeploymentType Uninstall
```

## PARAMETERS

### -DeploymentType

The deployment type to add the select parsed **SDMPackageXML** properties to.
You can get this by running [Get-CMDeploymentType](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/get-cmdeploymenttype).

```yaml
Type: WqlResultObject[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Microsoft.ConfigurationManagement.ManagementProvider.WqlQueryEngine.WqlResultObject

The deployment type object, i.e. the output of [Get-CMDeploymentType](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/get-cmdeploymenttype)

## OUTPUTS

### ALDeploymentType

An extension of the **Microsoft.ConfigurationManagement.ManagementProvider.WqlQueryEngine.WqlResultObject** type

## NOTES

This changes the actual type of the input object to a custom type **ALDeploymentType** with it's own **DefaultDisplayPropertySet**.

## RELATED LINKS
