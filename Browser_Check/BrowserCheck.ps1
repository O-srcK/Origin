Write-Host "Detecting default browser..."

try {
    $defaultBrowserProgId = (Get-ItemProperty "HKCU:\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice").ProgId
    Write-Host "Default browser ProgId: $defaultBrowserProgId"
} catch {
    $defaultBrowserProgId = ""
    Write-Warning "Could not detect default browser ProgId. Default browser config will be empty."
}

switch -Regex ($defaultBrowserProgId) {
    "^ChromeHTML" {
        $browserExe = "C:\Program Files\Google\Chrome\Application\chrome.exe"
        $newWindowArg = "--new-window"
    }
    "^FirefoxURL" {
        $browserExe = "C:\Program Files\Mozilla Firefox\firefox.exe"
        $newWindowArg = "-new-window"
    }
    "^MSEdgeHTM" {
        $browserExe = "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe"
        $newWindowArg = "--new-window"
    }
    default {
        $browserExe = ""
        $newWindowArg = ""
        Write-Warning "Default browser not recognized or supported."
    }
}

$browserConfig = @{
    BrowserExe = $browserExe
    NewWindowArg = $newWindowArg
}

$browserConfigPath = Join-Path -Path $PSScriptRoot -ChildPath "browser-config.json"

Write-Host "Writing browser config to $browserConfigPath"

# Write JSON file
$browserConfig | ConvertTo-Json | Set-Content -Path $browserConfigPath -Encoding UTF8

Write-Host "Browser check complete."
