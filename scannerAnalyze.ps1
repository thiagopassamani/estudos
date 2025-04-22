# Solicita o nome do host ou IP
$hostName = Read-Host "Digite o nome do host ou endereço IP para análise"

Write-Host "Analisando o host: $hostName" -ForegroundColor Cyan

# 1. Resolução de DNS
Write-Host "`n[1] Resolução de DNS:" -ForegroundColor Yellow
try {
    $dnsInfo = Resolve-DnsName -Name $hostName
    $dnsInfo | Format-Table -AutoSize
} catch {
    Write-Host "Falha ao resolver DNS para $hostName" -ForegroundColor Red
}

# 2. Teste de conectividade (Ping)
Write-Host "`n[2] Teste de Conectividade (Ping):" -ForegroundColor Yellow
try {
    $pingResult = Test-Connection -ComputerName $hostName -Count 4
    $pingResult | Format-Table -AutoSize
} catch {
    Write-Host "Falha ao realizar o ping no host $hostName" -ForegroundColor Red
}

# 3. Rastreio de Rota (Tracert)
Write-Host "`n[3] Rastreio de Rota (Tracert):" -ForegroundColor Yellow
try {
    tracert $hostName
} catch {
    Write-Host "Falha ao rastrear a rota para o host $hostName" -ForegroundColor Red
}

# 4. Verificação de portas abertas
Write-Host "`n[4] Verificação de Portas Comuns (via Test-NetConnection):" -ForegroundColor Yellow
$commonPorts = @(21,22,23,25,53,69,80,81,110,115,123,143,443,445,465,587,993,995,989,990,2525,3200,3299,3300,3306,4800,4443,8000,8010,8080,8081,8100,5000,50001,50002,50003,50004,50005,50006,50007,50008,50010,65443)
foreach ($port in $commonPorts) {
    $result = Test-NetConnection -ComputerName $hostName -Port $port -WarningAction SilentlyContinue
    $status = if ($result.TcpTestSucceeded) { Write-Host "[ $port ]" -ForegroundColor Green } else { Write-Host "[ $port ]" -ForegroundColor Red }

}

# 5. Detalhes da Interface de Rede Local
Write-Host "`n[5] Detalhes da Interface de Rede Local:" -ForegroundColor Yellow
Get-NetIPAddress | Format-Table -AutoSize
