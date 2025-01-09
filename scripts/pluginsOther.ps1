$PluginsDirectory = "$env:USERPROFILE\Desktop\server\plugins"

$TerraPlusMinusUrl = "https://github.com/BTE-Germany/TerraPlusMinus/releases/download/v1.4.0/terraplusminus-1.4.0.jar"
$LoginSecurityUrl = "https://ci.codemc.io/view/Author/job/lenis0012/job/LoginSecurity/lastSuccessfulBuild/artifact/target/LoginSecurity-Spigot-3.3.1-SNAPSHOT.jar"
$BuildersUtilitiesUrl "https://ci.athion.net/job/Builders-Utilities/lastSuccessfulBuild/artifact/build/libs/Builders-Utilities-2.1.1-124.jar"

try {
    Invoke-WebRequest -Uri $TerraPlusMinusUrl -OutFile "$PluginsDirectory\terraplusminus-1.4.0.jar"
    Write-Host "Download completed successfully."
} catch {
    Write-Error "Failed to download TerraPlusMinus: $_"
}

try {
    Invoke-WebRequest -Uri $LoginSecurityUrl -OutFile "$PluginsDirectory\LoginSecurity-Spigot-3.3.1-SNAPSHOT.jar"
    Write-Host "Download completed successfully."
} catch {
    Write-Error "Failed to download LoginSecurity: $_"
}

try {
    Invoke-WebRequest -Uri $BuildersUtilitiesUrl -OutFile "$PluginsDirectory\Builders-Utilities-2.1.1-124.jar"
    Write-Host "Download completed successfully."
} catch {
    Write-Error "Failed to download BuildersUtilities: $_"
}
