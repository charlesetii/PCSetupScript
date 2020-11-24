
function Initialize-Windows {
    Set-ExplorerAdvanced -Key "HideFileExt" -Value "0"
    Set-ExplorerAdvanced -Key "Hidden" -Value "1"
    Set-ExplorerAdvanced -Key "ShowSuperHidden" -Value "1"
    Set-ExplorerAdvanced -Key "DontPrettyPath" -Value "1"

    # Restart Powershell
    gps 'explorer' | stop-process
}


function Set-ExplorerAdvanced {
    Param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [String]
        $Key,
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [String]
        $Value
    )

    $regLoc = "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    $fullReg = "HKCU:\$regLoc"

    Write-Host "New Value to be $fullReg\$Key = $Value"

    $oldVal = (Get-ItemProperty -Path $fullReg).$Key

    Write-Host "Current value $fullReg\$Key = $oldVal"


    If ($Value -ne $oldVal) {
        Write-Host "Changing value from $oldVal to $Value"
        Set-ItemProperty -Path $fullReg -Name $Key -Value $Value

        $oldVal = (Get-ItemProperty -Path $fullReg).$Key
        Write-Host "Value changed to $oldVal"
    }
} 



