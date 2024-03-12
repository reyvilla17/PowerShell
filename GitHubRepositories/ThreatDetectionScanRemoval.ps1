# Get list of computers to scan
$ComputerNames = Read-Host -Prompt "Please Enter the computers you wish to Scan (separated by comma)"
$Computers = $ComputerNames -split ','

# Initialize an array to store results
$Results = @()

# Loop through each computer
foreach ($Computer in $Computers) {
    $sess = New-CimSession -ComputerName $Computer
    Start-MpScan -ASJob -CimSession $sess -ScanType QuickScan

    # Check for threats and remove if found
    $threatDetection = Get-MpThreatDetection -CimSession $sess
    if ($threatDetection) {
        Write-Host "Threats found on $Computer."
        $threatDetection | Remove-MpThreat -CimSession $sess
    } else {
        Write-Host "No threats found on $Computer."
    }

    # Store results for each computer
    $Result = [PSCustomObject]@{
        ComputerName = $Computer
        ThreatsFound = if ($threatDetection) { "Yes" } else { "No" }
    }

    # Add result to array
    $Results += $Result

    # Remove the CimSession for this computer
    Remove-CimSession -CimSession $sess
}

# Specify CSV path
$csvFilePath = "C:\Users\Administrator.ADATUM\Documents\sess.csv"

# Export the list of Scans to CSV File
$Results | Export-Csv -Path $csvFilePath -NoTypeInformation

Write-Host "Scan results have been exported to $csvFilePath"