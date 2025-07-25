# AccountLockoutNotifier.ps1
# Author: [Your Name]
# Description: Checks for locked-out users in Active Directory and sends a report via email.
#THIS IS A TEMPLATE FOR EDUCATIONAL USE ONLY

# === Load Mail Module ===
Import-Module "C:\Scripts\SendEmail\MailModule.psm1"

# === Email Credentials ===
$MailAccount = Import-Clixml -Path "C:\Scripts\SendEmail\outlook.xml"
$MailSMTPServer = "smtp-mail.outlook.com"
$MailPort = 587
$MailFrom = $MailAccount.UserName
$MailTo = "your-email@example.com"  # <-- change to your real email

# === Logging Setup ===
$LogPath = "C:\Users\YourUsername\Documents\AccountLockoutLogs"
if (!(Test-Path $LogPath)) { New-Item -Path $LogPath -ItemType Directory | Out-Null }
$LogFile = "Lockouts_$(Get-Date -Format 'yyyy-MM-dd_HH-mm').csv"

# === Query Locked-Out Users ===
$LockedOutUsers = Search-ADAccount -LockedOut -Server "yourdomain.local"  # <-- replace with your DC or domain
$Export = @()

foreach ($user in $LockedOutUsers) {
    $ADUser = Get-ADUser -Identity $user.SamAccountName -Server "yourdomain.local" -Properties *

    $Export += [PSCustomObject]@{
        Name                   = "$($ADUser.GivenName) $($ADUser.Surname)"
        Username               = $ADUser.SamAccountName
        LockoutTime            = [datetime]::FromFileTime($ADUser.lockoutTime)
        LastBadPasswordAttempt = $ADUser.LastBadPasswordAttempt
    }
}

# === Export to CSV ===
if ($Export.Count -gt 0) {
    $Export | Export-Csv -Path "$LogPath\$LogFile" -NoTypeInformation
}

# === Send Email ===
if (Test-Path -Path "$LogPath\$LogFile") {
    $Subject = "Account Lockouts Report"
    $Body = "Attached is the latest report of locked-out user accounts."
    $Attachment = "$LogPath\$LogFile"

    Send-MailKitMessage -From $MailFrom -To $MailTo -SMTPServer $MailSMTPServer -Port $MailPort -Credential $MailAccount -Subject $Subject -Body $Body -Attachments $Attachment
}
