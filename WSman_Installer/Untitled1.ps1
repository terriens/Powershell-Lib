
function New-installer_ClassSystemWSman
{
    $installer_ClassSystemWSman =New-Object -TypeName psobject
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name Name -value "ServerName"
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name IP -Value "192.168.1.10"
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name LocalDNS -Value $false
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name IsMaster -Value @("localhost","ServerName")
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name IsSlave -Value @("localhost","ServerName")
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name http -Value $false
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name https -Value $true
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name SelfSigned_Certificate -Value $true
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name CertificationName -Value $null
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name ThumbPrint -Value $null
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name BeginningDate -Value ((Get-Date -Format "yyyy-MM-dd"))
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name EndDate -Value ((Get-Date((Get-Date).AddYears(2)) -Format "yyyy-MM-dd"))
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name LocalUserAdmin -Value "Null"
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name SecureString -Value (ConvertTo-SecureString -String "P@ssw0rd" -AsPlainText -Force )
    $installer_ClassSystemWSman |Add-Member -Type NoteProperty -Name Policy -Value (Get-ExecutionPolicy).ToString()
    return $installer_ClassSystemWSman 
}
function New-installer_ClassSystemWSmanArray
{
    return [System.collections.arraylist]$installer_ServerList = @((New-installer_ClassSystemWSman),(New-installer_ClassSystemWSman),(New-installer_ClassSystemWSman))
}
Remove-Variable -Name installe* -Force
Write-EventLog -LogName Application -Source InstallerWsman -EntryType Information -Message ("Pre-Install WSman Launched") 
Write-Host 


#ServerName01
