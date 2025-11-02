[CmdletBinding(DefaultParameterSetName = "no-arguments")]
Param (
    [Parameter(HelpMessage = "Alternative login using app client.",
        ParameterSetName = "by-pass")]
    [bool]$ByPass = $true,
	[Parameter(HelpMessage = "Env file to use",
		ParameterSetName = "env-file")]
    [string]$envFile = ".env"
)

$topologyArray = "xp0", "xp1", "xm1", "xm0";
$currentTopology = "xp1"

$ErrorActionPreference = "Stop";
$startDirectory = ".\run\sitecore-";
$workinDirectoryPath;
$envCheck;
# Double check whether init has been run
$envCheckVariable = "HOST_LICENSE_FOLDER";

foreach ($topology in $topologyArray)
{
  $envCheck = Get-Content (Join-Path -Path ($startDirectory + $topology) -ChildPath .env) -Encoding UTF8 | Where-Object { $_ -imatch "^$envCheckVariable=.+" }
  if ($envCheck) {
    $workinDirectoryPath = $startDirectory + $topology;
    $currentTopology = $topology
    break
  }
}

$currentTopology = "xm0"
$workinDirectoryPath = $startDirectory + $currentTopology;

if (-not $envCheck) {
    throw "$envCheckVariable does not have a value. Did you run 'init.ps1 -InitEnv'?"
}
Push-Location $workinDirectoryPath

# Build all containers in the Sitecore instance, forcing a pull of latest base containers
Write-Host "Building containers..." -ForegroundColor Green
docker-compose build
if ($LASTEXITCODE -ne 0) {
    Write-Error "Container build failed, see errors above."
}

# Start the Sitecore instance
Write-Host "Starting Sitecore environment..." -ForegroundColor Green
docker system prune -f

docker-compose --env-file $envFile up -d

Pop-Location

# Wait for Traefik to expose CM route
Write-Host "Waiting for CM to become available..." -ForegroundColor Green
$startTime = Get-Date
do {
    Start-Sleep -Milliseconds 100
    try {
        $status = Invoke-RestMethod "http://localhost:8079/api/http/routers/cm-secure@docker"
    } catch {
        if ($_.Exception.Response.StatusCode.value__ -ne "404") {
            throw
        }
    }
} while ($status.status -ne "enabled" -and $startTime.AddSeconds(15) -gt (Get-Date))
if (-not $status.status -eq "enabled") {
    $status
    Write-Error "Timeout waiting for Sitecore CM to become available via Traefik proxy. Check CM container logs."
}

if ($ByPass) {
  dotnet sitecore login --cm https://cm.basiccompany.localhost/ --auth https://id.basiccompany.localhost/ --allow-write true --client-id "SitecoreCLIServer" --client-secret "UyzkB#zkumAs2qE@iOM2!bEK" --client-credentials true
}else {
  dotnet sitecore login --cm https://cm.basiccompany.localhost/ --auth https://id.basiccompany.localhost/ --allow-write true
}

if ($LASTEXITCODE -ne 0) {
    Write-Error "Unable to log into Sitecore, did the Sitecore environment start correctly? See logs above."
}

# Populate Solr managed schemas to avoid errors during item deploy
Write-Host "Populating Solr managed schema..." -ForegroundColor Green
dotnet sitecore index schema-populate -i sitecore_core_index
dotnet sitecore index schema-populate -i sitecore_master_index
dotnet sitecore index schema-populate -i sitecore_web_index

Write-Host "Rebuilding indexes..." -ForegroundColor Green
dotnet sitecore index rebuild -i sitecore_core_index
dotnet sitecore index rebuild -i sitecore_master_index
dotnet sitecore index rebuild -i sitecore_web_index

Write-Host "Pushing items to Sitecore..." -ForegroundColor Green
dotnet sitecore ser push --publish
if ($LASTEXITCODE -ne 0) {
    Write-Error "Serialization push failed, see errors above."
}

Write-Host "Opening site..." -ForegroundColor Green

Start-Process https://cm.basiccompany.localhost/sitecore/
Start-Process https://www.basiccompany.localhost/

Write-Host ""
Write-Host "IMPORTANT: If CM says 'site cannot be reached' or shows authentication errors," -ForegroundColor Yellow
Write-Host "try opening the URL manually in incognito/private browsing mode." -ForegroundColor Yellow
Write-Host "This resolves cached authentication state from previous container sessions." -ForegroundColor Yellow
Write-Host ""
Write-Host "Use the following command to monitor your Rendering Host:" -ForegroundColor Green
Write-Host "docker-compose logs -f rendering"
Write-Host ""
