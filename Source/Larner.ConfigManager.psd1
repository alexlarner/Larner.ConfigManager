@{

# Script module or binary module file associated with this manifest.
RootModule = 'Larner.ConfigManager.psm1'

# Version number of this module.
ModuleVersion = '0.0.0'

# Supported PSEditions
CompatiblePSEditions = 'Core'

# ID used to uniquely identify this module
GUID = '8f666c54-fb26-4cfb-8af0-2055d17ed334'

# Author of this module
Author = 'Alexander Larner'

# Company or vendor of this module
CompanyName = ''

# Copyright statement for this module
Copyright = 'Copyright (c) 2024 Alexander Larner'

# Description of the functionality provided by this module
Description = 'Creates a wrapper around the Config Manager commands for better Config Manager Automation'

# Minimum version of the PowerShell engine required by this module
PowerShellVersion = '7.2'

# Modules that must be imported into the global environment prior to importing this module
RequiredModules     = @('PSFramework', 'ConfigurationManager', 'ImportExcel')

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @()

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        # Tags = @()

        # A URL to the license for this module.
        # LicenseUri = ''

        # A URL to the main website for this project.
        # ProjectUri = ''

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        # ReleaseNotes = ''

        # Prerelease string of this module
        # Prerelease = ''

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save
        # RequireLicenseAcceptance = $false

        # External dependent modules of this module
        # ExternalModuleDependencies = @()

    } # End of PSData hashtable

} # End of PrivateData hashtable
}

