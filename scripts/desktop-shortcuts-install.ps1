# If set `desktopShortcuts` to `true`, will use `shortcuts`.
# https://github.com/lukesampson/scoop/wiki/App-Manifests#user-content-shortcuts
# lib\shortcuts.ps1
$wsShell = New-Object -ComObject WScript.Shell
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
    $target = [System.IO.Path]::Combine($dir, $_[0])
    $target = New-Object System.IO.FileInfo($target)
    $name = $_[1]
    $msg = "Creating desktop shortcut for $name ($(fname $target))"
    $subDir = [System.IO.Path]::GetDirectoryName($name)
    if ($subDir) {
        mkdir -p $subDir > $null
    }
    if (!$target.Exists) {
        Write-Host -f DarkRed $("$msg failed: Couldn't find $target")
        continue
    }
    Write-Host $msg
    $shortcut = $wsShell.CreateShortcut("$desktop\$name.lnk")
    $shortcut.TargetPath = $target.FullName
    $shortcut.WorkingDirectory = $target.DirectoryName
    if ($count -gt 2) {
        $shortcut.Arguments = $_[2]
    }
    if ($count -gt 3) {
        $shortcut.IconLocation = $_[3]
    }
    $shortcut.Save()
}