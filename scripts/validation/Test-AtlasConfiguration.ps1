[CmdletBinding()]
param([string]$CsvPath = (Join-Path $PSScriptRoot '..\..\examples\synthetic-data\users.csv'))
$ErrorActionPreference = 'Stop'
$rows = @(Import-Csv -LiteralPath $CsvPath)
if ($rows.Count -eq 0) { throw 'No synthetic users found.' }
$allowed = @('IT','Human Resources','Finance','Operations','Engineering','Management')
if (@($rows | Where-Object { $_.Department -notin $allowed -or $_.SamAccountName -notmatch '^lab\.[a-z0-9.]+$' }).Count -gt 0) { throw 'Invalid user data.' }
if (@($rows.SamAccountName | Select-Object -Unique).Count -ne $rows.Count) { throw 'Duplicate SamAccountName.' }
[pscustomobject]@{ Name='Synthetic CSV validation'; Count=$rows.Count; Status='PASS'; TimestampUtc=[DateTime]::UtcNow.ToString('o') }
