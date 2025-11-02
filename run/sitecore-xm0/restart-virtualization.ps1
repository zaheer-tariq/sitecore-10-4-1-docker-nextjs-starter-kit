$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -ne $true){
	Write-Error "You must run this script as an administrator.. exiting."
	return;
}

Write-Host "Restarting Virtualization Environment..." -ForegroundColor Green
$dockerDesktop = Get-Process "Docker Desktop" -ErrorAction SilentlyContinue
if ($dockerDesktop) {
	Write-Host "Shutting down Docker Desktop..." -ForegroundColor Green
	docker-compose down
	$dockerDesktop.CloseMainWindow() > $nul
	Sleep 5
	$dockerDesktop | Stop-Process -Force > $nul
	Sleep 5
	
}

Write-Host "Shutting down Docker..." -ForegroundColor Green
Stop-Service -Name "com.docker.service"
Sleep 5
Stop-Service -Name "docker"

Write-Host "Shutting down Hyper-V..." -ForegroundColor Green
Stop-Service -Name "vmms" 
Sleep 5
Stop-Service -Name "vmcompute" 
Sleep 5
Stop-Service -Name "HvHost" 
Sleep 5

Write-Host "Starting Hyper-V..." -ForegroundColor Green
Start-Service -Name "HvHost" 
Sleep 5
Start-Service -Name "vmcompute" 
Sleep 5
Start-Service -Name "vmms" 
Sleep 5

Write-Host "Starting Docker..." -ForegroundColor Green
Start-Service -Name "docker"
Sleep 5
Start-Service -Name "com.docker.service"

Write-Host "Restart Compelete. You must manually reopen Docker Desktop." -ForegroundColor Green