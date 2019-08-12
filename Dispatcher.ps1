$computers= Get-Content C:\DataInformation\server.txt

foreach ($computer in $computers)
{
    Copy-Item "C:\DataInformation\*" -Destination "\\$computer\c$\DataInformation" -Recurse -Verbose 
}
$computers="SRVAD01"

foreach ($computer in $computers)
{
    Copy-Item "\\$computer\c$\DataInformation\IIS\*.html" -Destination "C:\inetpub\wwwroot\Data\"  -Recurse -Verbose 
}