param(
    [Parameter(Mandatory=$true)]
    [String[]]
    $path,
    $dir
)

. "$psscriptroot\required-admin.ps1" uninstall
if (!$?) { exit 1 }

. "$psscriptroot\function.ps1"

if ($null -ne $dir) {
    $_pwd = $PWD
    Set-Location $dir
    $dir = $_pwd
}

$fonts = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts"

Get-ChildItem -Path $path | ForEach-Object {
    Remove-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts' -Name (formatName $_.Name.Replace($_.Extension, ' (TrueType)')) -Force | Out-Null
}

Restart-Service FontCache

Get-ChildItem -Path $path | ForEach-Object {
    Remove-Item (formatPath "$fonts\$($_.Name)")
}

if ($null -ne $dir) {
    Set-Location $dir
}