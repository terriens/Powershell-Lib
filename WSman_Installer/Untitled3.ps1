#create function to Import Certificates Root And add to trusted
Function New-UsersWsman
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [psobject] $MySelfData   
     )
    if($MySelfData.SecureStringUser -ne $null)
    {
        New-LocalUser -Name $MySelfData.LocalUser -Password ($MySelfData.SecureStringUser| ConvertTo-SecureString -AsPlainText -Force) -AccountExpires ((get-date).AddYears(1)) -Description WSmanUserRemote -FullName WSmanUserRemote -UserMayNotChangePassword
    }
    if($MySelfData.SecureStringAdmin -ne $null)
    {
        New-LocalUser -Name $MySelfData.LocalAdmin -Password ($MySelfData.SecureStringAdmin| ConvertTo-SecureString -AsPlainText -Force) -AccountExpires ((get-date).AddYears(1)) -Description WSmanUserRemote -FullName WSmanUserRemote -UserMayNotChangePassword
        Add-LocalGroupMember -Group (Get-LocalGroup -Name admin*) -Member $MySelfData.LocalAdmin 

    }

}

function New-ImportCertificatesMasterSide
{
#Requires -Version 2.0

<#
.SYNOPSIS
    Creates a ClassSystemWSman object based on .

.DESCRIPTION
    New-installer_ClassSystemWSman is an function that creates a PowerShell object to .

.PARAMETER Name
    Name of the function.

.PARAMETER Path
    Path of the location where to create the function. This location must already exist.

.EXAMPLE
     $MyClassWsmanSystem =New-installer_ClassSystemWSman

.INPUTS
    None

.OUTPUTS
    PSobject

.NOTES
    Author:  Terrien Simon
    Website: Todo
    
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [psobject] $MySelfData   ,
        [Parameter(Mandatory)]
        [psobject] $CompleteList   
     )
    Set-Location ($env:LOCALAPPDATA+"\WSmanInstaller\")
    New-WSManInstance winrm/config/Listener -SelectorSet @{Address='*';Transport="HTTPS"} -ValueSet @{Hostname="Server15"; CertificateThumbprint="97BD51DBED0CEA7C37230D5B53237D5C0F7D690D"} 
    #certutil -addstore -f "Root" ($env:COMPUTERNAME+"/"+$MyComputerName+".cert")
    certutil -addstore -f "Root" ("Server15/Server15.cert")
    certutil -addstore -f "My" ("Server15/Server15.cert")
    
    New-WSManInstance winrm/config/Listener -SelectorSet @{Address="*";Transport="HTTPS"} -ValueSet @{Hostname="Server15";CertificateThumbprint="97BD51DBED0CEA7C37230D5B53237D5C0F7D690D"} 
    
}
function Add-LocalDNSEntriesMaster
{

#Requires -Version 2.0

<#
.SYNOPSIS
    Creates a ClassSystemWSman object based on .

.DESCRIPTION
    New-installer_ClassSystemWSman is an function that creates a PowerShell object to .

.PARAMETER Name
    Name of the function.

.PARAMETER Path
    Path of the location where to create the function. This location must already exist.

.EXAMPLE
     $MyClassWsmanSystem =New-installer_ClassSystemWSman

.INPUTS
    None

.OUTPUTS
    PSobject

.NOTES
    Author:  Terrien Simon
    Website: Todo
    
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [psobject] $MySelfData   
     )
     
     if($MySelfData.LocalDNS -eq $true)
     {
         for($i_i=0;$i_i -lt $MySelfData.SlaveOf.Count;$i_i=$i_i +2)
         {
            Add-Content $Env:SystemRoot\system32\drivers\etc\hosts ($MySelfData.SlaveOf[$i_i+1]+" "+$MySelfData.SlaveOf[$i_i])
          #  $str_Temp+=($MySelfData.SlaveOf[$i_i+1]+" "+$MySelfData.SlaveOf[$i_i]) + ("`n")
         }
     }#$str_Temp
}
function Add-LocalDNSEntriesSlave
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [psobject] $MySelfData   
     )
     
     if($MySelfData.LocalDNS -eq $true)
     {
         for($i_i=0;$i_i -lt $MySelfData.MasterOf.Count;$i_i=$i_i +2)
         {
            Add-Content $Env:SystemRoot\system32\drivers\etc\hosts ($MySelfData.MasterOf[$i_i+1]+" "+$MySelfData.MasterOf[$i_i])
          #  $str_Temp+=($MySelfData.SlaveOf[$i_i+1]+" "+$MySelfData.SlaveOf[$i_i]) + ("`n")
         }
     }#$str_Temp
}
function New-MasterWsManHttps
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [psobject] $MySelfData   
     )
     winrm set winrm/config/service '@{AllowUnencrypted="true"}'
     winrm set winrm/config/service '@{AllowUnencrypted="true"}'
     
     Get-ChildItem WSMan:\Localhost\listener | Where -Property Keys -eq "Transport=HTTP" | Remove-Item -Recurse
     New-Item -Path WSMan:\LocalHost\Listener -Transport HTTPS -Address * -CertificateThumbPrint $Cert.Thumbprint –Force
    
     Set-Item WSMan:\localhost\Service\EnableCompatibilityHttpsListener -Value true
     Disable-NetFirewallRule -DisplayName "Windows Remote Management (HTTP-In)"

     Get-Item WSMan:\localhost\Client\TrustedHosts |select Value
     Set-Item WSMan:\localhost\Client\TrustedHosts -Value "10.0.2.33" -Force
}
function New-SlaveWsManHttps
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [psobject] $MySelfData   
     )
     New-WSManInstance -ResourceURI winrm/config/Listener -SelectorSet @{Transport="HTTPS";Address="*"} -ValueSet @{Hostname="HOST";CertificateThumbprint="XXXXXXXXXX"}


     winrm set winrm/config/service '@{AllowUnencrypted="true"}'
     winrm set winrm/config/service '@{AllowUnencrypted="true"}'
     
     Get-ChildItem WSMan:\Localhost\listener | Where -Property Keys -eq "Transport=HTTP" | Remove-Item -Recurse
     New-Item -Path WSMan:\LocalHost\Listener -Transport HTTPS -Address * -CertificateThumbPrint $Cert.Thumbprint –Force
    
     Set-Item WSMan:\localhost\Service\EnableCompatibilityHttpsListener -Value true
     Disable-NetFirewallRule -DisplayName "Windows Remote Management (HTTP-In)"

     Get-Item WSMan:\localhost\Client\TrustedHosts |select Value
     Set-Item WSMan:\localhost\Client\TrustedHosts -Value "10.0.2.33" -Force
}
function New-WsManSetup
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [psobject] $MySelfData   
     )

     New-WSManInstance -ResourceURI winrm/config/Listener -SelectorSet @{Transport="HTTPS";Address="*"} -ValueSet @{Hostname="HOST";CertificateThumbprint="XXXXXXXXXX"}


     winrm set winrm/config/service '@{AllowUnencrypted="true"}'
     winrm set winrm/config/service '@{AllowUnencrypted="true"}'
     
     Get-ChildItem WSMan:\Localhost\listener | Where -Property Keys -eq "Transport=HTTP" | Remove-Item -Recurse
     New-Item -Path WSMan:\LocalHost\Listener -Transport HTTPS -Address * -CertificateThumbPrint $Cert.Thumbprint –Force
    
     Set-Item WSMan:\localhost\Service\EnableCompatibilityHttpsListener -Value true
     Disable-NetFirewallRule -DisplayName "Windows Remote Management (HTTP-In)"

     Get-Item WSMan:\localhost\Client\TrustedHosts |select Value
     Set-Item WSMan:\localhost\Client\TrustedHosts -Value "10.0.2.33" -Force
}
#create function to Import Certificates Self

Set-Location $env:LOCALAPPDATA;
Remove-Item -Recurse -path ($env:LOCALAPPDATA+"\WSmanInstaller") -ErrorAction SilentlyContinue;
Copy-Item -Recurse -Path ($env:USERPROFILE+"\desktop\WSmanInstaller") -Destination $env:LOCALAPPDATA -Force;
Set-Location "WSmanInstaller";
$ArrayList=Import-Clixml -Path "IniData.xml"
$MyComputerName="Server15"
$MyComputerName=$env:COMPUTERNAME
$Self_Data=$ArrayList|where{$_.Name -eq $MyComputerName}
Set-Location ($env:USERPROFILE+"\desktop\WSmanInstaller\"+$MyComputerName)
certutil -addstore -f "My" ($MyComputerName+".cert")
certutil -addstore -f "Root" ($MyComputerName+".cert")
for($i_i =0; $i_i -lt $Self_Data.SlaveOf.Count; $i_i =$i_i+2)
{
    
}