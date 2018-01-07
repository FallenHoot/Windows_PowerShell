### Checks if Administration mode is on ###
Function Test_Admin {
  $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
  $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}
if ((Test_Admin) -eq $false)  {
    if ($elevated) 
    {
        # tried to elevate, did not work, aborting
    } 
    else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
}

exit
}

### Runs Meltdown_Spectre Script ###
Function Meltdown_Spectre {
Set-ExecutionPolicy RemoteSigned -Scope Currentuser
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Get-ExecutionPolicy
Install-Module -Name SpeculationControl
Import-Module SpeculationControl
Get-SpeculationControlSettings
}

Function Run {
Test_Admin
Meltdown_Spectre
}

Run