#The following needs to be enabled on both EC2 instance and local machine
#Enable-PSremoting -force

 $EC2_PublicIP = ""
 $PSRemoting_Port = 5986

#Opens Port TCP/5986 = HTTPS

Set-Item WSMan:\localhost\Service\EnableCompatibilityHttpsListener -Value true

#Change Port
Set-Item wsman:\localhost\listener\listener*\port –value $PSRemoting_Port


$credential = Get-Credential -Message "Provide Domain/Username and Password"
$session = new-pssession $EC2_PublicIP -Port $PSRemoting_Port -credential $credential  
enter-pssession $session  
Write-Host "Hello, World (from $env:COMPUTERNAME)"