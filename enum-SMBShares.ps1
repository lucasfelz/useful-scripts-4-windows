$server = "server-name"

# Obtain server shares
$shares = Get-SmbShare -CimSession $server | Where-Object { $_.Name -notin @("IPC$", "ADMIN$", "C$") }

foreach ($share in $shares) {
    $path = "\\$server\$($share.Name)"
    Write-Host "`n--- Searching in $path ---" -ForegroundColor Cyan

    Get-ChildItem -Path $path -Recurse -ErrorAction SilentlyContinue -Filter "*string-searched*" |
        Select-Object FullName, LastWriteTime
}
