$collections = Get-Content -Path ./collections.json | ConvertFrom-Json

$cosmosAccount = "dfc-dev-prov-cdb"
$cosmosResourceGroup = "dfc-dev-prov-rg"

foreach($collection in $collections) {
    Write-Host "Creating collection: $($collection.Name)"
    $params = @(
        "cosmosdb"
        "collection"
        "create"
        "--db-name"
        "providerportal"
        "--name"
        $cosmosAccount
        "--resource-group-name"
        $cosmosResourceGroup
        "--collection-name"
        $collection.Name
        "--throughput"
        $collection.RequestUnits
    )

    if($collection.PartitionKey) {
        $params += "--partition-key-path"
        $params += $collection.PartitionKey
    }

    & az $params | Out-Null
}