# based on https://boxstarter.org/Learn/WebLauncher

Invoke-WebRequest `
-UseBasicParsing https://boxstarter.org/bootstrapper.ps1 | `
Invoke-Expression; `
get-boxstarter -Force; `
Install-BoxstarterPackage -PackageName https://gist.githubusercontent.com/jcengelking/a1b6c46ccfa1aee26ea903436375faab/raw/54f36a5dd31a2e5f7c56b6054c30ef4d2c4d7062/boxgist-jbox.txt -DisableReboots