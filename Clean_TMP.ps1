# Author: René Albarus - https://www.tech-faq.net
# Date: 2019/04/16
#
# Description:
# This script deletes files that are a certain number of days old. The file extensions, the age, as well as the storage location are definable. 
# The deletion contains all subfolders. All operations will be written to a log file, stored in the source folder.
# !!! use at your own risk !!!
#
# Here you can define the source folder, the age of the files (in days) and the file extensions
$Source = "C:\"		# Important: Ends with "\"
$Days = 30					# Number of days from which files are deleted
$ext = "*.tmp"		# Array - add more extensions with  ,".xyz" 
$log = "$Source$(get-date -format yymmddHHmmss).txt"
$DateBeforeXDays = (Get-Date).AddDays(-$Days)
 
# Start Script
start-transcript $log
write-host "--------------------------------------------------------------------------------------"
write-host "Deletetion of all files ($ext) in folder $Source which are older than $Days days."
write-host "--------------------------------------------------------------------------------------"
get-childitem $Source\* -include $ext -recurse | where {$_.lastwritetime -lt $DateBeforeXDays -and -not $_.psiscontainer} |% {remove-item $_.fullname -force -verbose}
stop-transcript
