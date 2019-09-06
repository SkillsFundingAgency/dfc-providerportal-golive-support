param(
    [Parameter(Mandatory=$true)]
    [string] $AccountKey,
    [string] $dataMigrationExePath = "C:\ProgramData\chocolatey\lib\azure-documentdb-data-migration-tool\tools\dt.exe"
)

$sourceConnection = "AccountEndpoint=https://dfc-prd-prov-cdb.documents.azure.com:443/;AccountKey=$($AccountKey);Database=providerportal"

$collections = Get-Content -Path ./collections.json | ConvertFrom-Json

foreach($collection in $collections) {
    Write-Host "Backing up data for collection $($collection.Name) into $($collection.Name)-backup.."

    $params = @(
        "/ErrorDetails:All"
        "/s:DocumentDB"
        "/s.ConnectionString:`"$sourceConnection`""
        "/s.Collection:$($collection.Name)"         
        "/t:DocumentDB"
        "/t.ConnectionString:`"$sourceConnection`""
        "/t.Collection:$($collection.Name)-backup" 
        "/t.CollectionThroughput:$($collection.RequestUnits)"
    )

    if($collection.PartitionKey) { 
        "/t.PartitionKey:$($collection.PartitionKey)" 
    }

    & $dataMigrationExePath $params

    Write-Host "Backup of collection $($collection.Name) completed."
}