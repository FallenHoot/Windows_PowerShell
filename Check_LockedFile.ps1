
# This needs to be turned on (Might require a restart)
openfiles /local on

# Check Locked Files
$FileOrFolderPath = "C:\ProgramData\chocolatey\lib\kubernetes-cli"
IF((Test-Path -Path $FileOrFolderPath) -eq $false) {
    Write-Warning "File or directory does not exist."       
}
Else {
    $LockingProcess = CMD /C "openfiles /query /fo table | find /I ""$FileOrFolderPath"""
    Write-Host $LockingProcess
}