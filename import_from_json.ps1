param(
    [Parameter(Mandatory=$true)]
    [string] $SourceFile,
    [Parameter(Mandatory=$true)]
    [string] $TargetAccountName,
    [Parameter(Mandatory=$true)]
    [string] $TargetAccountKey,
    [Parameter(Mandatory=$true)]
    [string] $TargetDatabase,
    [Parameter(Mandatory=$true)]
    [string] $TargetCollection,

    [string] $dataMigrationExePath = "C:\ProgramData\chocolatey\lib\azure-documentdb-data-migration-tool\tools\dt.exe"
)


$targetConnection = "AccountEndpoint=https://$($TargetAccountName).documents.azure.com:443/;AccountKey=$($TargetAccountKey);Database=$($TargetDatabase)"

Write-Host "Importing data from $($SourceFile) to collection $($TargetCollection) in $($TargetAccountName)"

$currentPath = Convert-Path -Path .

$fullPathToJson = Join-Path -Path $currentPath -ChildPath $SourceFile

$params = @(
    "/ErrorDetails:All"
    "/s:JsonFile"
    "/s.Files:`"$($fullPathToJson)`""
    "/t:DocumentDB"
    "/t.ConnectionString:`"$targetConnection`""
    "/t.Collection:$($TargetCollection)"
    "/t.UpdateExisting"
)

& $dataMigrationExePath $params

Write-Host "CosmosDb collection export completed."