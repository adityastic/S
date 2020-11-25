#Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression (New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/adityastic/S/main/scripts/windows-7.ps1")

(New-Object System.Net.WebClient).DownloadFile('https://nodejs.org/download/release/v12.20.0/node-v12.20.0-x64.msi', "$env:temp\node.msi")
(Start-Process "msiexec.exe" -ArgumentList "/i `"$env:temp\node.msi`" /qn" -NoNewWindow -Wait -PassThru).ExitCode
