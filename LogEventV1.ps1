$wshell = New-Object -ComObject Wscript.Shell
$FileData=import-csv ($env:LOCALAPPDATA+"\EventGetter\"+"ServerList.csv") -Delimiter ";";
$Computers=$FileData.ServerList
$LogNameOptions=$FileData.LogName
$EntryTypeOptions=$FileData.EntryType
$Option=$null
$Computer=$null
$LogName=$null
$EntryType=$null


Function Get-Folder($void)
{
    Add-Type -AssemblyName System.Windows.Forms
    $FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    [void]$FolderBrowser.ShowDialog()
    return $FolderBrowser.SelectedPath
}

$ExportCode=
{
    
    Write-Host "Exporting"
    $filepath=$path+"\Event-"+$computer+(Get-date -Format yyyy-MM-dd-hh-mm)+".txt"

    if((Test-Path $filepath)-eq $true)
    {
        $res=$wshell.Popup("File Already existe would you like to continue yes to append no overwrite, cancel to choose new path",0,"Export Events",0x3)
        switch($res)
        {
            2{echo Cancel; }
            6{$event>>$filepath}
            7{$event>$filepath}
            default{exit}
        }
        
    }
    else
    {
        $event>$filepath
    }
    
    #>
    if($wshell.Popup("Would you like to export?",0,"Export Events",0x4) -eq 6)
    {
        #yes
        &$ExportCode

    }
}

$EventGetter=
{
$i_i=0;
foreach($Computer in $Computers)
{
     if($Computer -eq "")
     {
        break;
     } 
     Write-Host ("Option "+$i_i+" "+$Computer);
     $i_i++;
}

$i_i=0;
$Option=$null
$Option = (Read-Host "Select what computer you would like to have the logs from:" )-as [int]
while($Option -eq $null)
{
    $i_i++;
    $Option = (Read-Host "Please a correct number for what computer you would like to have the logs from " )-as [int]
    if($i_i -eq 2)
    {
        Write-Host "Please read the manuel before restarting the script. have a nice day."
        Read-Host "Type Enter"
        exit
    }
        
}
$Computer=$Computers[$Option]
$i_i=0;
foreach($LogsName in $LogNameOptions)
{
     if($LogsName -eq "")
     {
        break;
     }   
     Write-Host ("Option "+$i_i+" "+$LogsName);

     $i_i++;
}

$i_i=0;
$Option=$null
$Option = (Read-Host "Select what type of log you would like:" )-as [int]
while($Option -eq $null)
{
    $i_i++;
    $Option = (Read-Host "Please a correct number for what type of log you would like:" )-as [int]
    if($i_i -eq 2)
    {
        Write-Host "Please read the manuel before restarting the script. have a nice day."
        Read-Host "Type Enter"
        exit
    }
        
}
$LogsName=$LogNameOptions[$Option]

foreach($EntryType in $EntryTypeOptions)
{
     if($EntryType -eq "")
     {
        break;
     }   
     Write-Host ("Option "+$i_i+" "+$EntryType);

     $i_i++;
}

$i_i=0;
$Option=$null
$Option = (Read-Host "Select what type of Entry Type you would like:" )-as [int]
while($Option -eq $null)
{
    $i_i++;
    $Option = (Read-Host "Please a correct number for what type of Entry Type you would like:" )-as [int]
    if($i_i -eq 2)
    {
        Write-Host "Please read the manuel before restarting the script. have a nice day."
        Read-Host "Type Enter"
        exit
    }
        
}
$EntryType=$EntryTypeOptions[$Option]
$i_i=0
$Option = (Read-Host "Select how many logs would you like to have:" )-as [int]
while($Option -eq $null)
{
    $i_i++;
    $Option = (Read-Host "Please a correct number for how many logs would you like to have:" )-as [int]
    if($i_i -eq 2)
    {
        Write-Host "Please read the manuel before restarting the script. have a nice day."
        Read-Host "Type Enter"
        exit
    }
        
}
   switch ( $EntryType )
    {
       "Error,Warning" { $event= Get-EventLog -LogName $LogsName -ComputerName $Computer -EntryType Error,Warning -Newest $Option    }
       "Error,Warning,Information" { $event= Get-EventLog -LogName $LogsName -ComputerName $Computer -EntryType Error,Warning,Information -Newest $Option   }
       default { $event= Get-EventLog -LogName $LogsName -ComputerName $Computer -EntryType $EntryTypeOptions -Newest $Option   }
    }


$event

    if($wshell.Popup("Would you like to export?",0,"Export Events",0x4) -eq 6)
    {
        $path=Get-Folder($null)
        $i_i=0
        while($path -eq $null)
        {
            $i_i++;
            Write-Host "Please select a path."
            $path=Get-Folder($null)
            if($i_i -eq 2)
            {
                Write-Host "Please read the manuel before restarting the script. have a nice day."
                Read-Host "Type Enter"
                exit
            }
        }
        #yes
        &$ExportCode


    }
    if($wshell.Popup("Would you like to restart the script?",0,"Is this freedom?",0x4) -eq 6)
    {
        #yes
        &$EventGetter

    }


}
&$EventGetter


