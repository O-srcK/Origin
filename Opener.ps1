param (
    [int]$currentMenuId,
    [string]$userInput,
    [string]$browserExe,
    [string]$newWindowArg
)

Load-MenuResources $currentMenuId

function Load-MenuResources {
    param ([int]$menuId)
    $csvPath = Join-Path $PSScriptRoot 'Map.csv'
    $lines = Get-Content $csvPath
    $firstLine = $true
    foreach ($line in $lines) {
        if ($firstLine) { $firstLine = $false; continue }
        $trimmed = $line.Trim(); if ($trimmed -eq "" -or $trimmed.StartsWith("#")) { continue }
        $cols = $trimmed -split ",",5; if ($cols.Count -lt 4) { continue }
        $menuIdStr = $cols[0].Trim(); $itemType = $cols[1].Trim(); $itemPath = $cols[3].Trim()
        if ($itemType -eq "mnu") { continue }
        if ([int]$menuIdStr -eq $menuId) {
            $script:selectedMenuResources += [PSCustomObject]@{type=$itemType; path=$itemPath}
        }
    }
}

function Open-Item {
    param($item)
    if ($item.type -in @("url")) {
        if ($browserExe) {
            Start-Process -FilePath $browserExe -ArgumentList $newWindowArg, $item.path
        } else {
            Start-Process "explorer.exe" $item.path
        }
    }
    elseif ($item.path -match "^https?:\/\/") {
        Start-Process $item.path
    }
    else {
        $fullPath = Join-Path -Path $PSScriptRoot -ChildPath $item.path
        if (Test-Path $fullPath) { Start-Process $fullPath }
    }
}

function Open-InBrowser {
    param([int[]]$indices)
    $urls = @()
    foreach ($i in $indices) {
        if ($i -ge 1 -and $i -le $script:selectedMenuResources.Count) {
            $item = $script:selectedMenuResources[$i - 1]
            if ($item.type -in @("url","pdf")) { $urls += $item.path }
        }
    }
    if ($urls.Count) {
        if ($browserExe) {
            Start-Process -FilePath $browserExe -ArgumentList $newWindowArg, $urls
        } else {
            foreach ($url in $urls) { Start-Process $url }
        }
    }
}

# Main processing logic follows here – parse [n], [n m], etc.
Load-MenuResources $currentMenuId
Write-Host "Loaded resources count: $($script:selectedMenuResources.Count)"

# Regex pattern for square bracket groups (e.g. [1 2])
$parenPattern = "\[([^\]]*)\]"
$matches = [regex]::Matches($userInput, $parenPattern)
Write-Host "Regex matches for bracket groups found: $($matches.Count)"

foreach ($match in $matches) {
    $argStr = $match.Groups[1].Value
    Write-Host "Opening browser windows for indices group: '$argStr'"
    $parts = $argStr -split '[ ,]+'
    $indices = @()
    foreach ($part in $parts) {
        if ($part -match '^\d+$') {
            $indices += [int]$part
        }
    }
    Open-InBrowser -indices $indices
}

# Remove bracket groups from input for independent items
$userInput = [regex]::Replace($userInput, $parenPattern, "").Trim()
Write-Host "Input after removing bracket groups: '$userInput'"

# Process remaining numbers independently
$numberPattern = '\d+'
$ids = [regex]::Matches($userInput, $numberPattern) | ForEach-Object { [int]$_.Value }
Write-Host "Remaining numeric IDs to open: $ids"

foreach ($id in $ids) {
    if ($id -gt 0 -and $id -le $script:selectedMenuResources.Count) {
        Write-Host "Opening item for ID: $id"
        Open-Item -item $script:selectedMenuResources[$id-1]
    } else {
        Write-Warning "Index not found: $id"
    }
}
Write-Host "PowerShell script completed."