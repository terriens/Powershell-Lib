#Requires -Version 5.0

Class ClassSystemWSman
{
    [String]$Name = "ServerName";
    [String]$IP = "192.168.1.10";
    [boolean]$LocalDNS = $false;
    [String[]]$IsMaster ;
    [String[]]$IsSlave ;
    [boolean]$http = $false;
    [boolean]$https = $true;
    [boolean]$CIM_Service_to_Activate = $true;
    [boolean]$SelfSigned_Certificate = $true;
    [String]$CertificationName = $null;
    [String]$ThumbPrint = $null;
    [String]$BeginningDate = ((Get-Date -Format "yyyy-MM-dd"));
    [String]$EndDate = ((Get-Date((Get-Date).AddYears(2)) -Format "yyyy-MM-dd"));
    [String]$LocalUserAdmin = "Null";
    [SecureString]$SecureString = (ConvertTo-SecureString -String "P@ssw0rd" -AsPlainText -Force );
    [String]$Policy = (Get-ExecutionPolicy).ToString();
}
Class ClassSystemWSmanArray
{
    [ClassSystemWSman[]]$SystemList=@();
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
    Name of the script module.
 
.PARAMETER Path
    Parent path of the location to create the script module in. This location must already exist.
 
.PARAMETER Author
    Specifies the module author.
 
.PARAMETER CompanyName
    Identifies the company or vendor who created the module.
 
.PARAMETER Description
    Describes the contents of the module.
 
.PARAMETER PowerShellVersion
    Specifies the minimum version of Windows PowerShell that will work with this module. For example,
    you can enter 3.0, 4.0, or 5.0 as the value of this parameter.
 
.EXAMPLE
     New-MrScriptModule -Name MyModuleName -Path "$env:ProgramFiles\WindowsPowerShell\Modules" -Author 'Mike F Robbins' -CompanyName mikefrobbins.com -Description 'Brief description of my PowerShell module' -PowerShellVersion 3.0
 
.INPUTS
    None
 
.OUTPUTS
    None
 
.NOTES
    Author:  Mike F Robbins
    Website: http://mikefrobbins.com
    Twitter: @mikefrobbins
#>
 
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Name,
             
 
        [Parameter(Mandatory)]
        [string]$IP
 
     
    )
    $temp=new-object -type ClassSystemWSman;
    $temp.IP =$IP;
    $temp.Name =$Name;
    return $temp;
}
 function New-SystemWSmanBasicArrayManuel
  {
    <#
.SYNOPSIS
    Creates a new PowerShell script module in the specified location.
 
.DESCRIPTION
    New-MrScriptModule is an advanced function that creates a new PowerShell script module in the
    specified location including creating the module folder and both the PSM1 script module file
    and PSD1 module manifest.
 
.PARAMETER Name
    Name of the script module.
 
.PARAMETER Path
    Parent path of the location to create the script module in. This location must already exist.
 
.PARAMETER Author
    Specifies the module author.
 
.PARAMETER CompanyName
    Identifies the company or vendor who created the module.
 
.PARAMETER Description
    Describes the contents of the module.
 
.PARAMETER PowerShellVersion
    Specifies the minimum version of Windows PowerShell that will work with this module. For example,
    you can enter 3.0, 4.0, or 5.0 as the value of this parameter.
 
.EXAMPLE
     New-MrScriptModule -Name MyModuleName -Path "$env:ProgramFiles\WindowsPowerShell\Modules" -Author 'Mike F Robbins' -CompanyName mikefrobbins.com -Description 'Brief description of my PowerShell module' -PowerShellVersion 3.0
 
.INPUTS
    None
 
.OUTPUTS
    None
 
.NOTES
    Author:  Mike F Robbins
    Website: http://mikefrobbins.com
    Twitter: @mikefrobbins
#>

    [CmdletBinding()]
    param (
    [Parameter(Mandatory)]
    [ClassSystemWSman[]]$a_SystemWSmanArray
    )
    do{
    [int]$i_Number=Read-Host -Prompt "How many system total in the system?" ;
    }while($i_Number -gt $installer_MinumSystem);
    for($i_i =0 ; $i_i -lt $i_Number; $i_i ++)
    {
        Write-Host ("System N "+$i_i.ToString())
        [string]$s_Name=Read-Host -Prompt "Please enter the name of the system: " ;
        [string]$s_IP=Read-Host -Prompt "Please enter the IP of the system: " ;
        $t_temp=New-SystemWSmanBasic -Name $s_Name -IP $s_IP;
        $a_SystemWSmanArray.Add($t_temp);

    }
    return $a_SystemWSmanArray;
}
   