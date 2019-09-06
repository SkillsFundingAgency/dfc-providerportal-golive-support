$collections = Get-Content -Path ./collections.json | ConvertFrom-Json

$cosmosAccount = "dfc-prd-prov-cdb"
$cosmosResourceGroup = "dfc-prd-prov-rg"

foreach($collection in $collections) {
    Write-Host "Removing collection: $($collection.Name)"
    $params = @(
        "cosmosdb"
        "collection"
        "delete"
        "--db-name"
        "providerportal"
        "--name"
        $cosmosAccount
        "--resource-group-name"
        $cosmosResourceGroup
        "--collection-name"
        $collection.Name
    )

    & az $params | Out-Null
}