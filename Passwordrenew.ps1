Get-EnabledNonExpiringdUser | Add-ExpiryDataToUser | where-object {
    $_.DaysTOExpire -lt 10
} | Send-PasswordExpiryMessageToUser | Export-CSV report.csv