#Requires -Version 2.0
#define 

#-------------------------------------------------------------------------------------------------------------------------------------
Function Get-Folder
{
    Add-Type -AssemblyName System.Windows.Forms
    $FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    [void]$FolderBrowser.ShowDialog()
    return $FolderBrowser.SelectedPath
}
#-------------------------------------------------------------------------------------------------------------------------------------

    
function New-installer_ClassSystemWSman
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
    $installer_ClassSystemWSman =New-Object -TypeName psobject
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name Name -value "ServerName"
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name IP -Value "192.168.1.10"
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name LocalDNS -Value $false
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name MasterOf -Value @()
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name SlaveOf -Value @()
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name MasterOfBool -Value $false
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name SlaveOffBool -Value $false
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name http -Value $false
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name https -Value $true
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name SelfSigned_Certificate -Value $true
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name CertificationName -Value $null
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name ThumbPrint -Value $null
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name BeginningDate -Value ((Get-Date -Format "yyyy-MM-dd"))
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name EndDate -Value ((Get-Date((Get-Date).AddYears(2)) -Format "yyyy-MM-dd"))
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name LocalAdmin -Value "Null"
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name SecureStringAdmin -Value (ConvertTo-SecureString -String "P@ssw0rd" -AsPlainText -Force )
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name LocalUser -Value "Null"
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name SecureStringUser -Value (ConvertTo-SecureString -String "P@ssw0rd" -AsPlainText -Force )
    

    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name Policy -Value (Get-ExecutionPolicy).ToString()
    
    return $installer_ClassSystemWSman 
}
function New-SystemWSmanBasic
{
    <#
.SYNOPSIS
    Creates a new PowerShell script module in the specified location.

.DESCRIPTION
    New-MrScriptModule is an advanced function that creates a new PowerShell script module in the
    specified location including creating the module folder and both the PSM1 script module file
    and PSD1 module manifest.

.PARAMETER Name
    Name of the system

.PARAMETER IP
    IP of the system

.EXAMPLE
     $WsmanSystemNode = New-SystemWSmanBasic -Name "MyServer" -IP "192.168.1.10"

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
        [string]$Name,
             
 
        [Parameter(Mandatory)]
        [string]$IP

     
    )
    $temp=New-installer_ClassSystemWSman;
    $temp.IP =$IP;
    $temp.Name =$Name;
    return $temp;
}

function New-installer_SystemWSmanCreateSignature #
{
    <#
.SYNOPSIS
    Create an Array of SystemWSMAN objects via a csv file 


.DESCRIPTION
    Create an Array of SystemWSMAN objects by using a csv file

.PARAMETER Path

.EXAMPLE
     $ArrayWsamnSystem=New-installer_SystemWSmanBasicArrayMassiveCSV -Litteral_Path $PathOfMasseditFoder
     -------FILE format exemple---------
        Name;IP
        Server01;192.168.1.1
        Server02;192.168.1.2
        Server03;192.168.1.3
        Server04;192.168.1.4


.INPUTS
    None

.OUTPUTS
   PSobject[]
  
.NOTES
    Author:  Terrien Simon
    Website: Todo
#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $ArrayNodesList,
        [Parameter(Mandatory)]
        $Litteral_Path
     )
    
    $a_SystemWSmanArray=@();
    $t_TempsCSV= Import-Csv -Delimiter "," -LiteralPath $Litteral_Path
     
    for($i_i =0 ; $i_i -lt $t_TempsCSV.Count ; $i_i ++)
    {
        $t_temp=New-SystemWSmanBasic -Name $t_TempsCSV[$i_i].Name.ToString() -IP $t_TempsCSV[$i_i].IP.ToString();

        $a_SystemWSmanArray+=($t_temp);
    }
    return $a_SystemWSmanArray;
}
function New-installer_SystemWSmanPhaseOneArrayMassiveCSV #
{
    <#
.SYNOPSIS
    Create an Array of SystemWSMAN objects via a csv file 


.DESCRIPTION
    Create an Array of SystemWSMAN objects by using a csv file

.PARAMETER Path

.EXAMPLE
     $ArrayWsamnSystem=New-installer_SystemWSmanBasicArrayMassiveCSV -Litteral_Path $PathOfMasseditFoder
     -------FILE format exemple---------
        Name;IP
        Server01;192.168.1.1
        Server02;192.168.1.2
        Server03;192.168.1.3
        Server04;192.168.1.4


.INPUTS
    None

.OUTPUTS
   PSobject[]
  
.NOTES
    Author:  Terrien Simon
    Website: Todo
#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Litteral_Path    
     )
    $a_SystemWSmanArray=@();
    $a_Master=@();
    $a_Slave=@();

    $t_TempsCSV= Import-Csv -Delimiter ";" -LiteralPath $Litteral_Path ;
    for($i_i =0 ; $i_i -lt $t_TempsCSV.Count ; $i_i ++)
    {
        Write-Verbose "Creating SystemWSmanBasic Object and Adding IP and hostname"
        $t_temp=New-SystemWSmanBasic -Name $t_TempsCSV[$i_i].Name.ToString() -IP $t_TempsCSV[$i_i].IP.ToString();
        Write-Verbose "Adding a selfSigned Signature"
        $t_temp.SelfSigned_Certificate=$t_TempsCSV[$i_i].Need_a_SelfSigned;
        Write-Verbose "If the creation of a local user account create the Username and Password"
        if($t_TempsCSV[$i_i].CreateLocalAccount -eq "true")
        {
            $t_temp.LocalUser="WSmanUserRemote";
            $t_temp.SecureStringUser =  $t_TempsCSV[$i_i].Password
        }
        Write-Verbose "If the creation of a local Admin account create the Username and Password"
        if($t_TempsCSV[$i_i].CreateLocalAccountAdmin -eq "true")
        {
            $t_temp.LocalAdmin="WSmanAdminRemote";
            $t_temp.SecureStringAdmin =  $t_TempsCSV[$i_i].PasswordAdmin  
        }
        Write-Verbose "Adding if necessary this object to the Master Array"
        if($t_TempsCSV[$i_i].Master -eq "true")
        {
            $a_Master+=$t_TempsCSV[$i_i].Name.ToString();
            $a_Master+=$t_TempsCSV[$i_i].IP.ToString();
            $t_temp.MasterOfBool=$true
        }
        Write-Verbose "Adding if necessary this object to the Slave Array"
        if($t_TempsCSV[$i_i].Slave -eq "true")
        {
            $a_Slave+=$t_TempsCSV[$i_i].Name.ToString();
            $a_Slave+=$t_TempsCSV[$i_i].IP.ToString();
            $t_temp.SlaveOffBool=$true
        }
        Write-Verbose "Adding the option for if the hostnames need to be added to the host"
        if($t_TempsCSV[$i_i].Need_Dns_Entry -eq "true")
        {
            $t_temp.LocalDNS =$true;
        
        }
        Write-Verbose "Adding Object to the Array a_SystemWSmanArray"
        $a_SystemWSmanArray+=($t_temp);
    }
    #$i_i =0 #for debug
    for($i_i =0 ; $i_i -lt $a_SystemWSmanArray.Count ; $i_i ++)
    {
        Write-Verbose "Adding Object to the slave Array to the object"
        if($a_SystemWSmanArray[$i_i].MasterOfBool -eq $true)
        {
            $a_SystemWSmanArray[$i_i].MasterOf+=$a_Master;
        }
        Write-Verbose "Adding Object to the slave Array to the object"
        if($a_SystemWSmanArray[$i_i].SlaveOffBool -eq $true)
        {
            $a_SystemWSmanArray[$i_i].SlaveOf+=$a_Slave;
        }
    }
    return $a_SystemWSmanArray;
}
function New-installer_SystemWSmanPhaseTwoArrayMassiveCSV #
{
    <#
.SYNOPSIS
    Create an Array of SystemWSMAN objects via a csv file 


.DESCRIPTION
    Create an Array of SystemWSMAN objects by using a csv file

.PARAMETER Path

.EXAMPLE
     $ArrayWsamnSystem=New-installer_SystemWSmanBasicArrayMassiveCSV -Litteral_Path $PathOfMasseditFoder
     -------FILE format exemple---------
        Name;IP
        Server01;192.168.1.1
        Server02;192.168.1.2
        Server03;192.168.1.3
        Server04;192.168.1.4


.INPUTS
    None

.OUTPUTS
   PSobject[]
  
.NOTES
    Author:  Terrien Simon
    Website: Todo
#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Litteral_Path    
     )
    $a_SystemWSmanArray=@();
    $a_ArrayList=New-installer_SystemWSmanPhaseOneArrayMassiveCSV -Litteral_Path $Litteral_Path
    $Targetdir = ($env:USERPROFILE+"\desktop\WSmanInstaller\");
    if(!(Test-Path -Path $Targetdir))
    {
        New-Item -ItemType directory -Path $Targetdir
    }
    Set-Location -Path $Targetdir
    foreach($t_temp in $a_ArrayList)
    {
        if(!(Test-Path -Path $t_temp.Name))
        {
            New-Item -ItemType directory -Path $t_temp.Name
        }
        $A_Certificate=New-SelfSignedCertificate -CertStoreLocation Cert:\LocalMachine\My -DnsName $t_temp.Name
        $t_temp.Thumbprint=$A_Certificate.Thumbprint;
        Export-Certificate -Cert ("Cert:\LocalMachine\My\"+$A_Certificate.Thumbprint) -FilePath ( $Targetdir +"\"+$t_temp.Name+"\"+$t_temp.Name+".cert") -Force
        $t_temp.CertificationName=( $Targetdir +"\"+$t_temp.Name+"\"+$t_temp.Name+".cert")
        Remove-Item ("Cert:\LocalMachine\My\"+$A_Certificate.Thumbprint)
    }
    $a_ArrayList|Export-Clixml -LiteralPath ($Targetdir+"IniData.xml")  -Force;
    return $a_ArrayList;
}

$Litteral_Path = "C:\Users\pc-test\Desktop\MassiveWSAMNEditor.csv";
$a_SystemWSmanArray=New-installer_SystemWSmanPhaseTwoArrayMassiveCSV -Litteral_Path $Litteral_Path;
#New-SelfSignedCertificate -CertStoreLocation Cert:\LocalMachine\My -DnsName $t_temp.Name -Extension $t_temp.Name

