$shortcuts = @(arch_specific 'desktopShortcuts' $manifest $arch)
if ($shortcuts -eq $true) {
    $shortcuts = @(arch_specific 'shortcuts' $manifest $arch)
}
if ($shortcuts -isnot [Array]) {
    exit
}
$desktop = "$HOME\Desktop"
$shortcuts | ForEach-Object {
    if ($_ -isnot [Array]) {
        continue
    }
    $count = $_.Count
    if ($count -lt 2) {
        continue
    }
    $shortcut = "$desktop\$($_[1]).lnk"
    Write-Host "Removing desktop shortcut $(friendly_path $shortcut)"
    if (Test-Path -Path $shortcut) {
        Remove-Item $shortcut
    }
}