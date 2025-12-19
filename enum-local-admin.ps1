Write-Host "[+] Enumerating Local Administrators..." -ForegroundColor Green

# Local Administrators group members
try {
    Get-LocalGroupMember -Group "Administrators" -ErrorAction Stop | 
        Select-Object Name, ObjectClass, PrincipalSource |
        Format-Table -AutoSize
}
catch {
    # Fallback via WMI (works remotely too)
    $computer = $env:COMPUTERNAME
    Get-WmiObject -Class Win32_GroupUser -ComputerName $computer |
        Where-Object { $_.GroupComponent -like '*Administrators*' } |
        ForEach-Object {
            $_.PartComponent -replace '.*Name="([^"]+)".*', '$1'
        }
}
