Connect-ExchangeOnline

$target
$trustedSender
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

while($true){
    $trustedSender = read-host "Type the 'trusted senders' email address"
    try{
        $All | ForEach-Object {Set-MailboxJunkEmailConfiguration $_.Name -TrustedSendersAndDomains @{Add="$trustedSender"}}
        Write-Host "Successfully added $trustedSender to $target's Safe Senders List" -ForeGroundColor Green
    }catch{
        "An error occurred."
        break
    }
    
    $test = (Get-MailboxJunkEmailConfiguration -Identity $target).TrustedSendersAndDomains
    Write-Host "Here are the addresses in $target's SafeSenders list"
    foreach($item in $test){
        Write-Host $item
    }

    $continue = Read-Host "Would you like to add another user to" $target "'s safesenders list? [Y/N]"
    if($continue -eq "N"){break}
}