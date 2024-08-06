---
external help file: Larner.ConfigManager-help.xml
Module Name: Larner.ConfigManager
online version:
schema: 2.0.0
---

# Get-ALADGroupCMConnection

## SYNOPSIS

Gets the CM collections & apps tied to an AD group

## SYNTAX

```
Get-ALADGroupCMConnection [-Name] <String[]> [[-OutputType] <String>] [-ExcludeDisabledDeployments]
 [-ExcludeRetiredApps] [[-AllCollections] <WqlResultObject[]>] [-EnableException] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

Gets the CM collections that mention the specified AD group in one of their queries and gets the CM apps that have a deployment to one of those queries.

To exclude the disabled app deployments use `-ExcludeDisabledDeployments`.

To exclude the retired apps use `-ExcludeRetiredApps`.

This does not include applications that are dependencies for other applications.

This must be run from the CM drive, i.e. `Set-Location "$(Get-PSDrive -PSProvider CMSITE):\"`

## EXAMPLES

### Example 1: Get fresh unfiltered results

```powershell
Get-ALADGroupCMConnection -Name 'PKG - PowerShell'
```

```Output
ADGroup          DirectCollections                        IndirectCollections Applications
-------          -----------------                        ------------------- ------------
PKG - PowerShell {PowerShell - Device, PowerShell - User}                     PowerShell
```

Get the direct & indirect collections and applications tied to the `PKG - PowerShell` AD group

### Example 2: Lookup multiple AD groups using a saved listing

```powershell
$AllCollections = Get-CMCollection
Get-ALADGroupCMConnection -Name 'PKG - Spreadsheet Server Suite - C', 'PKG - Spreadsheet Server Suite - U' -AllCollections $AllCollections
 -Name 'PKG - Camtasia 2023', 'PKG - Camtasia Uninstall' -AllCollections $AllCollections
```

```Output
ADGroup                  DirectCollections                              IndirectCollections Applications
-------                  -----------------                              ------------------- ------------
PKG - Camtasia 2023      {Camtasia 2023 - Device, Camtasia 2023 - User}                     Camtasia 2023
PKG - Camtasia Uninstall Camtasia Uninstall                                                 Camtasia Uninstall
```

Get the collections and applications tied to the Camtasia PKG AD groups, using a cached listing of the all collections in CM.

### Example 3: Do a wildcard connection lookup

```powershell
Get-ADGroup -Filter { Name -like 'PKG - Oracle Java SE Development Kit*' } | Get-ALADGroupCMConnection -AllCollections $AllCollections
```

```Output
ADGroup                                 DirectCollections                                                                      IndirectCollections Applications
-------                                 -----------------                                                                      ------------------- ------------
PKG - Oracle Java SE Development Kit 11 {Oracle Java SE Development Kit 11 - User, Oracle Java SE Development Kit 11 - Device}                     Oracle Java SE Development Kit 11
PKG - Oracle Java SE Development Kit 8  {Oracle Java SE Development Kit 8 - User, Oracle Java SE Development Kit 8 - Device}                       Oracle Java SE Development Kit 8
```

Get the collections, deployments, and applications tied to the `Avaya` PKG groups.

### Example 4: Get connections to empty AD groups excluding disabled & retired apps

```powershell
Get-ADGroup -Filter { Name -like 'PKG - *' } |
    Where-Object { $null -eq ($_ | Get-ADGroupMember) } |
        Get-ALADGroupCMConnection -AllCollections $AllCollections -ExcludeDisabledDeployments -ExcludeRetiredApps |
            Format-List
```

Get all the collections & applications tied to any empty `PKG - *` AD group, excluding the disabled deployments & retired apps.

## PARAMETERS

### -Name

The name of the AD group to look for connections for.

This intentionally does not support wildcards. If you need wildcard support, do it on a filter attached to a Get-ADGroup call and pipe the results of that to this command.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -OutputType

The type of properties to return in the ouput. i.e. Should they be the names from the objects (collection & application), or should the be the full (collection, deployment, and application) objects.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Name
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExcludeDisabledDeployments

Exclude deployments that are disabled and exclude the apps whose only deployments to the collection are disabled. This will not exclude the collections that are only tied to a disabled deployment.

So, if the AD group is only tied to collections with disabled deployments, no apps will be listed, but those collections will be listed.

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

### -ExcludeRetiredApps

Exclude the apps that are retired.

Does not work unless the `OutputType` is set to `Object`

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

### -AllCollections

Specify a variable containing all the collections in the environment, i.e. the output of [Get-CMCollection](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/get-cmcollection).

If this is not specified, all the collections will be gathered which takes about 2 minutes.

This is so that you can get all the collections once, save them to a variable, then run this function multiple times with different parameters.

```yaml
Type: WqlResultObject[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: (Get-CMCollection -ErrorAction Stop)
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

The name of the AD group to look for connections for.

You can pipe either the names of the AD groups or objects with a name property (i.e. the output from [Get-ADGroup](https://learn.microsoft.com/en-us/powershell/module/activedirectory/get-adgroup)) to `Get-ALADGroupCMConnection`.

## OUTPUTS

### PSCustomObject

Will contain these properties:

- **ADGroup**
- **DirectCollections**
- **IndirectCollections**
- **Deployments**
    - Only if `-OutputType` is set to `Object`
- **Applications**

These properties will be just a name (instead of the full object) unless `-OutputType` is set to `Object`:

- **DirectCollections**
- **IndirectCollections**
- **Applications**

## NOTES

## RELATED LINKS

[Get-ALCMCollectionReference](Get-ALCMCollectionReference.md)

[New-ALCMAppADGroup](New-ALCMAppADGroup.md)
