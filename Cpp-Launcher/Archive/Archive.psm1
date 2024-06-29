function Get-Filename {
	param(
		[System.String]$project_name
	)
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

function Invoke-Archive {
    param (
        $filename = $null
    )
    $filename = $(Get-Filename $filename)
    if (Test-Path -Path ".\$filename" -PathType Leaf) {
        if (Test-Path -Path ".\archive" -PathType Container) {}
        else { New-Item -ItemType Directory -Path ".\archive" | Out-Null }
        Copy-Item ".\$filename" -Destination ".\archive\$filename"
        Remove-Item ".\$filename"
        Write-Host "The project was perfectly archived !" -ForegroundColor Green
    }
    else {
        Write-Host "The project don't exist !" -ForegroundColor Red
    }
}

function Invoke-Un-Archive {
    param (
        $filename = $null
	)
	$filename = $(Get-Filename $filename)
	
	if (Test-Path -Path ".\archive\$filename" -PathType Leaf) {
		Copy-Item ".\archive\$filename" -Destination "."
		Remove-Item ".\archive\$filename"
		$(code ".\$filename")
		Write-Host "The project was perfectly un-archived !" -ForegroundColor Green
	}
	else {
		Write-Host "The project don't exist !" -ForegroundColor Red
	}
}

function Get-Archive-Directories {
	param(
		$current_path
	)
	if ($current_path -match "(?<path>.*)\\archive" -and $(Test-Path -Path $current_path -PathType Container)) {
		return @($current_path);
	}
	else {
		$return = @();
		foreach ($directories in $(Get-ChildItem $current_path -Directory)) {
			$return += $(Get-Archive-Directories "$current_path\$directories");
		}
		return $return;
	}
}

function Remove-Old-Archived-Files {

    # get necessary type
	Add-Type -AssemblyName Microsoft.VisualBasic

    # get archive directory
	$paths = $(Get-Archive-Directories "$env:USERPROFILE");

    # foreach archive directory
	foreach ($path in $paths) {
        # get limit
		$limit = Get-Date -Date (Get-Date).AddDays(-15) -Format "yyyy/MM/dd"

		# Delete files older than the $limit.
		foreach ($hi in $(Get-ChildItem -Path $path -Recurse -Force | Where-Object { !$_.PSIsContainer -and $(Get-Date -Date $_.CreationTime -Format "yyyy/MM/dd") -lt $limit })) {
			#echo "delete $hi"
			try {
				[Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile("$path\$hi", 'OnlyErrorDialogs', 'SendToRecycleBin')
			}
			catch {
				Write-Error $Error[0]
			}
		}

		# Delete any empty directories left behind after deleting the old files.
		Get-ChildItem -Path $path -Recurse -Force | Where-Object { $_.PSIsContainer -and $null -eq (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) } | Remove-Item -Force -Recurse
	}
}
Remove-Old-Archived-Files

Set-Alias -Name archive		-Value Invoke-Archive
Set-Alias -Name un-archive	-Value Invoke-Un-Archive

Export-ModuleMember -Alias archive, un-archive -Function Remove-Old-Archived-Files, Invoke-Archive,Invoke-Un-Archive