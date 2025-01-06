# Modrinth Plugin Downloader Script
# Default parameters can be overridden by passing arguments to the script
param (
    [Parameter(Mandatory = $true)]
    [string[]]$Plugins,

    [string]$MinecraftVersion = "1.21.4",

    [string]$Loaders = "paper,bukkit",

    [string]$PluginsDirectory = "$env:USERPROFILE\Desktop\server\plugins",

    [switch]$AllowUnstable = $false
)

# Ensure the plugins directory exists
if (-not (Test-Path -Path $PluginsDirectory)) {
    Write-Host "Creating plugins directory: $PluginsDirectory"
    New-Item -ItemType Directory -Path $PluginsDirectory | Out-Null
}

# Convert Loaders string to an array, preserving priority order
$LoadersArray = $Loaders -split ","

function Get-CompatiblePluginVersion {
    param (
        [string]$PluginId,
        [string]$MinecraftVersion,
        [string[]]$LoadersArray,
        [switch]$AllowUnstable
    )

    # API endpoint
    $ApiUrl = "https://api.modrinth.com/v2/project/$PluginId/version"

    Write-Host "Fetching data for plugin: $PluginId"

    try {
        $Response = curl -s $ApiUrl | jq -c '.'
        $Versions = $Response | ConvertFrom-Json

        if (-not $Versions) {
            Write-Warning "No versions found for plugin: $PluginId"
            return $null
        }

        # Filter versions based on criteria
        $FilteredVersions = $Versions | Where-Object {
            $_.game_versions -contains $MinecraftVersion -and
            ($AllowUnstable -or $_.version_type -eq "release") -and
            ($_.loaders | Where-Object { $LoadersArray -contains $_ })
        }

        if (-not $FilteredVersions) {
            Write-Warning "No compatible versions found for plugin: $PluginId"
            return $null
        }

        # Sort versions by date_published, prioritizing the latest version
        $SortedVersions = $FilteredVersions | Sort-Object { $_.date_published } -Descending

        return $SortedVersions[0]
    } catch {
        Write-Error "Failed to fetch data for plugin: $PluginId - $_"
        return $null
    }
}

function Get-PluginFile {
    param (
        [string]$FileUrl,
        [string]$DestinationPath
    )

    Write-Host "Downloading file from $FileUrl to $DestinationPath"

    try {
        Invoke-WebRequest -Uri $FileUrl -OutFile $DestinationPath
        Write-Host "Downloaded successfully: $(Split-Path -Leaf $DestinationPath)"
    } catch {
        Write-Error "Failed to download file: $FileUrl - $_"
    }
}

# Process each plugin
foreach ($Plugin in $Plugins) {
    Write-Host "Processing plugin: $Plugin"

    $Version = Get-CompatiblePluginVersion -PluginId $Plugin -MinecraftVersion $MinecraftVersion -LoadersArray $LoadersArray -AllowUnstable:$AllowUnstable

    if (-not $Version) {
        Write-Warning "Skipping plugin: $Plugin"
        continue
    }

    $PrimaryFile = $Version.files | Where-Object { $_.primary -eq $true }

    if (-not $PrimaryFile) {
        Write-Warning "No primary file found for plugin: $Plugin"
        continue
    }

    $DestinationPath = Join-Path -Path $PluginsDirectory -ChildPath $PrimaryFile.filename
    Get-PluginFile -FileUrl $PrimaryFile.url -DestinationPath $DestinationPath
}