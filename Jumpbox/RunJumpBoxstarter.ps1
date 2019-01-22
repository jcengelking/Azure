<# 
    based on https://boxstarter.org/Learn/WebLauncher
    https://blogs.technet.microsoft.com/stefan_stranger/2017/07/31/using-azure-custom-script-extension-to-execute-scripts-on-azure-vms/
#>

Start-Transcript -IncludeInvocationHeader -OutputDirectory (Split-Path $MyInvocation.MyCommand.path)
try {
    #Verify if Boxstarter is installed. If not, install.
    if (!(Get-Module -Name Boxstarter.Bootstrapper)) {
        Write-Output "No boxstarter found..."
        Invoke-WebRequest -UseBasicParsing https://boxstarter.org/bootstrapper.ps1 | Invoke-Expression; get-boxstarter -Force
    }
    Write-Output "Tring to install the package..."
    Install-BoxstarterPackage `
    -PackageName https://gist.githubusercontent.com/jcengelking/a1b6c46ccfa1aee26ea903436375faab/raw/54f36a5dd31a2e5f7c56b6054c30ef4d2c4d7062/boxgist-jbox.txt `
    -DisableReboots
    
}
catch {
    Write-Output "Welp."
}
Stop-Transcript