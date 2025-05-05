# Send an smtp email using PowerShell
$SMTPServer = "smtp.yourserver.com"
$SMTPFrom = "you@yourdomain.com"
$SMTPTo = "recipient@domain.com"
$MessageSubject = "Test Email"
$MessageBody = "This is a test email from PowerShell."
$SMTPMessage = New-Object system.net.mail.mailmessage
$SMTPMessage.from = $SMTPFrom
$SMTPMessage.To.add($SMTPTo)
$SMTPMessage.Subject = $MessageSubject
$SMTPMessage.Body = $MessageBody
$SMTPClient = New-Object Net.Mail.SmtpClient($SMTPServer, 587) 
$SMTPClient.EnableSsl = $true
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential("you@yourdomain.com", "password") 
$SMTPClient.Send($SMTPMessage)