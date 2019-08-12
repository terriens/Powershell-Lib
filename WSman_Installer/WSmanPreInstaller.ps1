class ClassCertificat {
    [string]$Name = "ComputerName";
    [string] $IP = "192.168.1.1";
    [string] $CertificationName = "";
    [string]$ThumbPrint = "";
    [datetime] $BeginningDate = (Get-Date );
    [datetime] $EndDate = (Get-Date((Get-Date).AddYears(2)) );
};
class ClassWSman_Installer 
{      
    [string]$Name = $true;
    [string]$IP = $true;
    [string]$CertificationName = $null;
    [string]$MACadress = "ff:ff:ff:ff:ff"
    
    [boolean]$http = $true;
    [boolean]$https = $true;
    [boolean]$ActivateCIM  = $true
    [boolean]$AllowFirewallRuleCreated = $true;
    
    [uint32]$WSMANPortHttp = 5985;
    [uint32]$WSMANPortHttps = 5986;
    [uint32]$WSMANPortCIM = 5989
    
    [boolean]$Master = $true;
    [boolean]$Slave = $true;
    
    [ClassCertificat[]]$Master_Of = @();   
    [ClassCertificat[]]$Slave_Of = @();
    
    [string]$CreateLocalAccount  = $true;
    [string]$PasswordLocal = ((ConvertTo-SecureString -String "P@55w0rd" -AsPlainText -Force  )|ConvertFrom-SecureString -Key (1..32)).ToString()
    
    [string]$CreateLocalAccountAdmin  = $true;
    [string]$PasswordAdmin = ((ConvertTo-SecureString -String "P@55w0rd" -AsPlainText -Force  )|ConvertFrom-SecureString -Key (1..32)).ToString()
    
    [boolean]$Need_Dns_Entry  = $true;
    [string]$DNS_Entry_Master ="";
    [string]$DNS_Entry_Slave  ="";
    
};

function New_Installer_ClassCertificat {
    #Requires -Version 4.0

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
    )
    $installer_ClassCertificat =New-Object -TypeName psobject;
    $installer_ClassCertificat |Add-Member -Type NoteProperty -Name Name -Value $true;
    $installer_ClassCertificat |Add-Member -Type NoteProperty -Name IP -Value $true;
    $installer_ClassCertificat |Add-Member -Type NoteProperty -Name CertificationName -Value $null;
    $installer_ClassCertificat |Add-Member -Type NoteProperty -Name ThumbPrint -Value $null;
    $installer_ClassCertificat |Add-Member -Type NoteProperty -Name BeginningDate -Value ((Get-Date -Format "yyyy-MM-dd"));
    $installer_ClassCertificat |Add-Member -Type NoteProperty -Name EndDate -Value ((Get-Date((Get-Date).AddYears(2)) -Format "yyyy-MM-dd"));
    return  $installer_ClassCertificat;
}
function New_Installer_ClassWSman {
    #Requires -Version 4.0

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
    )
    $installer_ClassSystemWSman =New-Object -TypeName psobject
    
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name Name -Value $true;
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name IP -Value $true;
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name CertificationName -Value $null;
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name MACadress -Value "ff:ff:ff:ff:ff"
    
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name http -Value $true;
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name https -Value $true;
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name ActivateCIM  -Value $true
    
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name WSMANPortHttp -Value 5985;
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name WSMANPortHttps -Value 5986;
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name WSMANPortCIM -Value 5989
    
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name AllowFirewallRuleCreated -Value $true;
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name Master -Value $true;
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name Slave -Value $true;
    
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name Master_Of -Value @();   
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name Slave_Of -Value @();
    
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name CreateLocalAccount  -Value $true;
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name Password -Name SecureStringUser -Value (ConvertTo-SecureString -String "P@55w0rd" -AsPlainText -Force );
    
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name CreateLocalAccountAdmin  -Value $true;
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name PasswordAdmin  -Name SecureStringUser -Value (ConvertTo-SecureString -String "P@55w0rd" -AsPlainText -Force );
    
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name Need_Dns_Entry  -Value $true;
    
    
    return $installer_ClassSystemWSman;
}

Function Get-Folder
{
    Add-Type -AssemblyName System.Windows.Forms
    $FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    [void]$FolderBrowser.ShowDialog()
    return $FolderBrowser.SelectedPath
}
 Function Get-FileDialog
{
    Add-Type -AssemblyName System.Windows.Forms
    $FileDialog = New-Object System.Windows.Forms.OpenFileDialog
    [void]$FileDialog.ShowDialog()
    return $FileDialog.FileName
}
function Create_SelfSigned 
{
    [CmdletBinding()]
    param (

    )


}
function Create_OpenSSL_Private 
{
    [CmdletBinding()]
    param (    
    )

}
function Create_OpenSSL_Public 
{
    [CmdletBinding()]
    param (    
    )

}



