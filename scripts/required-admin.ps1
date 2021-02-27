param($type)

if ((Get-Command is_admin -ErrorAction SilentlyContinue) -and !(is_admin)) {
    error "Admin rights are required, please run 'sudo scoop $type $app'";
    exit 1
} elseif (!(New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::
        GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error 'Admin rights are required'
    exit 1
}