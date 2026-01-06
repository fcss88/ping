function Invoke-NetCheck {
    param(
        [Parameter(Mandatory)]
        [string]$ComputerName,

        [int]$Port,

        [switch]$PingOnly,
        [switch]$TcpOnly,
        [switch]$Quiet
    )

    if ($TcpOnly -and -not $Port) {
        throw "TCP check requires a port."
    }

    if ($Quiet) {
        if ($PingOnly) {
            return Test-NetConnection -ComputerName $ComputerName -InformationLevel Quiet
        }
        elseif ($TcpOnly) {
            return Test-NetConnection -ComputerName $ComputerName -Port $Port -InformationLevel Quiet
        }
        elseif ($Port) {
            return Test-NetConnection -ComputerName $ComputerName -Port $Port -InformationLevel Quiet
        }
        else {
            return Test-NetConnection -ComputerName $ComputerName -InformationLevel Quiet
        }
    }

    if ($PingOnly) {
        return Test-NetConnection -ComputerName $ComputerName
    }

    if ($TcpOnly) {
        return Test-NetConnection -ComputerName $ComputerName -Port $Port
    }

    if ($Port) {
        return Test-NetConnection -ComputerName $ComputerName -Port $Port
    }

    return Test-NetConnection -ComputerName $ComputerName
}
