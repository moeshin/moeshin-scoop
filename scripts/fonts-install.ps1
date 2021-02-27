param(
    [Parameter(Mandatory=$true)]
    [String[]]
    $path,
    $dir
)

. "$psscriptroot\required-admin.ps1" install
if (!$?) { exit 1 }

. "$psscriptroot\function.ps1"

if ($null -ne $dir) {
    $_pwd = $PWD
    Set-Location $dir
    $dir = $_pwd
}

$fonts = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts"

Get-ChildItem -Path $path | ForEach-Object {
    $dest = $fonts + '\' + $_.Name
    New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts' -Name $_.Name.Replace($_.Extension, ' (TrueType)') -Value $dest -Force | Out-Null
    Write-Host "Hardlinking: '$dest' => '$($_.FullName)'"
    New-Item -Force -ItemType HardLink -Path $fonts -Name $_.Name -Target (formatPath $_.FullName) | Out-Null
}

Restart-Service FontCache

if ($null -ne $dir) {
    Set-Location $dir
}