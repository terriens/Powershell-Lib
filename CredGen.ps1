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
    $Password = "3tral1P@ss2CLOUD" | ConvertTo-SecureString -AsPlainText -Force
    $Password | ConvertFrom-SecureString -key $Key | Out-File $PasswordFile
}
$User = "CLOUD\Administrator"
$PasswordFile = "c:\DataInformation\Password.txt"
$KeyFile = "c:\DataInformation\AES.key"
$key = Get-Content $KeyFile
$MyCredential = New-Object -TypeName System.Management.Automation.PSCredential `
 -ArgumentList $User, (Get-Content $PasswordFile | ConvertTo-SecureString -Key $key)
 return $MyCredential ;