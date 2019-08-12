$Computers=@("TERRIENS-E7450",”TERRIENS-E7450”);
$Targetdir = ("c:\logfiles\"+ (get-date -Format yyyy-MM-dd).ToString()+"\")
if(!(Test-Path -Path $Targetdir))
{
    New-Item -ItemType directory -Path $Targetdir
}

Function New_Server_DC_Core
{
    param($ComputerName)
    $New_Server_DC_CoreObject= New-Object psobject
    $New_Server_DC_CoreObject | Add-Member -Type NoteProperty -Name ComputerName -Value $ComputerName
    $New_Server_DC_CoreObject | Add-Member -Type NoteProperty -Name DatabaseSize -Value ""
    $New_Server_DC_CoreObject | Add-Member -Type NoteProperty -Name DatabaseLastModif -Value ""
    $New_Server_DC_CoreObject | Add-Member -Type NoteProperty -Name CyberServices -Value ""
    $New_Server_DC_CoreObject | Add-Member -Type NoteProperty -Name LastEvent -Value 0
    $New_Server_DC_CoreObject | Add-Member -Type NoteProperty -Name LastEventSystem -Value 0
    $New_Server_DC_CoreObject | Add-Member -Type NoteProperty -Name LastEventApplication -Value 0
    $New_Server_DC_CoreObject | Add-Member -Type NoteProperty -Name CPUUsage -Value ""
    $New_Server_DC_CoreObject | Add-Member -Type NoteProperty -Name RamUsage -Value ""
    $New_Server_DC_CoreObject | Add-Member -Type NoteProperty -Name RamPercentage -Value ""
    $New_Server_DC_CoreObject | Add-Member -Type NoteProperty -Name DiskC -Value ""
    $New_Server_DC_CoreObject | Add-Member -Type NoteProperty -Name DiskCP -Value ""
    $New_Server_DC_CoreObject | Add-Member -Type NoteProperty -Name DiskD -Value ""
    $New_Server_DC_CoreObject | Add-Member -Type NoteProperty -Name DiskDP -Value ""
    $New_Server_DC_CoreObject | Add-Member -Type NoteProperty -Name DiskE -Value ""
    $New_Server_DC_CoreObject | Add-Member -Type NoteProperty -Name DiskEP -Value ""
    $New_Server_DC_CoreObject | Add-Member -Type NoteProperty -Name DiskF -Value ""
    $New_Server_DC_CoreObject | Add-Member -Type NoteProperty -Name DiskFP -Value ""
    $New_Server_DC_CoreObject | Add-Member -Type NoteProperty -Name DiskG -Value ""
    $New_Server_DC_CoreObject | Add-Member -Type NoteProperty -Name DiskGP -Value ""
    return $New_Server_DC_CoreObject 

}
Function New_Server_DC_ServiceObject
{
    param($ComputerName)
    $New_Server_DC_ServiceObject= New-Object psobject
    $New_Server_DC_ServiceObject | Add-Member -Type NoteProperty -Name ComputerName -Value $ComputerName
    $New_Server_DC_ServiceObject | Add-Member -Type NoteProperty -Name ServiceName -Value ""
    $New_Server_DC_ServiceObject | Add-Member -Type NoteProperty -Name Status -Value ""
    $New_Server_DC_ServiceObject | Add-Member -Type NoteProperty -Name StartStatus -Value ""
    return $New_Server_DC_ServiceObject 

}
Remove-Variable -Name Service
Set-Variable -Name Targets -Description AvalableComputer -Value @()
Set-Variable -Name TargetsComputerFilled -Description AvalableComputerwithDataFilled -Value @()
Set-Variable -Name Service -Description AllCyberService -Value @()


ForEach ($Comp in $Computers) 
{
    If (Test-Connection -ComputerName $Comp   -EA SilentlyContinue -Quiet -Count 1) {       
        $Targets += $Comp
    }
    else
    {
        Write-Host "Not Contact from "+$Comp
    }
}
$Targetdir = ("c:\logfiles\"+ (Get-Date -Format yyyy-MM-dd))
if(!(Test-Path -Path $Targetdir))
{
    New-Item -ItemType directory -Path $Targetdir
}
$cred=Get-Credential -Message "Taper le Mot de passe svp" -UserName "terriens"
$EventLog=@("System","Application")   #consolidated error log

$status=0
$Date_Of_Yesterday =Get-Date((Get-Date).AddDays(-1))

for($i_i=0; $i_i -le ($Targets.Length -1);$i_i ++)
{
    $SessionOngoing=Get-PSSession;
    $Computer=New_Server_DC_Core($Targets[$i_i]);
    $ServicesOnComputer=New_Server_DC_Core
    if($SessionOngoing.Count -match 15)
    {
        foreach($Ids in $SessionOngoing)
        {
            Remove-PSSession -Id $Ids.Id
        }
    }
    #Write-Host Processing $comp 
    $status++;    
    $Session=New-PSSession -ComputerName $Computer.ComputerName -Credential $cred -EA SilentlyContinue
    if(!($Session -eq $null))
    {
         echo $Computer.ComputerName
         $serviceTemps=(Invoke-Command -ScriptBlock {(Get-CimInstance -ClassName Win32_Service | Where-Object Displayname -Match "Winrm*" | select Displayname, startmode, started )} -Session $Session)
         foreach($serviceTemps_Each in $serviceTemps)
         {
            $ServerService= New_Server_DC_ServiceObject($Computer.ComputerName)
            $ServerService.ServiceName=$serviceTemps_Each.Displayname
            $ServerService.StartStatus=$serviceTemps_Each.startmode
            $ServerService.Status=$serviceTemps_Each.started
            $service+=$ServerService
            
         }
         if(!(Invoke-Command -ScriptBlock {(Get-CimInstance -ClassName Win32_Service | Where-Object Displayname -Match "Cyber*" |Where-Object startmode -Match "auto"|Where-Object started -Match "False"| FT Displayname, startmode, started -AutoSize)} -Session $Session))
         {
            echo $true
            $Computer.CyberServices="True"
         }
         else
         {
            echo $false
            $Computer.CyberServices="False"
         }
         $Computer.CPUUsage=Invoke-Command -ScriptBlock {(((Get-WmiObject -class win32_processor -EA SilentlyContinue | Measure-Object -property LoadPercentage -Average | Select Average | % {$_.Average / 100}).ToString("P")))} -Session $Session
         $mem = Invoke-Command -ScriptBlock {(Get-WmiObject win32_OperatingSystem  -EA SilentlyContinue )} -Session $Session
         $Computer.RamUsage=[math]::Round($mem.FreePhysicalMemory/1Mb,3)
         $Computer.RamPercentage= ((($mem.TotalVisibleMemorySize - $mem.FreePhysicalMemory) / $mem.TotalVisibleMemorySize).ToString("P"))
         $disks =Invoke-Command -ScriptBlock { Get-WmiObject -class Win32_LogicalDisk -filter "DriveType=3" -EA SilentlyContinue ;} -Session $Session
         
         foreach($disk in $disks)
         {
           switch ($disk.DeviceID) 
           {
               "C:" {$Computer.DiskC=[math]::Round($disk.FreeSpace/1Gb,2); $Computer.DiskCP=(($disk.FreeSpace/$disk.Size)).ToString("P");}
               "D:" {$Computer.DiskD=[math]::Round($disk.FreeSpace/1Gb,2); $Computer.DiskDP=(($disk.FreeSpace/$disk.Size)).ToString("P");}
               "E:" {$Computer.DiskE=[math]::Round($disk.FreeSpace/1Gb,2); $Computer.DiskEP=(($disk.FreeSpace/$disk.Size)).ToString("P");}
               "F:" {$Computer.DiskF=[math]::Round($disk.FreeSpace/1Gb,2); $Computer.DiskFP=(($disk.FreeSpace/$disk.Size)).ToString("P");}
               "G:" {$Computer.DiskF=[math]::Round($disk.FreeSpace/1Gb,2); $Computer.DiskGP=(($disk.FreeSpace/$disk.Size)).ToString("P");}
               "*" {echo " ... Error more disk than I can handle ... "; break;}
               
            }
            

         }

         switch ($Computer.ComputerName) 
           {
             
               "PARS1PZETCORMD1" 
               {
                    $Computer.DatabaseSize=[math]::Round((Invoke-Command -ScriptBlock {(Get-ChildItem ("E:\Backup Sql Md\*"+(Get-Date -Format yyyy-MM-dd )+"*.sql") -File).Length/1000000kb} -Session $Session),2)
               }
               "PARS1PZETCORAN2" 
               {
                    $Computer.DatabaseSize=[math]::Round((Invoke-Command -ScriptBlock {(Get-ChildItem ("E:\Backup Sql Antin\*"+(Get-Date(Get-Date).AddDays(-1) -Format yyyy-MM-dd )+"*.sql") -File).Length/1000000kb} -Session $Session),2)
               }
               "PARS1PZETCORSO2" 
               {
                    $Computer.DatabaseSize=[math]::Round((Invoke-Command -ScriptBlock {(Get-ChildItem ("E:\Backup Sql\*"+(Get-Date(Get-Date).AddDays(-1) -Format yyyy-MM-dd )+"*.sql") -File).Length/1000000kb} -Session $Session),2)
               }
               "PARG1PRECCOR002" 
               {
                    $Computer.DatabaseSize=[math]::Round((Invoke-Command -ScriptBlock {(Get-ChildItem ("F:\BackupSqlCISCO\*"+(Get-Date(Get-Date).AddDays(-1) -Format yyyy-MM-dd )+"*.sql") -File).Length/1000000kb} -Session $Session),3)
               }               
            }
             
           switch -wildcard ($Computer.ComputerName) 
           {
             
               "*MD*"
               {
                    echo ($Computer.ComputerName + " MD")
                    $Computer.DatabaseLastModif =(Invoke-Command -ScriptBlock {(Get-ChildItem ("D:\LogFiles\databaseinte*"+(Get-Date -format yyyy-MM-dd)+"*")).LastWriteTime} -Session $Session).toString();
               }
               "*AN*"
               {
                    echo ($Computer.ComputerName + " AN")
                     $Computer.DatabaseLastModif =(Invoke-Command -ScriptBlock {(Get-ChildItem ("D:\LogFiles\databaseinte*"+(Get-Date -format yyyy-MM-dd)+"*")).LastWriteTime} -Session $Session).toString();
               }
              "*SO*"
               {
                    echo ($Computer.ComputerName + "SO")
                     $Computer.DatabaseLastModif =(Invoke-Command -ScriptBlock {(Get-ChildItem ("D:\LogFiles\databaseinte*"+(Get-Date -format yyyy-MM-dd)+"*")).LastWriteTime} -Session $Session).toString();
               }
               "*00*"
               {
                    echo ($Computer.ComputerName + "00")
                     $Computer.DatabaseLastModif =(Invoke-Command -ScriptBlock {(Get-ChildItem ("D:\LogFiles\databaseinte*"+(Get-Date -format yyyy-MM-dd)+"*")).LastWriteTime} -Session $Session).toString();
               }               
            }
            if($Computer.DatabaseLastModif -eq "")
            {
                $Computer.DatabaseLastModif="Nothing Found"
            }

         #Write-Host End-Processing $comp  
         #$Services+= (Get-Service -ComputerName $Comp |Select-Object MachineName,DisplayName,StartType,Status|Where-Object Displayname -Match "Cyber*" )
         Write-Host Processing $Computer.ComputerName Log
         <#
           $Computer.LastEvent = (Invoke-Command -ScriptBlock {get-eventlog -log System -Newest 1} -Session $Session).TimeGenerated
           $Computer.LastEventApplication= (Invoke-Command -ScriptBlock {get-eventlog -log Application -After (Get-Date((Get-Date).AddDays(-1)))  -EntryType Error} -Session $Session)
           if($Computer.LastEventApplication -eq $null)
           {
                $Computer.LastEventApplication=0
           }
           else
           {
                $Computer.LastEventApplication=$Computer.LastEventApplication.Length
           }
           $Computer.LastEventSystem = (Invoke-Command -ScriptBlock {get-eventlog -log System -After (Get-Date((Get-Date).AddDays(-1)))  -EntryType Error} -Session $Session)
           if($Computer.LastEventApplication -eq $null)
           {
                $Computer.LastEventSystem=0
           }
           else
           {
                $Computer.LastEventSystem=$Computer.LastEventSystem.Length
           }

           #>
           
    }
    Write-Progress -Activity "Gathering Information For Core System" -PercentComplete ((100*$status)/($Targets.count))
    $TargetsComputerFilled+= $Computer;
        
}
$TargetsComputerFilled|Export-Csv -Path ($Targetdir+"RapportCsv.csv") -Delimiter ";"
$service|Export-Csv -Path ($Targetdir+"RapportService.csv") -Delimiter ";"
&($Targetdir+"\RapportCsv.csv")
&($Targetdir+"\RapportService.csv ")

