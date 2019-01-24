Start-Transcript -IncludeInvocationHeader -OutputDirectory (Split-Path $MyInvocation.MyCommand.path)
try {
    #Verify if Chocolatey is installed. If not, install.
    if (!(Get-Module -Name chocolateysteup)) {
        Write-Output "No choco found..."
        Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    }
    Write-Output "Tring to install the package..."
    cinst openssh -params '"/SSHServerFeature"' -y
    cinst vscode git googlechrome firefox git-credential-winstore poshgit 7zip sysinternals -y
    cinst Boxstarter -y
    set-service sshd -StartupType Automatic -PassThru | start-service
    set-service ssh-agent -StartupType Automatic -PassThru | start-service
}
catch {
    Write-Output "Welp."
}
Stop-Transcript

