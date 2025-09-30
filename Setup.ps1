# Setup.ps1 - Run this first to create resource folders and config files, and detect default browser.
function Command-Exists { param ([string]$cmd) $null -ne (Get-Command $cmd -ErrorAction SilentlyContinue) }
Write-Host "Starting setup..."

if ($PSVersionTable.PSVersion.Major -lt 5) {
    Write-Warning "PowerShell 5 or higher is required. Current version: $($PSVersionTable.PSVersion)"
    exit 1
}

if (-not (Command-Exists java)) {
    Write-Warning "Java not found on your system. Please install Java Runtime Environment."
    exit 1
}

$resourceFolder = Join-Path -Path (Get-Location) -ChildPath 'resource'
if (-not (Test-Path $resourceFolder)) { New-Item -ItemType Directory -Path $resourceFolder | Out-Null }

$configPath = Join-Path -Path (Get-Location) -ChildPath 'config.ini'
$configContent = @"
[Paths]
ResourceFolder=resource
MapCSV=Map.csv
"@
Set-Content -Path $configPath -Value $configContent

Write-Host "Detecting default browser..."
try {
    $defaultBrowserProgId = (Get-ItemProperty "HKCU:\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice").ProgId
} catch {
    $defaultBrowserProgId = ""
}

switch -Regex ($defaultBrowserProgId) {
    "^ChromeHTML" { $browserExe = "C:\Program Files\Google\Chrome\Application\chrome.exe"; $newWindowArg = "--new-window" }
    "^FirefoxURL" { $browserExe = "C:\Program Files\Mozilla Firefox\firefox.exe"; $newWindowArg = "-new-window" }
    "^MSEdgeHTM" { $browserExe = "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe"; $newWindowArg = "--new-window" }
    "^OperaStable" { $browserExe = "C:\Program Files\Opera\launcher.exe"; $newWindowArg = "--new-window" }
    "^BraveHTML" { $browserExe = "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe"; $newWindowArg = "--new-window" }
    "^VivaldiHTML" { $browserExe = "C:\Program Files\Vivaldi\Application\vivaldi.exe"; $newWindowArg = "--new-window" }
    default { $browserExe = ""; $newWindowArg = ""; Write-Warning "Default browser not recognized or supported." }
}

$browserConfig = @{ BrowserExe = $browserExe; NewWindowArg = $newWindowArg }
$browserConfigPath = Join-Path -Path (Get-Location) -ChildPath "browser-config.json"
$browserConfig | ConvertTo-Json | Set-Content -Path $browserConfigPath -Encoding UTF8
Write-Host "Setup complete."
