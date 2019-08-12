#Creating the SelfSigned Certificate-> MUST MATCH THE NAME OF THE COMPUTER
$WsmanConfigServer_ServerName=$env:COMPUTERNAME;
$WsmanConfigServer_Cert=New-SelfSignedCertficate  -certlocation




	
Disable-NetFirewallRule -DisplayName "Windows Remote Management (HTTP-In)"