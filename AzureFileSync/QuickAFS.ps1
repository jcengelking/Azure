<#
    Code sample for jcengelking.dev Azure File Sync
    Requires Az Powershell module
#>

$subscriptionID = 'be0a30bd-03db-4764-aca1-71e01ca1caea'
$Central = 'Central US'
$WestCentral = 'West Central US'

Connect-AzAccount
# WARNING: To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code SECRETCODE to authenticate.
Set-AzContext -SubscriptionId $subscriptionID 
# Make a resource group
$RGname = "AzFileSync_RG"
New-AzResourceGroup -ResourceGroupName $RGname -Location $Central

# Create storage accounts
$StorageAccounts = "afssa1", "afssa2"
foreach ($account in $StorageAccounts) {
    New-AzStorageAccount -Name $account -SkuName Standard_ZRS -Location $Central -ResourceGroupName $RGname 
    $accountKeys = Get-AzStorageAccountKey -ResourceGroupName $RGname -Name $account  
    $storageContext = New-AzStorageContext -StorageAccountName $account -StorageAccountKey $accountKeys[0].Value   
    # https://docs.microsoft.com/en-us/azure/storage/files/storage-how-to-create-file-share#create-file-share-through-powershell
    New-AzStorageShare -Name "$($account)share" -context $storageContext
    Set-AzStorageShareQuota -Context $storageContext -ShareName "$($account)share" -Quota 1024
}

