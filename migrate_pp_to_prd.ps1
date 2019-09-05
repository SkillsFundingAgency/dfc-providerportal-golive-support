param(
    [Parameter(Mandatory=$true)]
    [string] $SourceAccountKey,
    [Parameter(Mandatory=$true)]
    [string] $TargetAccountKey
)

$dtExe = "C:\ProgramData\chocolatey\lib\azure-documentdb-data-migration-tool\tools\dt.exe"

$cosmosCollections = @(
    "apprenticeship",
    "audit",
    "courseMigrationReports",
    "courses",
    "coursetext",
    "DfcReport",
    "fechoices",
    "frameworks",
    "leases",
    "progTypes",
    "sectorsubjectareatier1s",
    "sectorsubjectareatier2s",
    "standards",
    "standardsectorcodes",
    "ukrlp",
    "venues"
)

$sourceConnection = "AccountEndpoint=https://dfc-pp-prov-cdb.documents.azure.com:443/;AccountKey=$($SourceAccountKey);Database=providerportal"
$targetConnection = "AccountEndpoint=https://dfc-prd-prov-cdb.documents.azure.com:443/;AccountKey=;$($TargetAccountKey);Database=providerportal"

Write-Host "migrating cosmosdb collections from PP to PRD...."
foreach($collection in $cosmosCollections) {
    Write-Host "Migrating data for collection $($collection) from PP to PRD"

    $params = @(
        "/ErrorDetails:All"
        "/s:DocumentDB"
        "/s.ConnectionString:`"$sourceConnection`""
        "/s.Collection:$($collection)"         
        "/t:DocumentDB"
        "/t.ConnectionString:`"$targetConnection`""
        "/t.Collection:$($collection)" 
    )

    Write-Host "Migration for collection $($collection) completed."

    & $dtExe $params
}

Write-Host "CosmosDb migration complete."