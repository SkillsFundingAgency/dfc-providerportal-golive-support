param(
    [Parameter(Mandatory=$true)]
    [string] $SourceAccountName,
    [Parameter(Mandatory=$true)]
    [string] $SourceAccountKey,
    [Parameter(Mandatory=$true)]
    [string] $SourceDatabase,
    [Parameter(Mandatory=$true)]
    [string] $SourceCollection,
    [Parameter(Mandatory=$true)]
    [string] $File,
    [string] $dataMigrationExePath = "C:\ProgramData\chocolatey\lib\azure-documentdb-data-migration-tool\tools\dt.exe"
)


$sourceConnection = "AccountEndpoint=https://$($SourceAccountName).documents.azure.com:443/;AccountKey=$($SourceAccountKey);Database=$($SourceDatabase)"

Write-Host "Exporting data from collection $($SourceCollection) from $($SourceAccountName) to $($File)"

$currentPath = Convert-Path -Path .

$fullPathToJson = Join-Path -Path $currentPath -ChildPath $File

$params = @(
    "/ErrorDetails:All"
    "/s:DocumentDB"
    "/s.ConnectionString:`"$sourceConnection`""
    "/s.Collection:$($SourceCollection)"
    "/t:JsonFile"
    "/t.File:`"$($fullPathToJson)`""
    "/t.Overwrite" 
)

Write-Host "Migration for collection $($collection) completed."

& $dataMigrationExePath $params

Write-Host "CosmosDb collection export completed."