param(
    [String]
    $prefix = ''
)

Get-ChildItem -File | ForEach-Object {
    $ext = $_.Extension
    switch ($ext) {
        '.exe' {}
        '.cmd' {}
        '.bat' {}
        '.ps1' {}
        Default { return }
    }
    Write-Host "$(' ' * 8)""$prefix$($_.Name)"","
}