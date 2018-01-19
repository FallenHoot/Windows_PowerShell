##########################################################
# Creating a bootable USB drive for installing an OS
# of choice on UEFI / GPT systems
##########################################################

cls
Write-Host
Write-Host ' Plug in a USB flash (thumb) drive'
Write-Host ' with at least 6 GB or more.'
Write-Host  
Write-Host ' If more than 1 USB flash drives are connected'
Write-Host ' make sure to select the correct one'
Write-Host  
Write-Host ' Are you ready to continue this proccess' -ForeGround Red 
pause
cls
Write-Host
Write-Host 'Checking connected USB(s). Depending on your system, this might take a while...'
Write-Host
$USBDrive = Get-Disk | Where-Object -FilterScript {$_.Bustype -Eq "USB"} | Out-GridView -Title "Select USB Device" -PassThru

Write-Host '##################################################################' -ForeGround Red 
Write-Host '##################################################################' -ForeGround Red 
Write-Host '####                  WARNING WARNING WARNING                 ####' -ForeGround Red 
Write-Host '####                                                          ####' -ForeGround Red 
Write-Host '####      Selected USB will be wiped clean and formatted.     ####' -ForeGround Red 
Write-Host '####    Selecting wrong disk, you will lose All data on it.   ####' -ForeGround Red 
Write-Host '####                                                          ####' -ForeGround Red 
Write-Host '####      If you are unsure, press CTRL + C to abort now.     ####' -ForeGround Red 
Write-Host '##################################################################' -ForeGround Red 
Write-Host '##################################################################' -ForeGround Red 
Write-Host
 
Write-Host ' Is the following info correct, -Name: '$USBDrive.FriendlyName  ' -Serial Number: '$USBDrive.SerialNumber
cls
Write-Host ' Please type YES (not case sensitive) and press Enter'
Write-Host ' to confirm, any other key or string + Enter to exit.'
Write-Host

Write-Host "Type"  -NoNewline
Write-Host " yes " -ForegroundColor Green  -NoNewline
Write-Host "to continue or" -NoNewline
Write-Host " quit " -ForegroundColor Red -NoNewline
Write-Host "to exit: " -NoNewline
$Yes_Quit = Read-Host

    if ($Yes_Quit -ne 'YES')
        {exit}

cls
Write-Host
Write-Host ' Wiping USB flash drive clean & formatting it'

Clear-Disk -FriendlyName $USBDrive.FriendlyName -RemoveData
$USBDrive2 = New-Partition -DiskNumber $USBDrive.DiskNumber -UseMaximumSize -AssignDriveLetter 

$USBDrive2 = $USBDrive2.DriveLetter

Write-Host ' New name for the USB'
$USBName
Write-Host
$USBName = Read-Host

Format-Volume -NewFileSystemLabel "$USBName" -FileSystem FAT32 -DriveLetter $USBDrive2.Trim(":", " ")

$USBDrive2 = ($USBDrive2 + '\')

##########################################################
# USB flash drive cleaned and formatted, asking user to
# mount ISO and enter its drive letter. Entered drive
# letter or path will be written to variable $ISOFolder
##########################################################

cls
Write-Host 
Write-Host ' Right click a Windows 10 ISO image and select "Mount".'
Write-Host 
Write-Host ' When done, enter the drive letter of mounted ISO'
Write-Host ' below and press Enter.'
Write-Host 
Write-Host ' If you want to add additional files and folders to USB,'
Write-Host ' copy the the contents of mounted ISO to a folder. Copy'
Write-Host ' additional content for instance customised "autounattend.xml"'
Write-Host ' for unattended "Hands-Free" installation, driver installers'
Write-Host ' and such to same folder, enter the path to that folder'
Write-Host ' and press Enter.'
Write-Host
Write-Host ' Examples:'
Write-Host ' - ISO mounted as drive F:, no additional content required, enter F'
Write-Host ' - ISO contents copied to "D:\ISO_Files", enter D:\ISO_Files'
Write-Host ' - ISO contents copied to "X:\MyStuff\ISO", enter X:\MyStuff\ISO' 
Write-Host
$ISOFolder = Read-Host -Prompt ' Enter path to source folder, press Enter'

##########################################################
# Check if path entered by user is a drive letter by
# checking its length. If length is a single character, 
# it is a drive letter for mounted ISO in which case we
# add a colon (:) to variable value, X becoming X:
##########################################################

if ($ISOFolder.length -eq 1)
    {$ISOFolder = $ISOFolder + ":"}

$WimCount = 0
if ((Test-Path $ISOFolder\Sources\install.wim) -or 
    (Test-Path $ISOFolder\x86\Sources\install.wim) -or
    (Test-Path $ISOFolder\x64\Sources\install.wim) -or
    (Test-Path $ISOFolder\Sources\install.esd) -or 
    (Test-Path $ISOFolder\x86\Sources\install.esd) -or
    (Test-Path $ISOFolder\x64\Sources\install.esd))
        {$WimCount = 1}        
    else 
        {
        cls
        Write-Host
        Write-Host ' No Windows 10 installation files found.'
        Write-Host ' Please check mounted ISO letter or path'
        Write-Host ' to folder containing installation files'
        Write-Host ' and run script again.'
        Write-Host
        Pause
        Exit
        }
        
##########################################################
# Copying ISO content to USB flash drive
##########################################################

cls
$Files = Get-ChildItem -Path $ISOFolder -Recurse
$FileCount = $Files.count
$i=0
Foreach ($File in $Files) {
    $i++
    Write-Progress -activity "Copying files to USB. Get a cup of java or shot of single malt, this will take a few minutes..." -status "$File ($i of $FileCount)" -percentcomplete (($i/$FileCount)*100)
    if ($File.psiscontainer) {$SourcefileContainer = $File.parent} else {$SourcefileContainer = $File.directory}
    $RelativePath = $SourcefileContainer.fullname.SubString($ISOFolder.length)
    Copy-Item $File.fullname ($USBDrive + $RelativePath) 
}

cls
Write-Host                                                                        
Write-Host ' Bootable ' "$USBName" ' USB drive was created.'
Write-Host