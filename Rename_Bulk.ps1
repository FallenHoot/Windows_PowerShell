$Dir="F:\Test\Images"
Function Main{
$Files=Get-ChildItem $Dir -Recurse | Where-Object {$_.name -like "*DS.TIF"} 
$Files | Rename-Item –NewName { $_.name –replace "DS","DS-main" }
}

Function alt01{
$Files=Get-ChildItem $Dir -Recurse | Where-Object {$_.name -like "*DS_a.TIF"} 
$Files | Rename-Item –NewName { $_.name –replace "_a","-alt01" }
}

Function alt02{
$Files=Get-ChildItem $Dir -Recurse | Where-Object {$_.name -like "*DS_b.TIF"} 
$Files | Rename-Item –NewName { $_.name –replace "_b","-alt02" }
}
Main
alt01
alt02