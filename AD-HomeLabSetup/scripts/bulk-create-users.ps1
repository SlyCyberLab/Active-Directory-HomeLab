# ======================== CONFIGURATION ======================== #
# Set a default password for all users (can be changed later)
$PASSWORD_FOR_USERS = "1Password"

# File containing names (First Last per line)
$USER_FIRST_LAST_LIST = Get-Content ".\names.txt"

# Organizational Unit where users will be created
$TARGET_OU_NAME = "_USERS"

# ======================== EXECUTION ============================ #

# Convert password to SecureString
$password = ConvertTo-SecureString $PASSWORD_FOR_USERS -AsPlainText -Force

# Get the domain distinguished name string
$domainDN = (Get-ADDomain).DistinguishedName

# Build full OU path
$ouPath = "OU=$TARGET_OU_NAME,$domainDN"

# Check if the target OU exists; create if it does not
if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$TARGET_OU_NAME'")) {
    New-ADOrganizationalUnit -Name $TARGET_OU_NAME -Path $domainDN -ProtectedFromAccidentalDeletion $false
    Write-Host "Created OU: $TARGET_OU_NAME" -ForegroundColor Green
} else {
    Write-Host "OU '$TARGET_OU_NAME' already exists." -ForegroundColor Yellow
}

# Loop through each name and create a user
foreach ($n in $USER_FIRST_LAST_LIST) {
    $first = $n.Split(" ")[0].Trim()
    $last = $n.Split(" ")[1].Trim()
    $username = ("$($first.Substring(0,1))$last").ToLower()

    Write-Host "Creating user: $username" -ForegroundColor Cyan

    New-ADUser -Name $username `
               -GivenName $first `
               -Surname $last `
               -DisplayName "$first $last" `
               -SamAccountName $username `
               -UserPrincipalName "$username@$env:USERDNSDOMAIN" `
               -AccountPassword $password `
               -EmployeeID $username `
               -PasswordNeverExpires $true `
               -Enabled $true `
               -Path $ouPath
}
