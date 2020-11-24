(New-Object System.Net.WebClient).DownloadFile('https://nodejs.org/dist/latest-v12.x/node-v12.19.1-x64.msi', “$env:temp\node.msi”);
(Start-Process "msiexec.exe" -ArgumentList "/i `"$env:temp\node.msi`" /qn" -NoNewWindow -Wait -PassThru).ExitCode
