function Refresh-Environment {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 
    refreshenv
}

function Set-EnvironmentVariable{
    Param(
        [Parameter(Mandatory = $true)]
        [string]
        $VariableName,

        [Parameter(Mandatory = $true)]
        [string]
        $Value,

        [Parameter(Mandatory = $true)]
        [string]
        $Target,

        [Parameter(Mandatory = $false)]
        [bool]
        $Append = $false
    )

    if ($Append) {
        $preVar = [System.Environment]::GetEnvironmentVariable($VariableName)

        $containsValue = ($preVar.Contains($Value) -eq $false)
        if ($containsValue) {
            $value = $preVar + ";" + $Value;
        }
    }

    [System.Environment]::SetEnvironmentVariable($VariableName, $Value, $Target);
    $newEnv = [System.Environment]::GetEnvironmentVariable($VariableName);

    Refresh-Environment
}

function Start-ProcessForOutput {
    Param(
        [Parameter(Mandatory = $true)]
        [string]
        $Command,

        [Parameter(Mandatory = $true)]
        [string]
        $Arguments,

        [Parameter(Mandatory = $false)]
        [bool]
        $RemoveNewLine = $true
    )
    $pinfo = New-Object System.Diagnostics.ProcessStartInfo 
    $pinfo.FileName = $Command
    $pinfo.Arguments = $Arguments
    $pinfo.UseShellExecute = $false 
    $pinfo.CreateNoWindow = $true 
    $pinfo.RedirectStandardOutput = $true 
    $pinfo.RedirectStandardError = $true

    $process = New-Object System.Diagnostics.Process 
    $process.StartInfo = $pinfo

    # Start the process 
    $process.Start() | Out-Null 
    # Wait a while for the process to do something 
    sleep -Seconds 5 
    # If the process is still active kill it 
    if (!$process.HasExited) { 
        $process.Kill() 
    }

    $stdout = $process.StandardOutput.ReadToEnd() 
    $stderr = $process.StandardError.ReadToEnd()

    if ($RemoveNewLine) 
    {
        $stdout = $stdout -replace "`n", "" -replace "`r", "" 
    }

    if ($null -ne $stderr)
    {
        Write-Host "Error from Start-ProcessForOutput $Command $Arguments call $stderr"
    }

    return $stdout.Trim()
}