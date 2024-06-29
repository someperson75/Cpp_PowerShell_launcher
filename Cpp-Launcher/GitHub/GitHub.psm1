function Invoke-GitClone() {
	param(
		$url,
		$directory = $null
	)
	if ($null -eq $directory) {
		$directory = $url.Split('/')[-1].Replace('.git', '')
	}
	& git clone $url $directory | Out-Null
	Set-Location $directory
}
Set-Alias -Name git-clone	-value Invoke-GitClone

Export-ModuleMember -Alias git-clone -Function Invoke-GitClone