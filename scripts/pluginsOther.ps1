$PluginsDirectory = "$env:USERPROFILE\Desktop\server\plugins"

$TerraPlusMinusUrl = "https://github.com/BTE-Germany/TerraPlusMinus/releases/download/v1.4.0/terraplusminus-1.4.0.jar"
$LoginSecurityUrl = "https://ci.codemc.io/view/Author/job/lenis0012/job/LoginSecurity/lastSuccessfulBuild/artifact/target/LoginSecurity-Spigot-3.3.1-SNAPSHOT.jar"

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