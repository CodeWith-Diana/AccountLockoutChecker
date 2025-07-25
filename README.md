# PROJECT 1 : Account Lockout Checker

Description

This project contains scripts to check and manage user account lockouts.

## 🔐 Windows (PowerShell) Instructions
- Checks if a user account is locked out in Active Directory
- Sends email with Report of locked out accounts
## 🐧 Linux (Bash)
- Uses `faillock` to view failed login attempts and reset lockouts

## Usage
```bash
# PowerShell
.\AccountLockoutChecker.ps1 -Username "jdoe"

# Bash
./AccountLockoutChecker.sh
