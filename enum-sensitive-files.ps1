
param(
    [string]$Path = "C:\",
    [string]$OutputFile = "sensitive_files.txt"
)

$patterns = @(
    "*password*",
    "*credential*",
    "*config*.xml",
    "*backup*.zip",
    "*.kdbx",          # KeePass database
    "*vnc*.ini",       # VNC configs
    "*.rdp",           # RDP connections
    "*unattend*.xml",  # Windows installation
    "*.key",
    "*.pem",
    "*id_rsa*",        # SSH keys
    "web.config",
    "*.bak",
    "*secret*",
    "*.p12",           # Certificate files
    "*.pfx"
)

Write-Host "[+] Searching for sensitive files in: $Path" -ForegroundColor Green
Write-Host "[*] This may take a while...`n" -ForegroundColor Yellow

$results = @()

foreach ($pattern in $patterns) {
    Write-Host "[*] Searching pattern: $pattern" -ForegroundColor Cyan
    
    $files = Get-ChildItem -Path $Path -Recurse -ErrorAction SilentlyContinue -Filter $pattern |
        Select-Object FullName, Length, LastWriteTime, @{Name="Pattern";Expression={$pattern}}
    
    $results += $files
    
    if ($files) {
        $files | Format-Table -AutoSize
    }
}

# Export results
if ($results) {
    $results | Export-Csv -Path $OutputFile -NoTypeInformation
    Write-Host "`n[+] Found $($results.Count) files" -ForegroundColor Green
    Write-Host "[+] Results saved to: $OutputFile" -ForegroundColor Green
}
else {
    Write-Host "`n[-] No sensitive files found" -ForegroundColor Red
}
