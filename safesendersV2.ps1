# This script is usefull for adding individual users to a targets SafeSenders (TrustedUsersAndDomains)

Connect-ExchangeOnline

$target
$trustedSender

#Validates that the mailbox exists and loops uptil a valid on is entered
while($true){
    $target = read-host "Type the target users email address"

    try{
        Write-Host "Validating target mailbox"
        Get-Mailbox $target -ErrorAction Stop
        Write-Host "$target has been validated" -ForegroundColor Green
        break
    }catch{
        Write-Host "$target does not exist please enter a valid mailbox" -ForegroundColor Red
    }
}

$All = Get-Mailbox $target

# Add the specified email to the targets safe senders list
while($true){
    $trustedSender = read-host "Type the 'trusted senders' email address"
    try{
        $All | ForEach-Object {Set-MailboxJunkEmailConfiguration $_.Name -TrustedSendersAndDomains @{Add="$trustedSender"}}
        Write-Host "Successfully added $trustedSender to $target's Safe Senders List" -ForeGroundColor Green
    }catch{
        "An error occurred."
        break
    }
    
    # List the targets Safe Senders list for volidation
    $test = (Get-MailboxJunkEmailConfiguration -Identity $target).TrustedSendersAndDomains
    Write-Host "Here are the addresses in $target's SafeSenders list"
    foreach($item in $test){
        Write-Host $item
    }

    # Check if another mailbox needs to be added to the SafeSenders list of the target and loop. If not break out of the loop and exit the script
    $continue = Read-Host "Would you like to add another user to" $target "'s safesenders list? [Y/N]"
    if($continue -eq "N"){break}
}