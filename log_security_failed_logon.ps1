#Set-ExecutionPolicy unrestricted

#Liest die jeweilige Security ID aus und schickt diese dann an eine Mail, verknüpft mit Event Trigger

$Eventlog = „Security“ # (Security, Application, System)
#old $EventID = „4625“
#$EventID ist die ID auf welche Reagiert werden soll
$EventID = „4771“

#Absenderaddresse, vollständig
$From = "from@some.domain"

#Empfängeradresse, vollständig

$To = "to@some.domain"
$CC = "cc@some-domain"
$Subject = „Login Monitoring [BETA 1.1]“
$MailServer = „mail.some.domain“
$LOGPATH = "C:\Skripting\Logs\Audit\"
$LOGTMP1 = "tmp.txt"
$LOGTMP = $LOGPATH + $LOGTMP1
$LOG_NOMAIL = "nomail_login.txt"
$LOG_MAIL = "mail_login.txt"
$LOG1 = $LOGPATH + $LOG_NOMAIL
$LOG2 = $LOGPATH + $LOG_MAIL

# >>>>>>>> Query Eventlog <<<<<<<<
#Schreibt die Event Logs in $LOGTMP
get-winevent -FilterHashtable @{Logname='Security';ID=4771}  -MaxEvents 1 |fl > $LOGTMP

$Kontoname =      Get-Content $LOGTMP | findstr /I kontoname
$Clientadresse =  Get-Content $LOGTMP | findstr /I Clientadresse
$Clientport =     Get-Content $LOGTMP | findstr /I TimeCreated
$Fehlercode =     Get-Content $LOGTMP | findstr /I Fehlercode:
$ErrorMsg = @(get-content "C:\Skripting\error.txt") | findstr "$Fehlercode"


#$Output = "Fehlerhafter Login:" + "`r`n" + $Kontoname + "`r`n" +  $Clientadresse+ "`r`n" + "                            " + $Clientport + "`r`n" + $Fehlercode + "`r`n"

# HTML Output - neu:
$Output = "<b><h1>Fehlerhafter Login: </h1></b>"  +"<br>"+ $Kontoname  + "<br>" + $Clientadresse  + "<br>" + $Clientport  + "<br>"  + "Fehlercode: " + $ErrorMsg

$Body = $Output


# >>>>>>>> Send Mail-Alert <<<<<<<<
 if ($Kontoname -like '*RDS-Broker$*')
 { 
        #Wenn RDS-Broker als user
        echo $Output > $LOG1
        exit
 } 
    else 
 { 
        #Alles andere soll er mailen 
        #Send-MailMessage -From $From -To $To -Subject $Subject -SmtpServer $MailServer -Body $Body
        Send-MailMessage -Cc $CC -From $From -To $To -Subject $Subject -SmtpServer $MailServer -BodyAsHtml "$Body "
        #echo $Output > C:\temp\true_loggin.txt 
        echo $Output > $LOG2
 }
 del $LOGTMP
