param(
    $module_path=$PWD+"/Cpp-Launcher",
    $compilator,
    $ide
)

$PROFILE.AllUsersAllHosts="/workspaces/Cpp_PowerShell_launcher/profile.ps1"
if (!$(Test-Path -Path $PROFILE.AllUsersAllHosts -PathType Leaf)){
    try {
        Write-Output "" | Out-File $PROFILE.AllUsersAllHosts -Encoding ascii -Force
    }
    catch {
        Write-Error $("There was an error when creating the profile file:`n"+[string]$Error[0])
        exit -1
    }
}

