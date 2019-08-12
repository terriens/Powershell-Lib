Get-WmiObject -Class "Win32_NetworkAdapterConfiguration"#--------------------------------Set location to local app data-----------------------------
Set-Location $env:LOCALAPPDATA;
#--------------------------------Cleaning all data linked to Wsman-----------------------------
Remove-Item -Recurse -path ($env:LOCALAPPDATA+"\WSmanInstaller") -ErrorAction SilentlyContinue;
#--------------------------------Copy the all data linked to Wsman from the desktop to Local app data-----------------------------
Copy-Item -Recurse -Path ($env:USERPROFILE+"\desktop\WSmanInstaller") -Destination $env:LOCALAPPDATA -Force;
Set-Location "WSmanInstaller";
#--------------------------------Inititalising all data related to Wsamn Strcuture-----------------------------
$ArrayList=Import-Clixml -Path "IniData.xml"
$MyComputerName=$env:COMPUTERNAME

#--------------------------------Copy the all data linked to Wsman from the desktop to Local app data-----------------------------
$Self_Data=$ArrayList|where{$_.Name -eq $MyComputerName}
Set-Location ($env:USERPROFILE+"\desktop\WSmanInstaller\"+$MyComputerName)

#--------------------------------Add your own Certification to cert store -----------------------------
certutil -addstore -f "My" ($MyComputerName+".cert")
certutil -addstore -f "Root" ($MyComputerName+".cert")
cd ..
#--------------------------------Add Certification to cert store -----------------------------
for($i_i =0; $i_i -lt $Self_Data.SlaveOf.Count; $i_i =$i_i+2)
{
    certutil -addstore -f "Root" ($Self_Data.SlaveOf[$i_i] +"\"+$Self_Data.SlaveOf[$i_i] +".cert")
}
#--------------------------------Create local user for Wsman Account for 1 year -----------------------------
if($Self_Data.SecureStringUser -ne $null)
{
    New-LocalUser -Name $Self_Data.LocalUser -Password ($Self_Data.SecureStringUser| ConvertTo-SecureString -AsPlainText -Force) -AccountExpires ((get-date).AddYears(1)) -Description WSmanUserRemote -FullName WSmanUserRemote -UserMayNotChangePassword
}
#--------------------------------Create Admin user for Wsman Account for 1 year -----------------------------
if($Self_Data.SecureStringAdmin -ne $null)
{
    New-LocalUser  -Name $Self_Data.LocalAdmin -Password ($Self_Data.SecureStringAdmin | ConvertTo-SecureString -AsPlainText -Force) -AccountExpires ((get-date).AddYears(1)) -Description WSmanUserRemote -FullName WSmanUserRemote -UserMayNotChangePassword
    Add-LocalGroupMember -Group (Get-LocalGroup -Name admin*) -Member $Self_Data.LocalAdmin 
}


#--------------------------------Remove all previous Wsamn Setup -----------------------------
Disable-PSRemoting -Force -verbose;
Disable-WsmanCredssp -Role Client -verbose;
Disable-WsmanCredssp -Role Server -verbose;
#--------------------------------Create Wsamn Setup -------------------------------------------------------
Enable-PSRemoting -Force -verbose;
Set-WSmanQuickConfig  -Force -verbose;
#--------------------------------Setting wsman ->Http remove and adding https -----------------------------
#get-childItem WSMan:\localhost\Listener |where -Property Keys -eq "Transport=HTTP" | Remove-Item -Recurse  -Verbose;

winrm create winrm/config/Listener?Address=*+Transport=HTTPS @{Hostname=$env:COMPUTERNAME;CertificateThumbprint=$Self_Data.ThumbPrint}

Set-Item WSMan:\localhost\Client\AllowUnencrypted -Value false
Set-Item WSMan:\localhost\Service\AllowUnencrypted -Value false

Set-Item WSMan:\localhost\Service\EnableCompatibilityHttpListener -Value false
Set-Item WSMan:\localhost\Service\EnableCompatibilityHttpsListener -Value true






winrm create winrm/config/Listener?Address=*+Transport=HTTPS @{Hostname=$env:COMPUTERNAME;CertificateThumbprint=$Self_Data.ThumbPrint}
New-Item -path WSMan:\localhost\Listener\ -Transport HTTPS -HostName $env:COMPUTERNAME -Address "192.168.141.129" -CertificateThumbPrint $Self_Data.ThumbPrint -Force -Verbose


winrm create wsman:microsoft.com/wsman/2005/06/config/Listener?IP=192.168.2.1+Port=443 @{Hostname="host";CertificateThumbprint="xxx"}
winrm create wsman:microsoft.com/wsman/2005/06/config/Listener?IP=*+Port=443 @{Hostname=$env:COMPUTERNAME;MACAddress="00-0C-29-C6-AE-E7";CertificateThumbprint=$Self_Data.ThumbPrint}
if($MySelfData.LocalDNS -eq $true)
{
    for($i_i=0;$i_i -lt $Self_Data.SlaveOf.Count;$i_i=$i_i +2)
    {
        Add-Content ($Env:SystemRoot+"\system32\drivers\etc\hosts") ($Self_Data.SlaveOf[$i_i+1]+" "+$Self_Data.SlaveOf[$i_i])
        #  $str_Temp+=($MySelfData.SlaveOf[$i_i+1]+" "+$MySelfData.SlaveOf[$i_i]) + ("`n")
    }
}
{
for($i_i=0;$i_i -lt $Self_Data.Master.Count;$i_i=$i_i +2)
    {
        Add-Content ($Env:SystemRoot+"\system32\drivers\etc\hosts") ($Self_Data.SlaveOf[$i_i+1]+" "+$Self_Data.SlaveOf[$i_i])
        #  $str_Temp+=($MySelfData.SlaveOf[$i_i+1]+" "+$MySelfData.SlaveOf[$i_i]) + ("`n")
    }
}

New-Item -path WSMan:\localhost\Listener\ -Transport HTTPS -HostName $env:COMPUTERNAME -Address "192.168.141.129" -CertificateThumbPrint $Self_Data.ThumbPrint -Force -Verbose

     