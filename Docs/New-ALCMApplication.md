---
external help file: Larner.ConfigManager-help.xml
Module Name: Larner.ConfigManager
online version:
schema: 2.0.0
---

# New-ALCMApplication

## SYNOPSIS

Creates an app and all its necessary collections and deployments in Config Manager.

## SYNTAX

### PatchMyPC (Default)

```
New-ALCMApplication -Name <String> [-ApplicationFolderName <String>] -Publisher <String>
 [-DistributionPointGroupName <String[]>] [-ApplicationsRootFolderPath <String>] [-ADGroupPrefix <String>]
 [-DeployPurpose <String>] [-UserNotification <String>] [-CollectionType <String[]>]
 [-CollectionNameOverride <String>] [-AddPackagingTeamDeployment] [-EnableException]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ScratchScriptDetection

```
New-ALCMApplication -Name <String> [-ApplicationFolderName <String>] -Publisher <String>
 -SoftwareVersion <String> -Description <String> [-InstallCommand <String>] [-UninstallCommand <String>]
 [-ScriptLanguage <String>] -ScriptText <String> -Keyword <String[]> [-IconFile <FileInfo>]
 [-UserDocumentationLinkText <String>] [-UserDocumentationLink <String>] [-PrivacyPolicyURL <String>]
 -InstallMediaFolder <DirectoryInfo> -EstimatedRuntimeMins <Int32> -MaximumRuntimeMins <Int32>
 [-ReleaseDate <DateTime>] [-DistributionPointGroupName <String[]>] [-ApplicationsRootFolderPath <String>]
 [-ADGroupPrefix <String>] [-DeployPurpose <String>] [-UserNotification <String>] [-CollectionType <String[]>]
 [-CollectionNameOverride <String>] [-AddPackagingTeamDeployment] [-EnableException]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Scratch

```
New-ALCMApplication -Name <String> [-ApplicationFolderName <String>] -Publisher <String>
 -SoftwareVersion <String> -Description <String> [-InstallCommand <String>] [-UninstallCommand <String>]
 -DetectionClause <DetectionClause[]> -Keyword <String[]> [-IconFile <FileInfo>]
 [-UserDocumentationLinkText <String>] [-UserDocumentationLink <String>] [-PrivacyPolicyURL <String>]
 -InstallMediaFolder <DirectoryInfo> -EstimatedRuntimeMins <Int32> -MaximumRuntimeMins <Int32>
 [-ReleaseDate <DateTime>] [-DistributionPointGroupName <String[]>] [-ApplicationsRootFolderPath <String>]
 [-ADGroupPrefix <String>] [-DeployPurpose <String>] [-UserNotification <String>] [-CollectionType <String[]>]
 [-CollectionNameOverride <String>] [-AddPackagingTeamDeployment] [-EnableException]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Creates each of these if they don't already exist:

- Application AD Groups
- Application & Vendor Application Folders
- CM Application
- Script deployment type
- Application & Vendor Device & User Collection Folders
- Device & User-Based Collections
- Device & User-Based app deployments

Distributes the app to the distribution point groups and creates the deployments to the device group

Currently only works with EXE installers (i.e. `Deploy-Application.exe`).

## EXAMPLES

### Example 1: Create CM objects for app deployments for an existing PMPC app

```powershell
New-ALCMApplication -Name PowerShell -Publisher 'Tim Kosse' -AddPackagingTeamDeployment
```

Creates these for this PatchMyPC-sourced application:

- Application AD Groups
- Application & Vendor Application Folders
- Application & Vendor Device & User Collection Folders
- Device & User-Based Collections
- Device, User, and Packaging Team User-Based, app deployments

Does not create these as they were already created by PatchMyPC:

- CM Application
- Script deployment type

### Example 2: Create an available deployment to all users for a PMPC app

```powershell
New-ALCMApplication -Name 'ClickShare Desktop App Machine-Wide Installer' -Publisher 'Barco N.V.' -CollectionNameOverride $AllUsersCollectionName
```

Creates these for this PatchMyPC-sourced application:

- Application & Vendor Application Folders
- App deployment to the `$AllUsersCollectionName` collection

Does not create these as they were already created by PatchMyPC:

- CM Application
- Script deployment type

Does not create these because it's using an existing collection:

- Application AD Groups
- Application & Vendor Device & User Collection Folders
- Device & User-Based Collections
- Device, User, and Packaging Team User-Based, app deployments

### Example 3: Create CM objects for app deployments for an existing PMPC app with an app folder name override

```powershell
New-ALCMApplication -Name 'Camtasia 2022' -Publisher 'TechSmith Corporation' -ApplicationFolderName Camtasia -AddPackagingTeamDeployment
```

Creates these for this licensed PatchMyPC-sourced application:

- Application AD Groups
- Application & Vendor Application Folders
- Application & Vendor Device & User Collection Folders
- Device & User-Based Collections
- Device, User, and Packaging Team User-Based, app deployments

Does not create these as they were already created by PatchMyPC:

- CM Application
- Script deployment type

### Example 4: Create everything needed for a PSAppDeployToolkit MSI app

```powershell
$Name            = 'Winshuttle Studio'
$Publisher       = 'Winshuttle, LLC.'
$SoftwareVersion = '20.0301.2301.23003'

New-ALDeployAppScript -Name $Name -Publisher $Publisher -SoftwareVersion $SoftwareVersion

$DCSplat = @{
    ProductCode        = '{B3C28221-A51E-42F3-9BB7-8AB3C5905C0B}'
    PropertyType       = 'ProductVersion'
    ExpressionOperator = 'GreaterEquals'
    ExpectedValue      = $SoftwareVersion
    Value              = $true
}

$DetectionClause = New-CMDetectionClauseWindowsInstaller @DCSplat

$Splat = @{
    Name                       = $Name
    Publisher                  = $Publisher
    SoftwareVersion            = $SoftwareVersion
    DetectionClause            = $DetectionClause
    InstallMediaFolder         = "$InstallMediaRootFolder\$Publisher\$Name\$SoftwareVersion"
    Description                = 'Automate Studio is the premier Excel-to-SAP solutions platform that enables business users to manage SAP data in Excel for tasks like mass data changes and updates.'
    PrivacyPolicyURL           = 'https://www.precisely.com/legal/privacy-policy'
    UserDocumentationLink      = 'https://help.precisely.com/search/all?filters=Product_all~%2522Automate%257CAutomate+Studio%2522&content-lang=en-US'
    UserDocumentationLinkText  = 'Precisely Help Center'
    Keyword                    = @('Excel', 'SAP')
    EstimatedRuntimeMins       = 5
    MaximumRuntimeMins         = 15
    AddPackagingTeamDeployment = $true
}

New-ALCMApplication @Splat
```

Creates these for this MSI AppDeployToolkit installer:

- Application AD Groups
- Application & Vendor Application Folders
- CM Application
- Script deployment type
- Application & Vendor Device & User Collection Folders
- Device & User-Based Collections
- Device, User, and Packaging Team User-Based, app deployments

### Example 5: Create everything needed for a PSAppDeployToolkit non-MSI app

```powershell
$Name            = 'Git'
$Publisher       = 'The Git Development Community'
$SoftwareVersion = '2.39.2.1'
$DCSplat = @{
    FileName           = 'git-cmd.exe'
    Path               = 'C:\Program Files\Git'
    ExpectedValue      = '2.39.2.1'
    PropertyType       = 'Version'
    ExpressionOperator = 'GreaterEquals'
    Value              = $true
}

$DetectionClause = New-CMDetectionClauseFile @DCSplat

$Splat = @{
    Name               = $Name
    Publisher          = $Publisher
    SoftwareVersion    = $SoftwareVersion
    DetectionClause    = $DetectionClause
    InstallMediaFolder = "$InstallMediaRootFolder\$Publisher\$Name\$SoftwareVersion"
    IconFile           = "$InstallMediaRootFolder\$Publisher\$Name\$SoftwareVersion\SupportFiles\Git-Icon-1788C.png"
    Description        = 'Git is a free and open source distributed version control system designed to handle everything from small to very large projects with speed and efficiency.
Git is easy to learn and has a tiny footprint with lightning fast performance.
It outclasses SCM tools like Subversion, CVS, Perforce, and ClearCase with features like cheap local branching, convenient staging areas, and multiple workflows.'
    UserDocumentationLinkText  = 'Documentation'
    UserDocumentationLink      = 'https://git-scm.com/doc'
    Keyword                    = @('Git', 'Version Control')
    EstimatedRuntimeMins       = 5
    MaximumRuntimeMins         = 15
    AddPackagingTeamDeployment = $true
}

New-ALCMApplication @Splat
```

Creates these for this AppDeployToolkit EXE installer and it's file version detection:

- Application AD Groups
- Application & Vendor Application Folders
- CM Application
- Script deployment type
- Application & Vendor Device & User Collection Folders
- Device & User-Based Collections
- Device, User, and Packaging Team User-Based, app deployments

### Example 7: Create everything needed for a PSAppDeployToolkit MSI app with multiple editions with the same version number

```powershell
$Name                  = 'SolarWinds Agent - Workstation'
$ApplicationFolderName = 'SolarWinds Agent'
$Publisher             = 'SolarWinds Worldwide, LLC.'
$SoftwareVersion       = '123.4.2030.1'
$InstallSourceFolder   = "$InstallMediaRootFolder\$Publisher\$ApplicationFolderName\Workstation\$SoftwareVersion"

New-ALDeployAppScript -Name $Name -Publisher $Publisher -SoftwareVersion $SoftwareVersion -InstallSourceFolder $InstallSourceFolder

$DetectionClause = @()

$MsiDCSplat = @{
    ProductCode        = '{37729F61-EF1B-4CC6-AE55-2EF2540AC2E1}'
    PropertyType       = 'ProductVersion'
    ExpressionOperator = 'GreaterEquals'
    ExpectedValue      = $SoftwareVersion
    Value              = $true
}

$DetectionClause += New-CMDetectionClauseWindowsInstaller @MsiDCSplat

$RegDCSplat = @{
    Hive               = 'LocalMachine'
    KeyName            = "SOFTWARE\$($env:USERDNSDOMAIN.split('.')[0])\SolarWinds"
    ValueName          = 'AgentType'
    ExpectedValue      = 'Workstation'
    PropertyType       = 'String'
    ExpressionOperator = 'IsEquals'
    Value              = $true
    Is64Bit            = $false
}

$DetectionClause += New-CMDetectionClauseRegistryKeyValue @RegDCSplat

$Splat = @{
    Name                  = $Name
    Publisher             = $Publisher
    SoftwareVersion       = $SoftwareVersion
    DetectionClause       = $DetectionClause
    ApplicationFolderName = $ApplicationFolderName
    InstallMediaFolder    = $InstallSourceFolder
    Description           = @'
An SolarWinds Platform agent is software that provides a communication channel between the SolarWinds Platform server and a monitored computer.
Agents are used as an alternative to WMI or SNMP to provide information about selected devices and applications.

SAM uses SolarWinds Platform agents to gather information for component monitors (and their parent application monitors) from target servers across your environment.
Agents are also used to monitor servers hosted by cloud-based services such as Amazon EC2, Rackspace, Microsoft Azure, and other Infrastructure as a Service (IaaS) products.
'@
    PrivacyPolicyURL     = 'https://www.solarwinds.com/legal/privacy'
    Keyword              = @('Agent', 'Monitoring')
    DeployPurpose        = 'Required'
    CollectionType       = 'Device'
    EstimatedRuntimeMins = 5
    MaximumRuntimeMins   = 15
    AddPackagingTeamDeployment     = $true
}

New-ALCMApplication @Splat
```

Creates everything needed in and for Config Manager for a program that has multiple editions with the same version number:

Creates these for this AppDeployToolkit EXE installer and it's file version detection:

- Device Application AD Group
- Application & Vendor Application Folders
- CM Application
- Script deployment type
- MSI & Registry Key detection type
- Application & Vendor Device Collection Folders
- Device Collection
- App deployment

### Example 8: Create everything needed for a PSAppDeployToolkit app with a custom detection script

```powershell
$Name            = 'Anypoint Studio'
$Publisher       = 'MuleSoft Inc.'
$SoftwareVersion = '7.16.0'

New-ALDeployAppScript -Name $Name -Publisher $Publisher -SoftwareVersion $SoftwareVersion

$ScriptText = Get-Content -Path "$InstallMediaRootFolder\MuleSoft Inc\Anypoint Studio\Detection Method\DetectionMethod.ps1" -Delimiter '~'

$Splat = @{
    Name                       = $Name
    Publisher                  = $Publisher
    SoftwareVersion            = $SoftwareVersion
    ScriptText                 = $ScriptText
    InstallMediaFolder         = "$InstallMediaRootFolder\$Publisher\$Name\$SoftwareVersion"
    IconFile                   = "$InstallMediaRootFolder\$Publisher\$Name\$SoftwareVersion\SupportFiles\Logo.png"
    PrivacyPolicyURL           = 'https://www.salesforce.com/company/privacy/'
    UserDocumentationLinkText  = 'Documentation'
    UserDocumentationLink      = 'https://docs.mulesoft.com/studio/latest/'
    Description                = "Anypoint Studio is MuleSoft's Eclipse-based integration development environment for designing and testing Mule applications."
    Keyword                    = @('Eclipse', 'Java', 'IDE', 'Development', 'Anypoint', 'MuleSoft')
    EstimatedRuntimeMins       = 5
    MaximumRuntimeMins         = 15
    AddPackagingTeamDeployment = $true
}

New-ALCMApplication @Splat
```

Creates everything needed in and for Config Manager for a program with a Powershell script detection method.

Creates these for this AppDeployToolkit EXE installer and it's file version detection:

- Device Application AD Group
- Application & Vendor Application Folders
- CM Application
- Script deployment type
- PowerShell Script detection type
- Application & Vendor Device Collection Folders
- Device Collection
- App deployment

## PARAMETERS

### -Name

Specify a name for the app.

This will be used for the:

- Application Name
- Deployment Type Name
- Device/User Collections
- AD Group

The maximum length is 256 characters.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApplicationFolderName

Overrides the default value for the application-level application folder & application-level device/user collection folder names.

The default value for the application folder name is:

- **PatchMyPC apps**: **LocalizedDisplayName** of the existing app.
- **Non-PatchMyPC apps**: **Name** parameter provided to this function.

Use this when the application name shouldn't match the folder name, i.e. the folders for `Camtasia 2023` should be called `Camtasia` instead of `Camtasia 2023`.

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

### -Publisher

Specify optional vendor information for this app.

Generally the name of the `Publisher` in the `Uninstall` key.

The maximum length is 256 characters.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SoftwareVersion

Specify an optional version string for the app.

Generally the version number from the `DisplayVersion` on the `Uninstall` key or the version number on the properties of the app's main EXE.

The maximum length is 64 characters.

```yaml
Type: String
Parameter Sets: ScratchScriptDetection, Scratch
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description

Specify a description for this app in the specified language.
The maximum length is 2048 characters.

```yaml
Type: String
Parameter Sets: ScratchScriptDetection, Scratch
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InstallCommand

Specify the installation program command line to install this application. Do not include the path to the installer.

```yaml
Type: String
Parameter Sets: ScratchScriptDetection, Scratch
Aliases:

Required: False
Position: Named
Default value: Deploy-Application.exe
Accept pipeline input: False
Accept wildcard characters: False
```

### -UninstallCommand

Specify the command line to uninstall the application.

Starting in version 2006, you can specify an empty string.

```yaml
Type: String
Parameter Sets: ScratchScriptDetection, Scratch
Aliases:

Required: False
Position: Named
Default value: Deploy-Application.exe -DeploymentType Uninstall
Accept pipeline input: False
Accept wildcard characters: False
```

### -DetectionClause

Specify an array of detection method clauses for this deployment type.

To create a detection clause, use one of the following cmdlets:

- [New-CMDetectionClauseDirectory](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/new-cmdetectionclausedirectory)
- [New-CMDetectionClauseFile](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/new-cmdetectionclausefile)
- [New-CMDetectionClauseRegistryKey](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/new-cmdetectionclauseregistrykey)
- [New-CMDetectionClauseRegistryKeyValue](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/new-cmdetectionclauseregistrykeyvalue)
- [New-CMDetectionClauseWindowsInstaller](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/new-cmdetectionclausewindowsinstaller)

Save the output of these cmdlets into a variable.

Then specify those variables as an array for this parameter.

For example, `-AddDetectionClause $clauseFile1,$clauseFile2,$clauseFile3.`

You can also use [Get-CMDeploymentTypeDetectionClause](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/get-cmdeploymenttypedetectionclause) to get an existing detection clause from another application.

```yaml
Type: DetectionClause[]
Parameter Sets: Scratch
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScriptLanguage

If you use the ScriptFile parameter, use this parameter to specify the script language.

```yaml
Type: String
Parameter Sets: ScratchScriptDetection
Aliases:

Required: False
Position: Named
Default value: PowerShell
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScriptText

Specify the text of a script to detect this deployment type.

Also use the `ScriptLanguage` parameter.

For more information, see [About custom script detection methods](https://learn.microsoft.com/en-us/mem/configmgr/apps/deploy-use/create-applications#about-custom-script-detection-methods).

```yaml
Type: String
Parameter Sets: ScratchScriptDetection
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Keyword

Specify a list of keywords in the selected language.
These keywords help Software Center users search for the app.

```yaml
Type: String[]
Parameter Sets: ScratchScriptDetection, Scratch
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IconFile

Specify the path to the file that contains the icon for this app.
Icons can have pixel dimensions of up to 512x512.

The file can be of the following image and icon file types:

- `DLL`
- `EXE`
- `ICO`
- `JPG`
- `PNG`

```yaml
Type: FileInfo
Parameter Sets: ScratchScriptDetection, Scratch
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserDocumentationLinkText

When you use the UserDocumentation parameter, use this parameter to show a string in place of `Additional information` in Software Center, i.e. `User Manual`.
The maximum length is 128 characters.

```yaml
Type: String
Parameter Sets: ScratchScriptDetection, Scratch
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserDocumentationLink

Specify the location of a file from which Software Center users can get more information about this app.
This location is a website address, or a network path and file name.
Make sure that users have access to this location.

The maximum length of the entire string is 256 characters.

```yaml
Type: String
Parameter Sets: ScratchScriptDetection, Scratch
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PrivacyPolicyURL

Specify a website address to the privacy statement for the app.
The format needs to be a valid URL, for example <https://contoso.com/privacy>.
The maximum length of the entire string is 128 characters.

```yaml
Type: String
Parameter Sets: ScratchScriptDetection, Scratch
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InstallMediaFolder

Specify the network source path of the content.
The site system server requires permission to read the content files.
It must already exist.

```yaml
Type: DirectoryInfo
Parameter Sets: ScratchScriptDetection, Scratch
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EstimatedRuntimeMins

Specify the estimated installation time, in minutes, of this deployment type for the application.
Software Center displays this estimate to the user before the application installs.

```yaml
Type: Int32
Parameter Sets: ScratchScriptDetection, Scratch
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaximumRuntimeMins

Specify the maximum allowed run time of the deployment program for this application.
Set an integer value in minutes.
Config Manager will now allow a maximum below 15 minutes.

```yaml
Type: Int32
Parameter Sets: ScratchScriptDetection, Scratch
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReleaseDate

Specify a date object for when this app was released to Config Manager.
To get this object, use the [Get-Date](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-date) built-in cmdlet.

```yaml
Type: DateTime
Parameter Sets: ScratchScriptDetection, Scratch
Aliases:

Required: False
Position: Named
Default value: (Get-Date)
Accept pipeline input: False
Accept wildcard characters: False
```

### -DistributionPointGroupName

Specify an array of distribution point group names to distribute the content to.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: @('01 - All DPs')
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApplicationsRootFolderPath

Specifies the folder path to our root application folder, the folder containing all the application vendors' folders.

Do not include the site code (i.e. the result of `"$(Get-PSDrive -PSProvider CMSITE):\"`) or the object type (i.e. `Application`)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Vendor
Accept pipeline input: False
Accept wildcard characters: False
```

### -ADGroupPrefix

Specify the 3-letter prefix to use for the AD Group Name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: PKG
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeployPurpose

Specify the deployment purpose:

`Available`: The user sees the application in Software Center.
They can install it on demand.

`Required`: The client automatically installs the app according to the schedule that you set.
If the application isn't hidden, a user can track its deployment status.
They can also use Software Center to install the application before the deadline

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

### -UserNotification

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

### -CollectionType

Specify the type of collections to create.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: @('Device', 'User')
Accept pipeline input: False
Accept wildcard characters: False
```

### -CollectionNameOverride

Specify the name of an existing collection to make this application directly available to, instead of creating these:

- AD group
- Query for the AD group members
- Device/User Collection populated by the Query

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

### -AddPackagingTeamDeployment

Add an `Available` deployment to the `Packaging Team` user collection

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

Does not set the user categories.

## RELATED LINKS

[New-ALCMAppADGroup](New-ALCMAppADGroup.md)

[New-ALCMAppDeployment](New-ALCMAppDeployment.md)

[New-ALCMAppFolders](New-ALCMAppFolders.md)

[New-ALCMCollection](New-ALCMCollection.md)

[New-ALCMInstalledAppQuery](New-ALCMInstalledAppQuery.md)

[New-ALDeployAppScript](New-ALDeployAppScript.md)
