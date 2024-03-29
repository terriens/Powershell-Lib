﻿
<#
.Synopsis
Tests the connectivity between two computers on a TCP Port

.Description
The Telnet command tests the connectivity between two computers on a TCP Port. By running this command, you can determine if specific service is running on Server.

.Parameter <ComputerName>
This is a required parameter where you need to specify a computer name which can be localhost or a remote computer

.Parameter <Port>
This is a required parameter where you need to specify a TCP port you want to test connection on.

.Parameter <Timeout>
This is an optional parameter where you can specify the timeout in milli-seconds. Default timeout is 10000ms (10 seconds)

.Example
Telnet -ComputerName DC1 -Port 3389
This command reports if DC1 can be connected on port 3389 which is default port for Remote Desktop Protocol (RDP). By simply running this command, you can check if Remote Desktop is enabled on computer DC1.

.Example
Telnet WebServer 80
This command tells you if WebServer is reachable on Port 80 which is default port for HTTP.

.Example
Get-Content C:\Computers.txt | Telnet -Port 80
This command will take all the computernames from a text file and pipe each computername to Telnet Cmdlet to report if all the computers are accessible on Port 80.
#>
Function Telnet{

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [Alias ('HostName','cn','Host','Computer')]
        [String]$ComputerName='localhost',
        [Parameter(Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)]
        [int32]$Port,
         [int32] $Timeout = 10000
    )

    Begin {}

    Process {
    foreach($Computer in $ComputerName) {
    Try {
          $tcp = New-Object System.Net.Sockets.TcpClient
          $connection = $tcp.BeginConnect($Computer, $Port, $null, $null)
          $connection.AsyncWaitHandle.WaitOne($timeout,$false)  | Out-Null 
          if($tcp.Connected -eq $true) {
          Write-Output 1
      }
      else {
        Write-Output 0
      }
    }
    
    Catch {
            Write-Output -1
          }

       }
    
    }
    End {}
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

$filepathcsv=Get-FileDialog
$csv_port_to_test = Import-Csv -Delimiter "," -Path $filepathcsv
$FileRes=@()
foreach($hostname in $csv_port_to_test)
{
    if($hostname.HTTPS -eq "true")
    {
        $Res=Telnet -ComputerName $hostname.Hostname -Port 443 -Timeout 300
        $hostname.HTTPSRes=$Res
        $FileRes+=$Res
        $Res
    }
    if($hostname.Mysql -eq "true")
    {
        $Res=Telnet -ComputerName $hostname.Hostname -Port 3306 -Timeout 300
        $hostname.MysqlRes=$Res
        $FileRes+=$Res
        $Res

    }
    if($hostname.RDP -eq "true")
    {
        $Res=Telnet -ComputerName $hostname.Hostname -Port 3389 -Timeout 300
        $hostname.RDPRes=$Res
        $FileRes+=$Res
        $Res
    }
    
}
$csv_port_to_test|Export-Csv -Path ($filepathcsv+"Res.csv") -Delimiter ";"

 $FileRes

