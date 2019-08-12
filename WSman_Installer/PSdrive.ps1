# Run these two lines to create your PASSWORD.txt file (run these as the service account)
$credential = Get-Credential
$credential.Password | ConvertFrom-SecureString | Set-Content ($env:LOCALAPPDATA+"\PASSWORD.txt")




# Run these three lines to map your drive (use task scheduler to run as the service account)
$encrypted = Get-Content ($env:LOCALAPPDATA+"\PASSWORD.txt") | ConvertTo-SecureString
$credential = New-Object System.Management.Automation.PsCredential("domain\user", $encrypted)
New-PSDrive -name "K" -PSProvider FileSystem -Root \\FileServer1\FileShare1\DeptFolder1 -Persist -Credential $credential


<# This form was created using POSHGUI.com  a free online gui designer for PowerShell
.NAME
    Untitled
#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '654,428'
$Form.text                       = "Form"
$Form.TopMost                    = $false

$ToolTip1                        = New-Object system.Windows.Forms.ToolTip


