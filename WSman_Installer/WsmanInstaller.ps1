$installer_Desktop=($env:USERPROFILE+"\desktop\");
$installer_Path_Script_Generated=$installer_Desktop+"WSman_Installer"
New-Item -ItemType Directory -Path $installer_Path_Script_Generated -Force

#-------------------------------------------------------------------------------------------------------------------------------------
Function Get-Folder
{
    Add-Type -AssemblyName System.Windows.Forms
    $FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    [void]$FolderBrowser.ShowDialog()
    return $FolderBrowser.SelectedPath
}
#-------------------------------------------------------------------------------------------------------------------------------------
Start-Transcript -Path ($env:USERPROFILE+"/desktop/Transcript.txt") 
Write-Verbose -Message "Start -Create enum Type_of_User_Structure"
    Add-Type -TypeDefinition @"
   public enum Type_of_User_Structure
   {
    Active_Directory,
    Radius_or_Ldap,
    Stand_Alone,
    Default
   }
"@
   # $installer_User_Structure=[Type_of_User_Structure]::Default
    Write-Verbose -Message "End -Created enum Type_of_User_Structure and variable declared"

function Set-User_Structure 
{
    

    
    Write-Verbose -Message "Creating the Menu" 
    Write-Host "What type of Instrastructure User point of view is it?"
    Write-Host "1  Active Directory                       "
    Write-Host "2  Radius or Ldap                       "
    Write-Host "3  Stand Alone                       "
    Write-Host "9  Exit                       "
    Write-Verbose -Message "Awating for input"

   [int] $installer_value=( Read-Host "What is your option?") 

        switch($installer_value)
    {
        1 {echo "Setting AD Structure";$installer_User_Structure = [Type_of_User_Structure]::Active_Directory; break;}
        2 {echo "Setting Radius or Ldap Structure";$installer_User_Structure = [Type_of_User_Structure]::Radius_or_Ldap; break;}
        3 {echo "Setting Stand Alone Structure";$installer_User_Structure = [Type_of_User_Structure]::Stand_Alone; break;}
        9 {echo "ByeBye"; Remove-Variable -Name installe* -Force;exit;}
        default {Write-Error "Wrong Input";echo "Please Try Again";Write-Verbose -Message "Restarting ";Get-User_Structure ; break}

    }
    
    Clear-Host 
}

#-------------------------------------------------------------------------------------------------------------------------------------

Write-Verbose -Message "Start -Create enum Type_of_WSman_Structure"
Add-Type -TypeDefinition @"
   public enum Type_of_WSman_Structure
   {
    Star_Single_Contact,
    Star_N_Contact,
    InterConnected,
    Default
   }
"@
#$installer_WSman_Structure=[Type_of_WSman_Structure]::Default
$installer_WSman_Structure_Number_of_Master=0
Write-Verbose -Message "End -Creation enum Type_of_WSman_Structure and variable declared"
function Set-WSMan_Structure_Number_of_Master
{
    $installer_value=0;
    [int]$installer_value=Read-Host "How many Master in the system? If inter-connected please give the number of nodes"
    if($installer_value -gt 1)
    {$installer_WSman_Structure_Number_of_Master=$installer_value}
    else
    {
        Write-Error -Message "Wrong answer try again."
        Set-WSMan_Structure_Number_of_Master
    }
}
function Set-WSMan_Structure 
{
    
    Write-Verbose -Message "Creating the Menu" 
    Write-Host "What type of Instrastructure is it?"
    Write-Host "1  Star Single Contact"
    Write-Host "2  Star N Contacts"
    Write-Host "3  Inter-Connected"
    Write-Host "9  Exit"
    Write-Verbose -Message "Awating for input"

    [int]$installer_value=( Read-Host "What is your option?") 
    switch($installer_value)
    {
        1 {echo "Setting Star Single_Contact Structure";$installer_User_Structure = [Type_of_WSman_Structure]::Star_Single_Contact; break;}
        2 {echo "Setting Star N Contact Structure";$installer_User_Structure = [Type_of_WSman_Structure]::Star_N_Contact; break;}
        3 {echo "Setting Inter-Connected Structure";$installer_User_Structure = [Type_of_WSman_Structure]::InterConnected; break;}
        9 {echo "ByeBye"; Remove-Variable -Name installe* -Force;exit;}
        default {Write-Error "Wrong Input";echo "Please Try Again";Write-Verbose -Message "Restarting ";Get-WSMan_Structure ; break}

    }
    Clear-Host 
    Set-WSMan_Structure_Number_of_Master
   
}

#-------------------------------------------------------------------------------------------------------------------------------------
Write-Verbose -Message "Start -Create enum Type_of_Certificat_Structure"
Add-Type -TypeDefinition @"
   public enum Type_of_Certificat_Structure
   {
    Create_Self_Signed_Per_Node,
    Create_Self_Signed_For_System,
    I_Have_My_Own_Certificate_Per_Node,
    I_Have_My_Own_Certificate_Per_System,
    I_will_do_it_myself,
    Default
   }
"@
#$installer_Certificat_Structure=[Type_of_Certificat_Structure]::Default
function Set-Certificat_Structure_Advance
{
        Write-Verbose -Message "End -Creation enum Certificat_Structure_Advance and variable declared"
        Set-Location ($env:USERPROFILE+"\desktop\")
        $installer_Certificat_Structure
        if($installer_Certificat_Structure -eq [Type_of_Certificat_Structure]::Create_Self_Signed_Per_Node)
        {
            
            $installer_value=Read-Host "Do you want to create a Self signed certficate now?"
            Set-Location $installer_Desktop

            $installer_OSType=(Get-WMIObject win32_operatingsystem).Caption
            if(!($installer_OSType.Contains("2008") -or $installer_OSType.Contains("2003") -or $installer_OSType.Contains("7") ))
            {
                $installer_wshell = New-Object -ComObject Wscript.Shell
                $installer_wshell.Popup("Operation can not be completed on this Operating System",0,"Done",0x0)

            }
            else
            {
                New-Item -ItemType Directory -Path $var -Force
                $installer_Cert = New-SelfSignedCertificate -CertstoreLocation Cert:\LocalMachine\My -DnsName "Wsman-MainCertification"
                Export-Certificate -Cert $installer_Cert -FilePath $installer_Certificat_Structure+"\Wsman-Main.certif"
                Remove-Item -Path ("Cert:\LocalMachine\My\"+($installer_Cert.Thumbprint))
            }
            
        }
        if($installer_Certificat_Structure -eq [Type_of_Certificat_Structure]::I_Have_My_Own_Certificate_Per_Node)
        {
            
            write-Host "Select path of the certificate."
            $value=Get-Folder


        }
        if($installer_Certificat_Structure -eq [Type_of_Certificat_Structure]::I_Have_My_Own_Certificate_Per_System)
        {
        
        }
}
function Set-Certificat_Structure
{
    
    Write-Verbose -Message "Creating the Menu" 
    Write-Host "How is your certificate structure going ot be?"
    Write-Host "1  I will use a single self-signed certificate per slave device.(More advance users)"
    Write-Host "2  I will use a single self-signed certificate that I will use for the whole system."
    Write-Host "3  I have my own Certificate for each device"
    Write-Host "4  I have my own Certificate for the whole System (More advance users)"
    Write-Host "5  I will do it myself.(More advance users)"
    Write-Host "9  Exit"
    Write-Verbose -Message "Awating for input"

    [int]$installer_value=( Read-Host "What is your option?") 

        switch($installer_value)
        {
            1 {echo "Setting single S.S.C per slave device";$installer_Certificat_Structure = [Type_of_Certificat_Structure]::Star_Single_Contact; break;}
            2 {echo "Setting single S.S.C per system";$installer_Certificat_Structure = [Type_of_Certificat_Structure]::Star_N_Contact; break;}
            3 {echo "Setting I have  my own Certificate for each device.";$installer_Certificat_Structure = [Type_of_Certificat_Structure]::InterConnected; break;}
            4 {echo "Setting I  have my own Certificate for the whole System";$installer_Certificat_Structure = [Type_of_Certificat_Structure]::InterConnected; break;}
            5 {echo "Setting I will do it myself.";$installer_Certificat_Structure = [Type_of_Certificat_Structure]::InterConnected; break;}
            9 {echo "ByeBye"; Remove-Variable -Name installe* -Force;exit;}
            default {echo "Wrong Input";echo "Please Try Again";Write-Verbose -Message "Restarting ";Get-Certificat_Structure ; break}

        }
        Write-Output "I am here"
       "installer "+$installer_Certificat_Structure
        Set-Certificat_Structure_Advance
    
    }


Write-Verbose -Message "End -Creation enum Type_of_Certificat_Structure and variable declared"
#-------------------------------------------------------------------------------------------------------------------------------------
Write-Verbose -Message "Creating user proprities"
$installer_Properties_User = @{
    "Name" = 'John_Doe'
    "Group" = 'User'
    "Language" = $Host.CurrentCulture
    "Create" = $false
}
Write-Verbose -Message "Creating users variables  - User and Admin_User"
$installer_User_Landa = New-object -TypeName psobject -Property $installer_Properties_User
$installer_User_Administrator = New-object -TypeName psobject -Property $installer_Properties_User
Write-Verbose -Message "Modifying user Admin for Admin group"
$installer_User_Administrator.Group ="Administrator"
Write-Verbose -Message "Creating Create_Local_DNS_Register"

#-------------------------------------------------------------------------------------------------------------------------------------
$installer_Create_Local_DNS_Register=$false


#-------------------------------------------------------------------------------------------------------------------------------------
Write-Verbose -Message "Creating Create Slave Property and Empty ArrayList"
$installer_Properties_Slave = @{
    "hostname" = 'John Doe'
    "IP" = 'User'
    "Create_SelfSigned"=$false
    "CA_Certificate"=$false
    "Matsers_Names"="Void1,Void2"
    "Matsers_IP"="IP1,IP2"
}
$installer_GenericComputerSlave=New-object -TypeName psobject -Property $installer_Properties_Slave
$installer_Targeted_System_Slave = New-Object System.Collections.ArrayList;

#-------------------------------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------------------------------

Write-Verbose -Message "Creating Create Master Property and Empty ArrayList"
$installer_Properties_Master = @{
    "hostname" = 'John Doe'
    "IP" = 'User'
    "Create_SelfSigned"=$false
    "CA_Certificate"=$false
    "Slaves_Names"="Void1,Void2"
    "Slaves_IP"="IP1,IP2"
}
$installer_GenericComputerMaster=New-object -TypeName psobject -Property $installer_Properties_Master
$installer_System_Master = New-Object System.Collections.ArrayList;

#get-the amount of Client systems
#get-the amount of Server system

Set-User_Structure;
Set-WSMan_Structure; 
Set-Certificat_Structure;

