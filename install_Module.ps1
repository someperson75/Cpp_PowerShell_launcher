$PROFILE.AllUsersAllHosts = "/workspaces/Cpp_PowerShell_launcher/profile.ps1"
if (!$(Test-Path -Path $PROFILE.AllUsersAllHosts -PathType Leaf)) {
    try {
        Write-Output "" | Out-File $PROFILE.AllUsersAllHosts -Encoding ascii -Force
    }
    catch {
        Write-Error $("There was an error when creating the profile file:`n" + [string]$Error[0])
        exit -1
    }
}
$module_path = "$PWD/Cpp-Launcher"
while ( $true ) {
    Write-Output "The current install path is: $module_path"
    $last_reponse = $(Read-Host "Do you want to change it (y/n): ")
    if ($last_reponse -eq "n") {
        break;
    }
    $module_path = $(Read-Host "Which path: ")
}

$compilator_path = "None"
while ( $true ) {
    Write-Output "The current install path is: $compilator_path"
    $last_reponse = $(Read-Host "Do you want to change it (y/n): ")
    if ($last_reponse -eq "n" -and $compilator_path -ne "None") {
        break;
    }
    $compilator_path = $(Read-Host "Which path: ")
}

$ide_path = "None"
while ( $true ) {
    Write-Output "The current install path is: $ide_path"
    $last_reponse = $(Read-Host "Do you want to change it (y/n): ")
    if ($last_reponse -eq "n" -and $ide_path -ne "None") {
        break;
    }
    $ide_path = $(Read-Host "Which path: ")
}

mkdir "$module_path"

