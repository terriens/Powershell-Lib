function Header-Generator
{
   [cmdletbinding(
	DefaultParameterSetName = 'HeaderGenerator',
	ConfirmImpact = 'low'
)]
    Param(
        [Parameter(
            Mandatory = $True,
            Position = 0,
            ParameterSetName = '',
            ValueFromPipeline = $True)]
            [string[]]$Servers,                     
        [Parameter(
            Mandatory = $True,
            Position = 1,
            ParameterSetName = '',
            ValueFromPipeline = $False)]
            [string]$Server,
              [Parameter(
            Mandatory = $True,
            Position = 2,
            ParameterSetName = '',
            ValueFromPipeline = $False)]
            [string]$Type    
                           
       ) 
    $header_file_declartion =@();
    $header_file_declartion +="<!DOCTYPE html>"
    $header_file_declartion +="<html>"
    $header_file_declartion +="<head>"
    $header_file_declartion +="<Title>System Report - $($Server)</Title>"
    $header_file_declartion +='<meta charset="UTF-8">'
    $header_file_declartion +='<meta name="viewport" content="width=device-width, initial-scale=1">'
    $header_file_declartion +="<style>"
    $header_file_declartion +="* {"
    $header_file_declartion +="box-sizing: border-box;"
    $header_file_declartion +="}"    
    $header_file_declartion +="/* Style the body */"
    $header_file_declartion +="body {
  font-family: Arial, Helvetica, sans-serif;
  margin: 0;
}"
    $header_file_declartion +="
/* Header/logo Title */
.header {
  padding: 80px;
  text-align: center;
  background: #1abc9c;
  color: white;
}
.alert {
 color: red; 
 }
.critical_update {
 color: red; 
 }
/* Increase the font size of the heading */
.header h1 {
  font-size: 40px;
}
.navbar {
  overflow: hidden;
  background-color: #333;
  position: sticky;
  position: -webkit-sticky;
  top: 0;
}
.navbar a {
  float: left;
  display: block;
  color: white;
  text-align: center;
  padding: 14px 20px;
  text-decoration: none;
}


/* Right-aligned link */
.navbar a.right {
  float: right;
}

/* Change color on hover */
.navbar a:hover {
  background-color: #ddd;
  color: black;
}

/* Active/current link */
.navbar a.active {
  background-color: #666;
  color: white;
}
.navbarInfo {
  overflow: hidden;
  background-color: #330;
  position: sticky;
  position: -webkit-sticky;
  top: 0;
}
.navbarInfo a {
  float: left;
  display: block;
  color: white;
  text-align: center;
  padding: 14px 20px;
  text-decoration: none;
}


/* Right-aligned link */
.navbarInfo a.right {
  float: right;
}

/* Change color on hover */
.navbarInfo a:hover {
  background-color: #ddd;
  color: black;
}

/* Active/current link */
.navbarInfo a.active {
  background-color: #666;
  color: white;
}
/* Column container */
.row {  
  display: -ms-flexbox; /* IE10 */
  display: flex;
  -ms-flex-wrap: wrap; /* IE10 */
  flex-wrap: wrap;
}

/* Create two unequal columns that sits next to each other */
/* Sidebar/left column */
.side {
  -ms-flex: 30%; /* IE10 */
  flex: 30%;
  background-color: #f1f1f1;
  padding: 20px;
}

/* Main column */
.main {   
  -ms-flex: 70%; /* IE10 */
  flex: 70%;
  background-color: white;
  padding: 20px;
}

/* Fake image, just for this example */
.fakeimg {
  background-color: #aaa;
  width: 100%;
  padding: 20px;
}

/* Footer */
.footer {
  padding: 20px;
  text-align: center;
  background: #ddd;
}"
    $header_file_declartion+=' @media screen and (max-width: 700px) {

  .row {   
    flex-direction: column;
  }
}
/* Responsive layout - when the screen is less than 400px wide, make the navigation links stack on top of each other instead of next to each other */
@media screen and (max-width: 400px) {
  .navbar a {
    float: none;
    width: 100%;
  }
}
</style>
</head>'
    $header_file_declartion+@();
    $header_file_declartion="<div class=`"header`">"
    $header_file_declartion+=" <h1> $Computer 
<pre>
_________          __          
\______  \ __ __  |  |    ____  
|     ___// |_| | |  |   /  _ \
|    |    \___  | |  |_ (  <_> )
|____|    /_____| |____/ \____/ 
                            
<pre>
</h1>"
    $header_file_declartion+="<p> IPC Cloud VM system </p>
</div>"
    $header_file_declartion=@();
    $header_file_declartion+="<div class=`"navbar`">"
    
    foreach($comp in $Servers)
    {
    $header_file_declartion+=("<a href= "+$comp+$Type+".html>$comp</a>")
    }
    $header_file_declartion+="<a href=`"iisstart.htm`" class=`"right`">Home</a>"
    $header_file_declartion+="</div>"
    $header_file_declartion+="<div class=`"navbarInfo`">"
    $header_file_declartion+=("<a href= "+$Server+"Info.html>Info</a>")
    $header_file_declartion+=("<a href= "+$Server+"Log.html>Log</a>")
    $header_file_declartion+=("<a href= "+$Server+"HotFix.html>HotFix</a>")
    $header_file_declartion+=("<a href= "+$Server+"Services.html>Services</a>")
    $header_file_declartion+=("<a href= "+$Server+"Processes.html>Processes</a>")
    $header_file_declartion+=("<a href= "+$Server+"Custom.html>Custom</a>")
    $header_file_declartion+="</div>"

    return $header_file_declartion;

}
function Get-SystemInfo
{
    <#
        .SYNOPSIS
        Generates a summary of local or remote computer system configuration

        .DESCRIPTION
        This function generates a summary of a local or remote computer system configuration by querying CIM classes, including:

        Hardware model
        Processor (Model, Frequency, number of physical/logical cores)
        Operating system version
        Uptime
        Network interfaces and IP addresses
        Logical disks (drive letter, file system type, name, remaining and total capacity)
        Memory installed (free / total amount)
        Pagefile configuration
        Powershell version installed

        .NOTES   
        Name       : Get-SystemInfo
        Author     : Thomas Novak
        Version    : 1.0
        DateCreated: 2018-09-24

        .PARAMETER ComputerName
        The computer hostname to query for information

        .EXAMPLE
        Get-SystemInfo

        Description:
        Will query localhost for system information

        .EXAMPLE
        Get-SystemInfo -ComputerName server01,server02

        Description:
        Will query remote computers server01 and server02 for system information

        .EXAMPLE
        'server01','server02' | Get-SystemInfo

        Description:
        Will query remote computers server01 and server02 for system information
    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    [Alias('gsi')]
    param(
        [Parameter(
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Provide the target hostname")]
        [Alias('Hostname', 'cn')]
        [string[]]$ComputerName = $env:COMPUTERNAME
    )
	
    process
    {
        ForEach  ($Computer in $ComputerName)
        {
            try 
            {
                
                $System =Invoke-Command -ComputerName $Computer -ScriptBlock { Get-CimInstance -Class Win32_ComputerSystem }
                if((Invoke-Command -ComputerName $Computer -ScriptBlock { (Get-Command gcim -ErrorAction SilentlyContinue) }) -eq $null)
                {
                    $System =Invoke-Command -ComputerName $Computer -ScriptBlock { Get-WmiObject -Class Win32_ComputerSystem }
                    $OS =Invoke-Command -ComputerName $Computer -ScriptBlock { Get-WmiObject -Class Win32_OperatingSystem }
                    $Processor =Invoke-Command -ComputerName $Computer -ScriptBlock { Get-WmiObject -Class Win32_Processor }
                    $Network =Invoke-Command -ComputerName $Computer -ScriptBlock { Get-WmiObject -Class Win32_NetworkAdapterConfiguration }
                    $Network2 =Invoke-Command -ComputerName $Computer -ScriptBlock { Get-WmiObject -Class Win32_NetworkAdapter }
                    $Disk =Invoke-Command -ComputerName $Computer -ScriptBlock { Get-WmiObject -Class Win32_LogicalDisk }
                    $Pagefile =Invoke-Command -ComputerName $Computer -ScriptBlock { Get-WmiObject -Class Win32_PageFileSetting }

                }
                else
                {
                    $System =Invoke-Command -ComputerName $Computer -ScriptBlock { Get-CimInstance -Class Win32_ComputerSystem }
                    $OS =Invoke-Command -ComputerName $Computer -ScriptBlock { Get-CimInstance -Class Win32_OperatingSystem }
                    $Processor =Invoke-Command -ComputerName $Computer -ScriptBlock { Get-CimInstance -Class Win32_Processor }
                    $Network =Invoke-Command -ComputerName $Computer -ScriptBlock { Get-CimInstance -Class Win32_NetworkAdapterConfiguration }
                    $Network2 =Invoke-Command -ComputerName $Computer -ScriptBlock { Get-CimInstance -Class Win32_NetworkAdapter }
                    $Disk =Invoke-Command -ComputerName $Computer -ScriptBlock { Get-CimInstance -Class Win32_LogicalDisk }
                    $Pagefile =Invoke-Command -ComputerName $Computer -ScriptBlock { Get-CimInstance -Class Win32_PageFileSetting }


                 }
            }
            catch 
            {
                $sysinfo = [ordered]@{
                    Hostname       = $Computer
                    Model          = $null
                    Processor      = $null
                    OS             = $null
                    LastBootUpTime = $null
                    IPAddress      = $null
                    LogicalDisks   = $null
                    Memory         = $null
                    PageFile       = $null
                    PSVersion      = $null
                }
                $obj = New-Object PSObject -Property $sysinfo
                return $obj	
            }
			
            $sysinfo = [ordered]@{
                Hostname       = $System.Name
                Model          = $System.Model
                Processor      = ($Processor | % {"{0} ({1} Core(s), {2} Logical Processor(s))" -f $_.Name, $_.NumberOfCores, $_.NumberOfLogicalProcessors} | Out-String).Trim()
                OS             = "{0} ({1})" -f $OS.Caption, $OS.OSArchitecture
                LastBootUpTime = $OS.LastBootUpTime
                IPAddress      = ($Network | ? IPEnabled -eq $true | % { "{0} - {1}" -f ($Network2 | ? DeviceID -eq $_.Index).NetConnectionID, (($_.IPAddress) -join ", ") } | Out-String).trim()
                LogicalDisks   = ($Disk | ? { $_.DriveType -eq 3 -and $_.Size -notlike $null } | % { "[{0}] {1}\ ({2}) = {3:N2} / {4:N2} GB ({5:N1}% Free)" -f $_.FileSystem, $_.DeviceID, $_.VolumeName, ($_.FreeSpace / 1GB), ($_.Size / 1GB), (($_.FreeSpace / $_.Size) * 100) } | Out-String).Trim()
                Memory         = "{0:N2} / {1:N2} GB Free" -f ($OS.FreePhysicalMemory / 1MB), ($OS.TotalVisibleMemorySize / 1MB)
                PageFile       = if ($Pagefile) { "{0} - {1:N2} GB / {2:N2} GB (Initial/Maximum)" -f $Pagefile.Name, ($Pagefile.InitialSize / 1KB), ($Pagefile.MaximumSize / 1KB) } else { "Pagefile not set" };
                PSVersion      = Invoke-Command -ComputerName $Computer -ScriptBlock { "{0}.{1}" -f $PSVersionTable.PSVersion.Major, $PSVersionTable.PSVersion.Minor }
            }
            $obj = New-Object PSObject -Property $sysinfo
            Write-Output $obj
        }
    }
}
function RapportCreaterInfo
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    [Alias('RCLog')]
    param(
        [Parameter(
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Provide the target hostname")]
        [Alias('Hostname', 'cn')]
        [string[]]$ComputerName = $env:COMPUTERNAME
    )
     process
    {
    $i=0;
    $Inc=1/( $ComputerName.Count)
    Write-Progress -Activity "gathering Information" -PercentComplete 0
     foreach ($Computer in $ComputerName)
     {

        Write-Progress -Activity "gathering Information" -PercentComplete $i
        $i+=$Inc
        $Body_File_Website_NavRow=@()
        $Body_File_Website_NavRow+=Header-Generator -Servers $ComputerName -Server $Computer -Type "Info"

        $Body_File_Website_NavRow=@()
        $Body_File_Website_NavRow+='<div class="row">'
        $Body_File_Website_NavRow+='<div class="side">'
        $Body_File_Website_NavRow+='<h2>About Me</h2>'
        $Body_File_Website_NavRow+= Get-Ciminstance -ClassName win32_operatingsystem -ComputerName $Computer |
                Select @{Name="Operating System";Expression= {$_.Caption}},Version,InstallDate |
                ConvertTo-Html -Fragment -As List;

        $Body_File_Website_NavRow+='<h3> System Info </h3>'
        $Body_File_Website_NavRow+=Get-systeminfo -Computername $Computer | ConvertTo-Html -Fragment -As List
        $Body_File_Website_NavRow+='</div>'
        $Body_File_Website_NavRow+='<div class="main">'
        $Body_File_Website_NavRow+='<h2>EVENT LOG INFORMATION</h2>'


        $event =@()
        $event+=Invoke-Command -ComputerName $Computer -ScriptBlock { Get-EventLog -LogName Security -Newest 30 -EntryType Error,Warning -After (get-date).AddDays(-7) -ErrorAction SilentlyContinue | Select-Object -Property  TimeGenerated,EntryType,EventID,MachineName,Index,Source,Message }
        $event+=Invoke-Command -ComputerName $Computer -ScriptBlock { Get-EventLog -LogName Application -Newest 30 -EntryType Error,Warning -After (get-date).AddDays(-7) -ErrorAction SilentlyContinue | Select-Object -Property TimeGenerated,EntryType,EventID,MachineName,Index,Source,Message }
        [xml]$html  =$event | Select TimeGenerated,EntryType,EventID,MachineName,Index,Source,Message | ConvertTo-Html -Fragment
        for ($i=1;$i -le $html.table.tr.count-1;$i++) {
         if ($html.table.tr[$i].td[1] -eq "Error") {
           $class = $html.CreateAttribute("class")
            $class.value = 'alert'
            $html.table.tr[$i].attributes.append($class) | out-null
          }
        }
        $Body_File_Website_NavRow+= $html.InnerXml
        $Body_File_Website_NavRow+= "</div>"
        $Body_File_Website_NavRow+= "</div>"
        $Body_File_Website_NavRow+='<div class="footer">'
        $Body_File_Website_NavRow+="<h2>$(get-date) Created by Terrien Simon</h2>"
        $Body_File_Website_NavRow+="</div>"
        $Body_File_Website_NavRow+="</body>"
        $Body_File_Website_NavRow+="</html>"

        $Body=$Body_File_Website_Top+$Body_File_Website_NavBar+$Body_File_Website_NavRow
        $fileHTML=$header_file_declartion+$Body
        $convertParams = @{ 
          head = $header_file_declartion
         body = $fragments
        }
                #convertto-html @convertParams | out-file "C:\inetpub\wwwroot\$Computer.htm"
                $fileHTML| out-file "C:\inetpub\wwwroot\$Computer Info.html" -Force
             }
             Write-Progress -Activity "gathering Information" -Completed
  }
}
function RapportCreaterLogger
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    [Alias('RCLog')]
    param(
        [Parameter(
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Provide the target hostname")]
        [Alias('Hostname', 'cn')]
        [string[]]$ComputerName = $env:COMPUTERNAME
    )
     process
    {
    $i=0;
    $Inc=1/( $ComputerName.Count)
    Write-Progress -Activity "gathering Information" -PercentComplete 0
     foreach ($Computer in $ComputerName)
     {

        Write-Progress -Activity "gathering Information" -PercentComplete $i
                $i+=$Inc
        $Body_File_Website_NavRow=@()
        $Body_File_Website_NavRow+=Header-Generator -Servers $ComputerName -Server $Computer -Type "Log"
        $Body_File_Website_NavRow+='<div class="row">'
        $Body_File_Website_NavRow+='<div class="main">'
        $Body_File_Website_NavRow+='<h2>EVENT LOG INFORMATION</h2>'


        $event =@()
        $event+=Invoke-Command -ComputerName $Computer -ScriptBlock { Get-EventLog -LogName Security -Newest 150 -EntryType Error,Warning -ErrorAction SilentlyContinue | Select-Object -Property  TimeGenerated,EntryType,EventID,MachineName,Index,Source,Message }
        $event+=Invoke-Command -ComputerName $Computer -ScriptBlock { Get-EventLog -LogName Application -Newest 150 -EntryType Error,Warning -ErrorAction SilentlyContinue | Select-Object -Property TimeGenerated,EntryType,EventID,MachineName,Index,Source,Message }
        [xml]$html  =$event | Select TimeGenerated,EntryType,EventID,MachineName,Index,Source,Message | ConvertTo-Html -Fragment
        for ($i=1;$i -le $html.table.tr.count-1;$i++) {
         if ($html.table.tr[$i].td[1] -eq "Error") {
           $class = $html.CreateAttribute("class")
            $class.value = 'alert'
            $html.table.tr[$i].attributes.append($class) | out-null
          }
        }
        $Body_File_Website_NavRow+= $html.InnerXml
        $Body_File_Website_NavRow+= "</div>"
        $Body_File_Website_NavRow+= "</div>"
        $Body_File_Website_NavRow+='<div class="footer">'
        $Body_File_Website_NavRow+="<h2>$(get-date) Created by Terrien Simon</h2>"
        $Body_File_Website_NavRow+="</div>"
        $Body_File_Website_NavRow+="</body>"
        $Body_File_Website_NavRow+="</html>"
        $Body=$Body_File_Website_Top+$Body_File_Website_NavBar+$Body_File_Website_NavRow
        $fileHTML=$header_file_declartion+$Body
        $convertParams = @{ head = $header_file_declartion; body = $fragments;};
        #convertto-html @convertParams | out-file "C:\inetpub\wwwroot\$Computer.htm"
        $fileHTML| out-file "C:\inetpub\wwwroot\$Computer Log.html" -Force
     }
     Write-Progress -Activity "gathering Information" -Completed
  }
}
function RapportCreaterServices
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    [Alias('RCLog')]
    param(
        [Parameter(
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Provide the target hostname")]
        [Alias('Hostname', 'cn')]
        [string[]]$ComputerName = $env:COMPUTERNAME
    )
     process
    {
    $i=0;
    $Inc=1/( $ComputerName.Count)
    Write-Progress -Activity "gathering Information" -PercentComplete 0
     foreach ($Computer in $ComputerName)
     {

        Write-Progress -Activity "gathering Information" -PercentComplete $i
        $i+=$Inc
        
        $Body_File_Website_NavRow=@()
        $Body_File_Website_NavRow+=Header-Generator -Servers $ComputerName -Server $Computer -Type "Services"
        $Body_File_Website_NavRow+='<div class="row">'
        $Body_File_Website_NavRow+='<div class="side">'
        $Body_File_Website_NavRow+='<h2>About Me</h2>'
        $Body_File_Website_NavRow+= Get-Ciminstance -ClassName win32_operatingsystem -ComputerName $Computer |
        Select @{Name="Operating System";Expression= {$_.Caption}},Version,InstallDate |
                ConvertTo-Html -Fragment -As List;
        $Body_File_Website_NavRow+='<h3> System Info </h3>'
        $Body_File_Website_NavRow+=Get-systeminfo -Computername $Computer | ConvertTo-Html -Fragment -As List
        $Body_File_Website_NavRow+='</div>'
        $Body_File_Website_NavRow+='<div class="main">'
        $Body_File_Website_NavRow+='<h2>EVENT LOG INFORMATION</h2>'


        $event =@()
        $event+=Invoke-Command -ComputerName $Computer -ScriptBlock { Get-EventLog -LogName Security -Newest 30 -EntryType Error,Warning -ErrorAction SilentlyContinue | Select-Object -Property  TimeGenerated,EntryType,EventID,MachineName,Index,Source,Message }
        $event+=Invoke-Command -ComputerName $Computer -ScriptBlock { Get-EventLog -LogName Application -Newest 30 -EntryType Error,Warning -ErrorAction SilentlyContinue | Select-Object -Property TimeGenerated,EntryType,EventID,MachineName,Index,Source,Message }
        [xml]$html  =$event | Select TimeGenerated,EntryType,EventID,MachineName,Index,Source,Message | ConvertTo-Html -Fragment
        for ($i=1;$i -le $html.table.tr.count-1;$i++) {
         if ($html.table.tr[$i].td[1] -eq "Error") {
           $class = $html.CreateAttribute("class")
            $class.value = 'alert'
            $html.table.tr[$i].attributes.append($class) | out-null
          }
        }
        $Body_File_Website_NavRow+= $html.InnerXml
        $Body_File_Website_NavRow+='<h2>Hot Fix Installed</h2>'
        $hotfix  = Invoke-Command -ComputerName $Computer -ScriptBlock { Get-CimInstance win32_QuickFixEngineering  |select InstalledOn,Description,CSName,HotFixID}
        [xml]$html  =$hotfix | Select InstalledOn,Description,CSName,HotFixID | ConvertTo-Html -Fragment
        $Body_File_Website_NavRow+= $html.InnerXml
        $Body_File_Website_NavRow+= "</div>"
        $Body_File_Website_NavRow+= "</div>"
        $Body_File_Website_NavRow+='<div class="footer">'
        $Body_File_Website_NavRow+="<h2>$(get-date) Created by Terrien Simon</h2>"
        $Body_File_Website_NavRow+="</div>"
        $Body_File_Website_NavRow+="</body>"
        $Body_File_Website_NavRow+="</html>"
        $Body=$Body_File_Website_Top+$Body_File_Website_NavBar+$Body_File_Website_NavRow
        $fileHTML=$header_file_declartion+$Body
        $convertParams = @{ 
          head = $header_file_declartion
         body = $fragments
        }
        #convertto-html @convertParams | out-file "C:\inetpub\wwwroot\$Computer.htm"
        $fileHTML| out-file "C:\inetpub\wwwroot\$Computer Services.html" -Force
     }
     Write-Progress -Activity "gathering Information" -Completed
  }
}
function RapportCreaterProcess
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    [Alias('RCLog')]
    param(
        [Parameter(
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Provide the target hostname")]
        [Alias('Hostname', 'cn')]
        [string[]]$ComputerName = $env:COMPUTERNAME
    )
     process
    {
    $i=0;
    $Inc=1/( $ComputerName.Count)
    Write-Progress -Activity "gathering Information" -PercentComplete 0
     foreach ($Computer in $ComputerName)
     {

        Write-Progress -Activity "gathering Information" -PercentComplete $i
        $i+=$Inc
        
        $Body_File_Website_NavRow=@()
        $Body_File_Website_NavRow+=Header-Generator -Servers $ComputerName -Server $Computer -Type "Process"
        
        $Body_File_Website_NavRow+='<div class="row">'
        $Body_File_Website_NavRow+='<div class="side">'
        $Body_File_Website_NavRow+='<h2>About Me</h2>'
        $Body_File_Website_NavRow+= Get-Ciminstance -ClassName win32_operatingsystem -ComputerName $Computer |
                Select @{Name="Operating System";Expression= {$_.Caption}},Version,InstallDate |
                ConvertTo-Html -Fragment -As List;

        $Body_File_Website_NavRow+='<h3> System Info </h3>'
        $Body_File_Website_NavRow+=Get-systeminfo -Computername $Computer | ConvertTo-Html -Fragment -As List
        $Body_File_Website_NavRow+='</div>'
        $Body_File_Website_NavRow+='<div class="main">'
        $Body_File_Website_NavRow+='<h2>EVENT LOG INFORMATION</h2>'


        $event =@()
        $event+=Invoke-Command -ComputerName $Computer -ScriptBlock { Get-EventLog -LogName Security -Newest 30 -EntryType Error,Warning -ErrorAction SilentlyContinue | Select-Object -Property  TimeGenerated,EntryType,EventID,MachineName,Index,Source,Message }
        $event+=Invoke-Command -ComputerName $Computer -ScriptBlock { Get-EventLog -LogName Application -Newest 30 -EntryType Error,Warning -ErrorAction SilentlyContinue | Select-Object -Property TimeGenerated,EntryType,EventID,MachineName,Index,Source,Message }
        [xml]$html  =$event | Select TimeGenerated,EntryType,EventID,MachineName,Index,Source,Message | ConvertTo-Html -Fragment
        for ($i=1;$i -le $html.table.tr.count-1;$i++) {
         if ($html.table.tr[$i].td[1] -eq "Error") {
           $class = $html.CreateAttribute("class")
            $class.value = 'alert'
            $html.table.tr[$i].attributes.append($class) | out-null
          }
        }
        $Body_File_Website_NavRow+= $html.InnerXml
        $Body_File_Website_NavRow+='<h2>Hot Fix Installed</h2>'
        $hotfix  = Invoke-Command -ComputerName $Computer -ScriptBlock { Get-CimInstance win32_QuickFixEngineering  |select InstalledOn,Description,CSName,HotFixID}
        [xml]$html  =$hotfix | Select InstalledOn,Description,CSName,HotFixID | ConvertTo-Html -Fragment
        $Body_File_Website_NavRow+= $html.InnerXml
        $Body_File_Website_NavRow+= "</div>"
        $Body_File_Website_NavRow+= "</div>"
        $Body_File_Website_NavRow+='<div class="footer">'
        $Body_File_Website_NavRow+="<h2>$(get-date) Created by Terrien Simon</h2>"
        $Body_File_Website_NavRow+="</div>"
        $Body_File_Website_NavRow+="</body>"
        $Body_File_Website_NavRow+="</html>"



        $Body=$Body_File_Website_Top+$Body_File_Website_NavBar+$Body_File_Website_NavRow
        $fileHTML=$header_file_declartion+$Body
        $convertParams = @{ 
          head = $header_file_declartion
         body = $fragments
        }
        #convertto-html @convertParams | out-file "C:\inetpub\wwwroot\$Computer.htm"
        $fileHTML| out-file "C:\inetpub\wwwroot\$Computer Process.html" -Force
     }
     Write-Progress -Activity "gathering Information" -Completed
  }
}
function RapportCreaterHotFix
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    [Alias('RCLog')]
    param(
        [Parameter(
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Provide the target hostname")]
        [Alias('Hostname', 'cn')]
        [string[]]$ComputerName = $env:COMPUTERNAME
    )
     process
    {
    $i=0;
    $Inc=1/( $ComputerName.Count)
    Write-Progress -Activity "gathering Information" -PercentComplete 0
     foreach ($Computer in $ComputerName)
     {

        Write-Progress -Activity "gathering Information" -PercentComplete $i
        $i+=$Inc
        
        $Body_File_Website_NavRow=@()
        $Body_File_Website_NavRow+=Header-Generator -Servers $ComputerName -Server $Computer -Type "HotFix"
        
        $Body_File_Website_NavRow+='<div class="row">'
        $Body_File_Website_NavRow+='<div class="side">'
        $Body_File_Website_NavRow+='<h2>About Me</h2>'
        $Body_File_Website_NavRow+= Get-Ciminstance -ClassName win32_operatingsystem -ComputerName $Computer |
                Select @{Name="Operating System";Expression= {$_.Caption}},Version,InstallDate |
                ConvertTo-Html -Fragment -As List;

        $Body_File_Website_NavRow+='<h3> System Info </h3>'
        $Body_File_Website_NavRow+=Get-systeminfo -Computername $Computer | ConvertTo-Html -Fragment -As List
        $Body_File_Website_NavRow+='</div>'
        $Body_File_Website_NavRow+='<div class="main">'
        $Body_File_Website_NavRow+='<h2>EVENT LOG INFORMATION</h2>'


        $event =@()
        $event+=Invoke-Command -ComputerName $Computer -ScriptBlock { Get-EventLog -LogName Security -Newest 30 -EntryType Error,Warning -ErrorAction SilentlyContinue | Select-Object -Property  TimeGenerated,EntryType,EventID,MachineName,Index,Source,Message }
        $event+=Invoke-Command -ComputerName $Computer -ScriptBlock { Get-EventLog -LogName Application -Newest 30 -EntryType Error,Warning -ErrorAction SilentlyContinue | Select-Object -Property TimeGenerated,EntryType,EventID,MachineName,Index,Source,Message }
        [xml]$html  =$event | Select TimeGenerated,EntryType,EventID,MachineName,Index,Source,Message | ConvertTo-Html -Fragment
        for ($i=1;$i -le $html.table.tr.count-1;$i++) {
         if ($html.table.tr[$i].td[1] -eq "Error") {
           $class = $html.CreateAttribute("class")
            $class.value = 'alert'
            $html.table.tr[$i].attributes.append($class) | out-null
          }
        }
        $Body_File_Website_NavRow+= $html.InnerXml
        $Body_File_Website_NavRow+='<h2>Hot Fix Installed</h2>'
        $hotfix  = Invoke-Command -ComputerName $Computer -ScriptBlock { Get-CimInstance win32_QuickFixEngineering  |select InstalledOn,Description,CSName,HotFixID}
        [xml]$html  =$hotfix | Select InstalledOn,Description,CSName,HotFixID | ConvertTo-Html -Fragment
        $Body_File_Website_NavRow+= $html.InnerXml
        $Body_File_Website_NavRow+= "</div>"
        $Body_File_Website_NavRow+= "</div>"
        $Body_File_Website_NavRow+='<div class="footer">'
        $Body_File_Website_NavRow+="<h2>$(get-date) Created by Terrien Simon</h2>"
        $Body_File_Website_NavRow+="</div>"
        $Body_File_Website_NavRow+="</body>"
        $Body_File_Website_NavRow+="</html>"
        $Body=$Body_File_Website_Top+$Body_File_Website_NavBar+$Body_File_Website_NavRow
        $fileHTML=$header_file_declartion+$Body
        $convertParams = @{ 
          head = $header_file_declartion
         body = $fragments
        }
                #convertto-html @convertParams | out-file "C:\inetpub\wwwroot\$Computer.htm"
                $fileHTML| out-file "C:\inetpub\wwwroot\$Computer HotFix.html" -Force
             }
     Write-Progress -Activity "gathering Information" -Completed
  }
}
function RapportCreaterIndex
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    [Alias('RCLog')]
    param(
        [Parameter(
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Provide the target hostname")]
        [Alias('Hostname', 'cn')]
        [string[]]$ComputerName = $env:COMPUTERNAME
    )
     process
    {
Set-Location "C:\inetpub\wwwroot"

$Index='<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>WebIndex Monitor</title>
    <style> 
            .navbar {
            overflow: hidden;
            background-color: #333;
            position: sticky;
            position: -webkit-sticky;
            top: 0;
            }

                /* Style the navigation bar links */
                .navbar a {
                float: left;
                display: block;
                color: white;
                text-align: center;
                padding: 14px 20px;
                text-decoration: none;
                }


                /* Right-aligned link */
                .navbar a.right {
                float: right;
                }

                /* Change color on hover */
                .navbar a:hover {
                background-color: #ddd;
                color: black;
                }

                /* Active/current link */
                .navbar a.active {
                background-color: #666;
                color: white;
                }
                    /* Header/logo Title */
        .header {
        padding: 80px;
        text-align: center;
        background: #1abc9c;
        color: white;
        }

        /* Increase the font size of the heading */
        .header h1 {
        font-size: 40px;
        }
         body 
         {
            background-image: url("images.jpg");
            background-color:rgba(0, 47, 255, 0.795);
            height: 100%; 
            background-position: center;
            background-repeat: no-repeat;
            background-size: auto;
            position: relative;

         }
    </style>
  </head>

  <body>
        <div class="header">
                <h1>Quick Information</h1>
                <p> Website Created by Simon Terrien </p>
              </div>
              <div class="navbar">
              '
foreach($comp in $ComputerName)
{
$Index+=("<a href= "+$comp+".html>$comp</a>")
}
$Index+='              </div>
  </body>
</html>'
$Index | Out-File "iisstart.htm"
}
}


Set-Location "C:\inetpub\wwwroot"
$ComputerNameV=Get-Content .\ListServeur.txt
#RapportCreaterIndex -ComputerName $ComputerNameV
RapportCreaterInfo -ComputerName $ComputerNameV
