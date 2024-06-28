function Get-Filename {
	param(
		[System.String]$project_name
	)
	<#
	out:
	filename	 > string finish by .cpp
	#>
	Clear-Host
	if ("" -eq $project_name) {
		$project_name = $(Read-Host "please enter the project name ")
		Clear-Host
	}
	if ($project_name -match "(?<content>.*).cpp") {
		# project name finish by .cpp
		return "$project_name"
	}
	else {
		# project name don't finish by .cpp
		return $project_name + ".cpp"
	}
}

function Get-TestFiles {
	param(
		$filename
	)
	if ($filename -match "./(?<filename>.*).cpp") {}
	else { if ($filename -match "(?<filename>.*).cpp") {} else { return -1 } }
	try {
		$filename = $Matches['filename']
	}
	catch {
		Write-Host "Error" -ForegroundColor Red
		return -1
	}
	$tests = @()
	foreach ($file in Get-ChildItem) {
		if ($file -match "$filename(?<number>.*).in") {
			$tests += @($file)
		}
	}  
	return $tests
}


function Invoke-Create {
	param (
		[System.String]$filename = ""
	)
	$filename = $(Get-Filename $filename)
	if (Test-Path -Path "./archive/$filename" -PathType Leaf) {
		Copy-Item "./archive/$filename" -Destination "./$filename"
	}
	else {
		Copy-Item "/workspaces/Cpp_PowerShell_launcher/Modules/Functions/start.cpp" -Destination "./$filename"
		
	}
	$(code "./$filename")
	Write-Host "The project was perfectly created !" -ForegroundColor Green
}

function Invoke-Delete {
	param (
		$filename = $null
	)
	$filename = $(Get-Filename $filename)

	if (Test-Path -Path "./$filename" -PathType Leaf) {
		[Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile("./$filename", 'OnlyErrorDialogs', 'SendToRecycleBin')
		Write-Host "The project was perfectly deleted !" -ForegroundColor Green
	}
	else {
		Write-Host "The project don't exist !" -ForegroundColor Red
	}
}

function Get-Excecute {
	param (
		$filename,
		$On_input = $false
	)
	$testFiles = Get-TestFiles $filename
	if ($testFiles.count -eq 0 -or $On_input) {
		# no test case
		Write-Host "----------------------INPUT----------------------" -BackgroundColor White -ForegroundColor Black
		& "/workspaces/Cpp_PowerShell_launcher/Modules/Functions/main.exe" | Out-File -FilePath "/workspaces/Cpp_PowerShell_launcher/Modules/Functions/out.txt" -Encoding "ascii"
		Write-Host "---------------------OUTPUT----------------------" -BackgroundColor White -ForegroundColor Black
		Get-Content "/workspaces/Cpp_PowerShell_launcher/Modules/Functions/out.txt" | Write-Host 
		Write-Host "--------------------END-FILE---------------------" -BackgroundColor White -ForegroundColor Black
	}
	else {
		$i = 0
		foreach ($testName in $testFiles) {
			$i++;
			Write-Host "Test $i :" -ForegroundColor White
			Write-Host "----------------------INPUT----------------------" -BackgroundColor White -ForegroundColor Black
			Get-Content $testName | Write-Host
			Get-Content $testName | & "/workspaces/Cpp_PowerShell_launcher/Modules/Functions/main.exe" | Out-File -FilePath "/workspaces/Cpp_PowerShell_launcher/Modules/Functions/out.txt" -Encoding "ascii"
			Write-Host "---------------------OUTPUT----------------------" -BackgroundColor White -ForegroundColor Black
			Get-Content "/workspaces/Cpp_PowerShell_launcher/Modules/Functions/out.txt" | Write-Host 
			Write-Host "--------------------END-FILE---------------------" -BackgroundColor White -ForegroundColor Black
		}
	}
}

function Invoke-RunProject {
	param (
		$filename = $null,
		$Debug = $true,
		$Force = $false
	)
	$filename = $(Get-Filename $filename)
        
	if (Test-Path -Path "./$filename" -PathType Leaf) {
		Copy-Item "./$filename" -Destination "/workspaces/Cpp_PowerShell_launcher/Modules/Functions/Submit/main.cpp"
		g++ "/workspaces/Cpp_PowerShell_launcher/Modules/Functions/Submit/main.cpp" "-o" "/workspaces/Cpp_PowerShell_launcher/Modules/Functions/main.exe" "-O2" "-Wall" $(if ($Debug) { "-DDEBUG" } else { "" })
		if ($?) {
			Write-Host "Successful compilation" -ForegroundColor Green
			Get-Excecute $filename -On_input $Force
		}
		else {
			Write-Host "Compilation failed" -ForegroundColor Red
		}
	}
	else {
		Write-Host "The project don't exist !" -ForegroundColor Red
	}
}

function Invoke-PrepareToSubmit {
	param (
		$filename = $null
	)
	$filename = $(Get-Filename $filename)
    
	if (Test-Path -Path "./$filename" -PathType Leaf) {
		Copy-Item "./$filename" -Destination "/workspaces/Cpp_PowerShell_launcher/Modules/Functions/Submit/main.cpp"
		Write-Host "Project ready for submition" -ForegroundColor Green
	}
	else {
		Write-Host "The project don't exist !" -ForegroundColor Red
	}
}

Set-Alias -Name delete		-Value Invoke-Delete
Set-Alias -Name new			-Value Invoke-Create
Set-Alias -Name run			-Value Invoke-RunProject
Set-Alias -Name submit		-Value Invoke-PrepareToSubmit

Export-ModuleMember -Alias * -Function *