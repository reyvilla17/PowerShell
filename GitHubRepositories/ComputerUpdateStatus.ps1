# Computer Status.
$ComputerNames = Read-Host -Prompt "Please Enter the computer lists you wish to get system status from (separated by commas)"
$Computers = $ComputerNames -split ','

# Initialize an array to store the results
$Results = @()

# Loop through each computer
foreach ($Computer in $Computers) {
    $sess = New-CimSession -ComputerName $Computer
    $ComputerStatus = Get-MpComputerStatus -CimSession $sess

    # Check last update 
    $LastUpdateDate = $ComputerStatus.LastFullScanTime
    $DaysSinceLastUpdate = (Get-Date).AddDays(- $LastUpdateDate)
    if ($DaysSinceLastUpdate.Days -gt 30) {

        Write-Host "$Computer needs to be updated."
        $SystemStatus = "Update Needed"

    } else {

        Write-Host "No update needed for $Computer."
        $SystemStatus = "Up to Date"
    }

    # Store results for each computer
    $Result = [PSCustomObject]@{
        ComputerName = $Computer
        LastUpdateDate = $LastUpdateDate
        SystemStatus = $SystemStatus
    }

    # Add result to an array
    $Results += $Result

    # Remove CimSession for this computer
    Remove-CimSession -CimSession $sess
}

# Specify CSV path
$csvFilePath = "C:\Users\Administrator.ADATUM\Documents\sess.csv"

# Export the list of system status to CSV File
$Results | Export-Csv -Path $csvFilePath -NoTypeInformation

Write-Host "System status results have been exported to $csvFilePath"

#Good use of comments, I would guess this would be a good schedualed task.  In stead of a CSV outfile maybe try an email.  Its alot more work and complicated but worth experimenting with.   
