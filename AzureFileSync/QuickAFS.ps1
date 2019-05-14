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

# Create Azure File Sync service
<#
https://github.com/MicrosoftDocs/azure-docs/blob/master/articles/storage/files/storage-sync-files-deployment-guide.md
https://docs.microsoft.com/en-us/azure/storage/files/storage-sync-files-deployment-guide?tabs=azure-powershell#tabpanel_CeZOj-G++Q-1_azure-powershell
#>
storageSyncName = "AFSSyncService"
$storageSync = New-AzStorageSyncService -ResourceGroupName $RGname -Name $storageSyncName -Location $Central


# Download and install the agent, code sourced directly from docs.microsoft.com
# Gather the OS version
$osver = [System.Environment]::OSVersion.Version

# Download the appropriate version of the Azure File Sync agent for your OS.
if ($osver.Equals([System.Version]::new(10, 0, 17763, 0))) {
    Invoke-WebRequest `
        -Uri https://aka.ms/afs/agent/Server2019 `
        -OutFile "StorageSyncAgent.msi"
} elseif ($osver.Equals([System.Version]::new(10, 0, 14393, 0))) {
    Invoke-WebRequest `
        -Uri https://aka.ms/afs/agent/Server2016 `
        -OutFile "StorageSyncAgent.msi" 
} elseif ($osver.Equals([System.Version]::new(6, 3, 9600, 0))) {
    Invoke-WebRequest `
        -Uri https://aka.ms/afs/agent/Server2012R2 `
        -OutFile "StorageSyncAgent.msi" 
} else {
    throw [System.PlatformNotSupportedException]::new("Azure File Sync is only supported on Windows Server 2012 R2, Windows Server 2016, and Windows Server 2019")
}

# Install the MSI. Start-Process is used to PowerShell blocks until the operation is complete.
# Note that the installer currently forces all PowerShell sessions closed - this is a known issue.
Start-Process -FilePath "StorageSyncAgent.msi" -ArgumentList "/quiet" -Wait

# Note that this cmdlet will need to be run in a new session based on the above comment.
# You may remove the temp folder containing the MSI and the EXE installer
Remove-Item -Path ".\StorageSyncAgent.msi" -Recurse -Force