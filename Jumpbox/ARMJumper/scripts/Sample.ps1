cls
$RGName = "mechas_jump_rg";
$VMName = "mjvm";
$VMUsername = "mjadmin";
$DeployLocation = "West US 2"
$ChocoPackages = "sysinternals;visualstudiocode;git;googlechrome;firefox;git-credential-winstore;poshgit;7zip;boxstarter";
$ARMTemplate = "C:\@SourceControl\GitHub\ARMChocolatey\azuredeploy.json"

#cinst openssh -params '"/SSHServerFeature"' -y

# 1. Login
#Login-AzureRmAccount

#2. Create a resource group
New-AzureRmResourceGroup -Name $RGName -Location $DeployLocation -Force

#3. Create resources within RG
$sw = [system.diagnostics.stopwatch]::startNew()
New-AzureRmResourceGroupDeployment -ResourceGroupName $RGName -TemplateFile $ARMTemplate -deployLocation $DeployLocation -vmName $VMName -vmAdminUserName $VMUsername -vmIPPublicDnsName $VMName -chocoPackages $ChocoPackages -Mode Complete -Force 
$sw | Format-List -Property *

#4. Get the RDP file
Get-AzureRmRemoteDesktopFile -ResourceGroupName $RGName -Name $VMName -Launch -Verbose -Debug

