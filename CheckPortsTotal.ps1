function Test-Port()
{
        Param
    (
         [Parameter(Mandatory=$true, Position=0)]
         [string] $hostname,
         [Parameter(Mandatory=$true, Position=1)]
         [int] $port
    )
    
    # This works no matter in which form we get $host - hostname or ip address
    try {
        $ip = [System.Net.Dns]::GetHostAddresses($hostname) | 
            select-object IPAddressToString -expandproperty  IPAddressToString
        if($ip.GetType().Name -eq "Object[]")
        {
            #If we have several ip's for that address, let's take first one
            $ip = $ip[0]
        }
    } catch {
 #       Write-Host "Possibly $hostname is wrong hostname or IP"
        return -1
    }
    $t = New-Object Net.Sockets.TcpClient
    # We use Try\Catch to remove exception info from console if we can't connect
    try
    {
        $t.Connect($ip,$port)
    } catch {}

    if($t.Connected)
    {
        $t.Close()
        $object = [pscustomobject] @{
                        Hostname = $hostname
                        IP = $IP
                        TCPPort = $port
                        GetResponse = $True }
        #Write-Output $object
       return 1
    }
    else
    {
        $object = [pscustomobject] @{
                        Computername = $IP
                        TCPPort = $port
                        GetResponse = $False }
        #Write-Output $object
       return 0

    }
    Write-Host $msg
} 
Function Get-Folder
{
    Add-Type -AssemblyName System.Windows.Forms
    $FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    [void]$FolderBrowser.ShowDialog()
    return $FolderBrowser.SelectedPath
}
$folderpath= Get-Folder
$folderpath+="\PortTest.csv"
$File_CSV= import-csv  -Delimiter "," -Path $folderpath
Get-date  |Out-File ("$env:LOCALAPPDATA\Testres.log")
foreach($hostedit in $File_CSV)
{
    0..65535 | Foreach {
    ($hostedit.hostname+";"+$_+";"+(Test-Port -hostname ($hostedit.hostname) -port ($_))) |Out-File ("$env:LOCALAPPDATA\Testres.log") -Append
    }
}
notepad ("$env:LOCALAPPDATA\Testres.log")