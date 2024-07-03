Clear-Host

#############################
#        Preferences        #
#############################

$module_path = "$PWD/Modules"
while ( $true ) {
    Write-Output "The current install path is: $module_path"
    $last_reponse = $(Read-Host "Do you want to change it (y/n)")
    if ($last_reponse -eq "n") {
        break;
    }
    $module_path = $(Read-Host "Which path")
}

$compilator_path = "g++"
while ( $true ) {
    Write-Output "The current compilator name is: $compilator_path"
    $last_reponse = $(Read-Host "Do you want to change it (y/n)")
    if ($last_reponse -eq "n" -and $compilator_path -ne "None") {
        break;
    }
    $compilator_path = $(Read-Host "Which path")
}

$ide_path = "code"
while ( $true ) {
    Write-Output "The current ide name is: $ide_path"
    $last_reponse = $(Read-Host "Do you want to change it (y/n)")
    if ($last_reponse -eq "n" -and $ide_path -ne "None") {
        break;
    }
    $ide_path = $(Read-Host "Which path")
}


$Archive = $(Read-Host "Do you want the archive module (y/n)")
$Github = $(Read-Host "Do you want the clone-git function (y/n)")


#############################
#        Intallation        #
#############################

New-Item "$module_path" -ItemType Directory | Out-Null
Expand-Archive $PWD/Cpp-Launcher/FunctionsM.zip $module_path 
Expand-Archive $PWD/Cpp-Launcher/DatasM.zip $module_path 
if ($Github -eq "y") {
    Expand-Archive $PWD/Cpp-Launcher/GitHubM.zip $module_path
}
if ($Archive -eq "y") {
    Expand-Archive $PWD/Cpp-Launcher/ArchiveM.zip $module_path
}
Write-Output @"
`$module_path="$module_path";
`$compilator="$compilator_path";
`$ide="$ide_path";
Export-ModuleMember -Variable `$module_path, `$compilator, `$ide;
"@ | Out-File "$module_path/Datas/Datas.psm1" -Encoding ascii

try {
    Test-PSSessionConfigurationFile;
    $Windows = $true
}
catch {
    $Windows = $false
}

$PROFILE.AllUsersAllHosts = "/workspaces/Cpp_PowerShell_launcher/profile.ps1"
if (!$(Test-Path -Path $PROFILE.AllUsersAllHosts -PathType Leaf)) {
    try {
        Write-Output @"
$env:PSModulePath="$env:PSModulePath$(if ($Windows) { ";" } else { ":" } )$module_path"
"@ | Out-File $PROFILE.AllUsersAllHosts -Encoding ascii -Force
    }
    catch {
        Write-Error $("There was an error when creating the profile file:`n" + [string]$Error[0])
        exit -1
    }
}

