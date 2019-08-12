$wshell = New-Object -ComObject Wscript.Shell
$FileData=import-csv ($env:LOCALAPPDATA+"\EventGetter\"+"ServerList.csv") -Delimiter ";";
$Computers=$FileData.ServerList
$LogNameOptions=$FileData.LogName
$EntryTypeOptions=$FileData.EntryType
$Option=$null
Remove-Variable LogName,Computer,EntryType -ErrorAction SilentlyContinue
[System.Collections.ArrayList]$Computer=@()
[System.Collections.ArrayList]$LogName=@()
[System.Collections.ArrayList]$EntryType=@()
[System.Collections.ArrayList]$event=@()

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
     [System.Collections.ArrayList]$event=@()
    $i_i=0;
    foreach($Comp in $Computers)
    {
         if($Comp -eq "")
         {
            break;
         } 
         Write-Host ("Option "+$i_i+" "+$Comp);
         $i_i++;
    }

    $i_i=0;
    $Option=$null
    $Option = (Read-Host "Select what computer you would like to have the logs from if multiple separate with , " )

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
    $Temp=$Option.Split(",")
    foreach($tempy in $Temp)
    {
        $res=$tempy -as [int]
        if($res -eq $null)
        {
            Write-Host ("unable to convert "+$tempy+" to a Integer")
        }
        else
        {
           
                $Computer.Add($Computers[$res])
        }
    }
    $i_i=0;
    foreach($LogsNames in $LogNameOptions)
    {
         if($LogsNames -eq "")
         {
            break;
         }   
         Write-Host ("Option "+$i_i+" "+$LogsNames);

         $i_i++;
    }

    $i_i=0;
    $Option=$null
    $Option = (Read-Host "Select what type of log you would like" )

    while($Option -eq $null)
    {
        $i_i++;
        $Option = (Read-Host "Please a correct number for what type of log you would like" )-as [int]
        if($i_i -eq 2)
        {
            Write-Host "Please read the manuel before restarting the script. have a nice day."
            Read-Host "Type Enter"
            exit
        }
        
    }
    $Temp=$Option.Split(",")
   # [System.Collections.ArrayList]$LogName=@()
    foreach($tempy in $Temp)
    {
        $res=$tempy -as [int]
        if($res -eq $null)
        {
            Write-Host ("unable to convert "+$tempy+" to a Integer")
        }
        else
        {
            $LogNameOptions[$res]
            $LogName.Add(($LogNameOptions[$res]))
        }
    }
    
    foreach($EntryTypes in $EntryTypeOptions)
    {
         if($EntryTypes -eq "")
         {
            break;
         }   
         Write-Host ("Option "+$i_i+" "+$EntryTypes);

         $i_i++;
    }

    $i_i=0;
    $Option=$null
    $Option = (Read-Host "Select what type of Entry Type you would like" )
    while($Option -eq $null)
    {
        $i_i++;
        $Option = (Read-Host "Please a correct number for what type of Entry Type you would like" )-as [int]
        if($i_i -eq 2)
        {
            Write-Host "Please read the manuel before restarting the script. have a nice day."
            Read-Host "Type Enter"
            exit
        }
        
    }
    $Temp=$Option.Split(",");
   foreach($tempy in $Temp)
   {
        $res=$tempy -as [int]
        if($res -eq $null)
        {
            Write-Host ("unable to convert "+$tempy+" to a Integer")
        }
        else
        {
                $EntryType.Add($EntryTypeOptions[$res])
        }
   }
   $EntryType=$EntryType|sort -Unique
    $i_i=0
    $Option = (Read-Host "Select how many logs would you like to have" )-as [int]
    while($Option -eq $null)
    {
        $i_i++;
        $Option = (Read-Host "Please a correct number for how many logs would you like to have" )-as [int]
        if($i_i -eq 2)
        {
            Write-Host "Please read the manuel before restarting the script. have a nice day."
            Read-Host "Type Enter"
            exit
        }
        
    }
   

    foreach($comp in $Computer)
    {
          $res=Test-Connection -ComputerName $Comp -Count  2

          if($res -ne $null)
          {
            $Comp
            foreach($logs in $LogName)
            {
                $event += Get-EventLog -LogName $logs -ComputerName $Comp -EntryType $EntryType -Newest $Option
            }
          }
          else
          {
            write ("unable to reach "+$Comp)
          ]

     }

    }
    

    $Targetdir = [Environment]::GetFolderPath("Desktop")+"\Event\"+ (Get-Date -Format yyyy-MM-dd)
    if(!(Test-Path -Path $Targetdir))
    {
        New-Item -ItemType directory -Path $Targetdir
    }
    #$DesktopPath = [Environment]::GetFolderPath("Desktop")
    
    if($wshell.Popup("Would you like to export?",0,"Export Events",0x4) -eq 6)
    {
      $event|Format-Table MachineName,EntryType, TimeGenerated, Source, EventID,Message  -auto >( $Targetdir +"\EventExtracxtShort"+(Get-Date -Format yyyy-MM-dd-hh-mm)+".txt")
        ($event|select *) >($Targetdir +"\EventExtracxtLong"+(Get-Date -Format yyyy-MM-dd-hh-mm)+".txt")
        #$event | Select-Object -Property MachineName,EntryType,TimeGenerated,Source,EventID|Export-Csv -Delimiter "," -Force -Path ($DesktopPath +"\EventExtracxt"+(Get-Date -Format yyyy-MM-dd-hh-mm)+".csv") -NoClobber
        $event |Select MachineName,EntryType, TimeGenerated, Source, EventID |Export-Csv -Delimiter ";" -Force -Path ($Targetdir +"\EventExtracxt"+(Get-Date -Format yyyy-MM-dd-hh-mm)+".csv") 
        $event | Select-Object -Property MachineName,EntryType,TimeGenerated,Source,EventID,Message|Export-Clixml -Force -Path ($Targetdir +"\EventExtracxt"+(Get-Date -Format yyyy-MM-dd-hh-mm)+".xml") 
        explorer $Targetdir


    }
    if($wshell.Popup("Would you like to restart the script?",0,"Is this freedom?",0x4) -eq 6)
    {
            #yes
            &$EventGetter

     }
      

}
&$EventGetter


