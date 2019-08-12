
 
$User = "Domain\ServiceAdministrator"
$PasswordFile = "c:\DataInformation\Password.txt"
$KeyFile = "c:\DataInformation\AES.key"
function New-KeyGenAES
{
    $KeyFile = "c:\DataInformation\AES.key"
    $Key = New-Object Byte[] 16   # You can use 16, 24, or 32 for AES
    [Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($Key)
    $Key | out-file $KeyFile
}
function New-KeyGen
{
    $PasswordFile = "c:\DataInformation\Password.txt"
    $KeyFile = "c:\DataInformation\AES.key"
    $Key = Get-Content $KeyFile
    $Password = "S3pVr_P@ssw0rd!!" | ConvertTo-SecureString -AsPlainText -Force
    $Password | ConvertFrom-SecureString -key $Key | Out-File $PasswordFile
}
$key = Get-Content $KeyFile
$MyCredential = New-Object -TypeName System.Management.Automation.PSCredential `
 -ArgumentList $User, (Get-Content $PasswordFile | ConvertTo-SecureString -Key $key)
 return $MyCredential ;
