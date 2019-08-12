
$Computers=@("PARS1PZETCORMD2",
"PARS1PZETCORMD1",
"PARS1PZETCTIMD2",
"PARS1PZETCTIMD1",
"PARS1PZETCORAN2",
"PARS1PZETCORAN1",
"PARS1PZETCTIAN1",
"PARS1PZETCTIAN2",
"PARS1PZETCORSO2",
"PARS1PZETCORSO1",
"PARS1PZETCTISO2",
"PARS1PZETCTISO1",
"PARG1PRECCOR001",
"PARG1PRECCOR002",
"PARG1PRECSAT001",
"PARG1PRECSAT002",
"PARG1PRECCTI001",
"PARG1PRECCTI002")
foreach($Computer in $Computers)
{
    $tempy+=New-SelfSignedCertificate -CertStoreLocation Cert:\LocalMachine\My -DnsName $Computer
}

$tempy=get-childitem -Path "Cert:\LocalMachine\My\*" -Recurse 
foreach($Computer in $Computers)
{
    $temp=$tempy|?{ $_.DnsNameList.Punycode -eq $Computer }
    Export-Certificate -Cert "Cert:\LocalMachine\My\$($temp.Thumbprint)" -FilePath "C:\DataInformation\Cert\$Computer.cert"
    Export-PfxCertificate -Cert "Cert:\LocalMachine\My\$($temp.Thumbprint)" -FilePath "C:\DataInformation\Cert\$Computer.pfx" -Password (("$Computer"|ConvertTo-SecureString -AsPlainText -Force))
}
$tempy |Remove-Item 

 
 invoke-command -ComputerName $Computer -ScriptBlock { CERTUTIL -f -p somePassword -importpfx "somePfx.pfx"} -ArgumentList {}


foreach($Computer in $Computers)
{
    $txt_Password= $Computer
    $txt_PFXPath= "C:\DataInformation\Cert\$Computer.pfx"
    try{
        $sb = {
            Param($txt_Password,$txt_PFXPath,$txt_PasswordRoot,$txt_PFXPathRoot)
            CertUtil -importPFX -p $txt_Password $txt_PFXPath
            certutil -enterprise -f -v -AddStore "Root" $txt_PFXPathRoot -p $txt_PasswordRoot
        }	
        Invoke-Command -ComputerName $computer -ScriptBlock $sb -ErrorAction Continue -ArgumentList $txt_Password, $txt_PFXPath
    }
    catch{
        $outputBox.Lines += "certutil failed to import certificate: $_"
    }
}



