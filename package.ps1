Param(
  [Parameter(Mandatory = $true)]
  [string] $tag,
  [string] $apiKey
)

$ErrorActionPreference = "Stop";

$version = $tag -match '(?<=^v)\d+\.\d+\.\d+(?:.+)?$'
$versionNumber = $version -match '^\d+\.\d+\.\d+'
if ([string]::IsNullOrEmpty($version))
{
    throw "Incorrect tag format"
}

git fetch -a
git checkout $tag
if ($LastExitCode -ne 0) {
  throw "Could not checkout tag"
}

nuget restore
if ($LastExitCode -ne 0) {
  throw "NuGet packages could not be restored"
}

msbuild IsoPlugin.sln /m /p:Configuration=Release /p:Version=$version /p:FileVersion=$versionNumber.0 /t:rebuild /v:minimal
if ($LastExitCode -ne 0) {
  throw "Solution could no be built"
}

nuget pack ./AgGatewayISOPlugin.nuspec -verbosity detailed -outputdirectory ./dist -version $version
if ($LastExitCode -ne 0) {
  throw "Package could no be built"
}

if (-not ([string]::IsNullOrEmpty($apiKey))) {
  nuget push ./dist/AgGatewayISOPlugin.$version.nupkg -apikey $apiKey -source https://api.nuget.org/v3/index.json
  if ($LastExitCode -ne 0) {
    throw "Package could no be published"
  }
}

# git checkout master