##Compresse with 7Zip

if(-not (Test-Path "$env:ProgramFiles\7-Zip\7z.exe")){ throw  "$env:ProgramFiles\7 zip\7z.exe Needed"};
Set-Alias sz "$env:ProgramFiles\7-Zip\7z.exe";
#######################################################
##Vairable


$FilePathToCompresse = "C:\Users\terriens\Desktop\Test";


$backupFile= Get-ChildItem -Recurse $FilePathToCompresse | Where-Object{$_.extension -eq ".txt"}

################### END of VARIABLE##############################

foreach ($file in $backupFile)
{
    $name= $file.Name;
    $directory=$file.DirectoryName;
    $zipfile=$name.replace(".txt", ".7z");
    sz a -t7z "$directory\$zipfile" "$directory\$name";
}