# Larner.ConfigManager

A PowerShell wrapper around the ConfigManager Module to enable better automation

## Key Functions

### Packaging

#### [New-ALDeployAppScript](Docs\New-ALDeployAppScript.md)

Copies and customizes a `Deploy-Application` script (from [PSAppDeployToolkit](https://psappdeploytoolkit.com/docs/)) to include an application's metadata. Use this function as a starting point for creating an application using PSAppDeployToolkit.

#### [New-ALCMAppFolders](Docs\New-ALCMAppFolders.md)

Creates the application folders for the vendor and application if they don't exist. Use this before you enable a PMPC app, so that you have a folder to specify in `Move the application to custom folder` in the PMPC console.

#### [New-ALCMApplication](Docs\New-ALCMApplication.md)

Creates an app and all its necessary collections and deployments in Config Manager. Use this after you have the install media (including the AppDeployToolkit) prepped.

### Deployments

#### [Add-ALCMCollectionMember](Docs\Add-ALCMCollectionMember.md)

Adds a user/device to a CM collection by adding it to the related AD group, and can wait until the user/device shows up in the collection.

#### [New-ALCMAppDeployment](Docs\New-ALCMAppDeployment.md)

Creates an application deployment for an existing application in Config Manager. [New-ALCMApplication](Docs\New-ALCMApplication.md) already makes the standard deployments to the collections tied to the users & devices in the standard AD group, so this should be used for any other deployments. i.e. Deployments to all devices for a location.

### Cleanup

#### [Invoke-ALCMApplicationRetirement](Docs\Invoke-ALCMApplicationRetirement.md)

Retires an app with these steps:

- Hide app in Deploy Wizard
- Remove any dependency relationships that other apps have on the app
- Mark AD groups for deletion
- For collections that aren't attached to any other app:
    - Remove it as an Exclude/Include membership rule for any other collection
    - Disable the refresh on the collection
    - Move it to the User/Device `Retired Collections` folder
- Remove deployments
- Move app to the retired apps folder

#### [Get-ALCMAppInfoForArchiving](Docs\Get-ALCMAppInfoForArchiving.md)

Gets these from the app:

- LocalizedDisplayName
- Manufacturer
- SoftwareVersion

Gets these from each of the apps deployment types:

- LocalizedDisplayName
- Location
- InstallCommandLine
- UninstallCommandLine

Use this when you archive the app a month after retiring it.
