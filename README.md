# Account Lockout Checker

This project contains scripts to check and manage user account lockouts.

## 🔐 Windows (PowerShell)
- Checks if a user account is locked out in Active Directory
- Shows last failed login and lockout status

## 🐧 Linux (Bash)
- Uses `faillock` to view failed login attempts and reset lockouts

## Usage
```bash
# PowerShell
.\AccountLockoutChecker.ps1 -Username "jdoe"

# Bash
./AccountLockoutChecker.sh
