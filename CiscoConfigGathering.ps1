Write-Host "__________        .__          "
Write-Host "\______   \___.__.|  |   ____  "
Write-Host "|     ___<   |  ||  |  /  _ \ "
Write-Host "|    |    \___  ||  |_(  <_> )"
Write-Host "|____|    / ____||____/\____/ "
Write-Host "          \/                  "

Set-Alias plink "C:\Program Files (x86)\PuTTY\plink.exe"
$switchhostname=@("UBAF SW1","UBAF SW1Bis","UBAF SW2","UBAF SW2Bis")
$SwitchIP=@("172.16.230.16","172.16.230.20","172.16.230.16","172.16.230.20")
$pwd=read-host "TypeHerePassword"
$Switchusername="admin"

Write-Host
$Status=0
$Path=("C:\Cisco\"+(Get-date -format yyyy_MM_dd) + "\")
if(!(Test-Path -Path $Path ))
{
    New-Item -ItemType directory -Path $Path
}

for($i_i=0; $i_i -le $SwitchIP.count;$i_i++)
{
    $Status++;
    Write-Progress -Activity Updating -Status 'Progress->' -PercentComplete ($Status*100/4) -CurrentOperation InnerLoop; 
    echo $SwitchIP
    echo y |plink -ssh -2 $SwitchIP[$i_i] -l $Switchusername -pw $pwd
    plink -ssh -2 $SwitchIP[$i_i] -l $Switchusername -pw $pwd "sh run" >> ($Path+$switchhostname[$i_i]+".txt") 2>&1
}
Write-Host  "End of process"