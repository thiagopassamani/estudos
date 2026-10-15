#######################################################################################
# Customizado por Thiago Passamani <thiagopassamani@gmail.com>
#######################################################################################
[CmdletBinding()]
param(
    [Parameter(Mandatory = $false, Position = 0)]
    [string]$IP,

    [Parameter(Mandatory = $false)]
    [int]$TimeoutMs = 300
)

if ([string]::IsNullOrWhiteSpace($IP)) {
    Write-Host "[ PortScanner PS ]" -ForegroundColor Yellow
    Write-Host "Modo de uso: .\portScanner.v1.ps1 <IP_OU_HOSTNAME> [-TimeoutMs 300]" -ForegroundColor Gray
    exit
}

Write-Host "[+] Target: $IP" -ForegroundColor Yellow
Write-Host "[+] Timeout por porta: ${TimeoutMs}ms`n" -ForegroundColor DarkGray

$topPorts = @(
    21, 22, 23, 25, 53, 67, 68, 69, 80, 81, 110, 115, 123, 139, 143, 443, 445, 465, 
    587, 993, 995, 989, 990, 1521, 2525, 3200, 3299, 3300, 3306, 3389, 4800, 4443, 
    5432, 8000, 8010, 8080, 8081, 8100, 5000, 50001, 50002, 50003, 50004, 50005, 
    50006, 50007, 50008, 50010, 65443
)

foreach ($porta in $topPorts) {
    $tcpClient = New-Object System.Net.Sockets.TcpClient
    
    try {
        # Inicia conexão assíncrona para controlar o timeout
        $asyncResult = $tcpClient.BeginConnect($IP, $porta, $null, $null)
        $waitHandle = $asyncResult.AsyncWaitHandle.WaitOne($TimeoutMs, $false)

        if ($waitHandle -and $tcpClient.Connected) {
            $tcpClient.EndConnect($asyncResult)
            Write-Host "[ ABERTA  ] Porta $porta" -ForegroundColor Green
        } else {
            Write-Host "[ FECHADA ] Porta $porta" -ForegroundColor Red
        }
    }
    catch {
        Write-Host "[ FECHADA ] Porta $porta" -ForegroundColor Red
    }
    finally {
        $tcpClient.Close()
        $tcpClient.Dispose()
    }
}
