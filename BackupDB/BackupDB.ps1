#Import SQL Module
Import-Module SQLPS

#Create Variables
$Server = "FS-35686\SQLEXPRESS" # Local PC name
$Database = "DNMDEV"            # Database name
$BackupFolder = "C:\Backup\"    #Create folder for backup
$BackupTemp = "C:\BackupTemp\" #Added so you don't get old backup zips included in the current backup
$DT = Get-Date -Format MM-dd-yyyy
$FilePath = "$($BackupTemp)$($Database)_db_$($dt).bak"


#Call SQL Command
Backup-SqlDatabase -ServerInstance $Server -Database $Database -BackupFile $FilePath

#Zip the backup (BAK) that is created
Add-Type -Assembly "System.IO.Compression.FileSystem";
[System.IO.Compression.ZipFile]::CreateFromDirectory($BackupTemp, "$($BackupFolder)$($Database)_db_$($DT).zip");
Remove-Item $FilePath

#Remove Old ZIP backup Files.  Our retention is 1 days
$OldFile=(Get-Date).AddDays(-1).ToString("MM-dd-yyy")
$fileexists = Test-Path -Path $OldFile
If ($fileexists ) {
Remove-Item "$($BackupFolder)$($Database)_db_$($OldFile).zip"
}
