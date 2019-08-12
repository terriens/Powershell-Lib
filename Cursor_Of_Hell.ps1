
Add-Type -AssemblyName System.Windows.Forms
while ($true)
{
    $Key = New-Object Byte[] 24   # You can use 16, 24, or 32 for AES
    [Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($Key)
  $Pos = [System.Windows.Forms.Cursor]::Position
  for($i_i =0 ; $i_i -lt 24 ; $i_i = $i_i+3)
  {
      $x = ($pos.X % 500) + $Key[$i_i]
      $y = ($pos.Y % 500) +$Key[$i_i+1]
      Start-Sleep -Milliseconds $Key[$i_i+2]
      [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)
  }
  
  
}