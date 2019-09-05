param(
    [Parameter(Mandatory=$true)]
    [string] $DevAccountKey,
    [Parameter(Mandatory=$true)]
    [string] $SitAccountKey,   
    [Parameter(Mandatory=$true)]
    [string] $PPAccountKey,
    [string] $dataMigrationExePath = "C:\ProgramData\chocolatey\lib\azure-documentdb-data-migration-tool\tools\dt.exe"
)

$sourceConnection = "AccountEndpoint=https://dfc-dev-prov-cdb.documents.azure.com:443/;AccountKey=$($DevAccountKey);Database=providerportal"
$sitConnection = "AccountEndpoint=https://dfc-sit-prov-cdb.documents.azure.com:443/;AccountKey=$($SitAccountKey);Database=providerportal"
$ppConnection = "AccountEndpoint=https://dfc-pp-prov-cdb.documents.azure.com:443/;AccountKey=$($PPAccountKey);Database=providerportal"

Write-Host "migrating coursetext collection from DEV to SIT...."

$params = @(
    "/ErrorDetails:All"
    "/s:DocumentDB"
    "/s.ConnectionString:`"$sourceConnection`""
    "/s.Collection:coursetext" 
    "/t:DocumentDB"
    "/t.ConnectionString:`"$sitConnection`""
    "/t.Collection:coursetext" 
)

& $dataMigrationExePath $params

Write-Host "migrating coursetext collection from DEV to PP...."

$params = @(
    "/ErrorDetails:All"
    "/s:DocumentDB"
    "/s.ConnectionString:`"$sourceConnection`""
    "/s.Collection:coursetext" 
    "/t:DocumentDB"
    "/t.ConnectionString:`"$ppConnection`""
    "/t.Collection:coursetext" 
)

& $dataMigrationExePath $params

Write-Host "Migration for coursetext collection completed."
