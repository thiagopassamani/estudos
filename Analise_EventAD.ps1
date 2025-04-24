###############################################################################################################################
# Em deseolvimento.
###############################################################################################################################
# Quantidade de eventos
$MaxEventsN = 100

# Definir caminho do arquivo HTML
$HtmlFile = "C:\Tools\Falhas_Login_AD.html"

# Lista de servidores para consultar eventos
$Servers = @("DC18.NOVAFORMA.LOCAL", "NF-AZ-AD-01.NOVAFORMA.LOCAL")

# Definir intervalo de tempo para a data atual
$TodayStart = Get-Date -Hour 00 -Minute 00 -Second 00
$TodayEnd = Get-Date -Hour 23 -Minute 59 -Second 59

# Inicializar variável para armazenar eventos
$AllEvents = @()

foreach ($Server in $Servers) {
    
    Write-Host "[+] Consultando eventos no servidor: " -ForegroundColor Yellow
    
    try {
               
        # Buscar eventos de falha de login
        $Events = Get-WinEvent -LogName Security -ComputerName $Server -MaxEvents $MaxEventsN | Where-Object { $_.TimeCreated -ge $TodayStart -and $_.TimeCreated -le $TodayEnd -and ($_.Id -eq 4624 -or $_.Id -eq 4625 -or $_.Id -eq 4740) } 
        
        Write-Host "[*] $Server" -ForegroundColor Green
        
        if ($Events.Count -gt 0) {
            Write-Host "[*] Analisando eventos em $Server." -ForegroundColor Green

            foreach ($Event in $Events) {
                $Message = $Event.Message
                $UserName = "Desconhecido"

                if ($Message -match "Account Name:\s+(\S+)") {
                    $UserName = $matches[1]
                }

                # Adiciona evento ao array
                $AllEvents += [PSCustomObject]@{                    
                    Servidor = $Server
                    IdEventN = $Event.Id
                    DataHora = $Event.TimeCreated
                    Detalhes = $Message
                }
            }
        } else {
            Write-Host "[*] Nenhum evento encontrado no $Server" -ForegroundColor Yellow
        }
        Write-Host "[*] Finalizando..." -ForegroundColor Green
    } catch {
        Write-Host "[-] Erro ao conectar-se ao $Server" -ForegroundColor Red
    }
}

# Cabeçalho do HTML
$HtmlContent = @"
<!DOCTYPE html>
<html lang='pt'>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>Relatório de Bloqueios de Conta</title>
    <link href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css' rel='stylesheet'>
    <script src='https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js'></script>
</head>
<body class='container mt-4'>
    <h2 class='text-center'>Relatório de Bloqueios de Conta no Active Directory</h2>
    
    <div class='mb-3'>
        <input type='text' id='filterInput' class='form-control' placeholder='Digite...' onkeyup='filterTable()'>
    </div>

    <table class='table table-striped table-bordered mt-3' id='dataTable' data-url="json/data1.json" data-filter-control="true" data-show-search-clear-button="true">
        <thead class='table-dark'>
            <tr>                
                <th>Servidor</th>
                <th>ID</th>
                <th>Data e Hora</th>
                <th>Detalhes</th>
            </tr>
        </thead>
        <tbody>

"@

# Adicionar eventos ao HTML
foreach ($Event in $AllEvents) {
    $HtmlContent += @"
        <tr>
            <td>$($Event.Servidor)</td>
            <td>$($Event.IdEventN)</td>
            <td>$($Event.DataHora)</td>
            <td class='filter'>$($Event.Detalhes)</td>
        </tr>
"@
}

# Fechar o HTML com scripts para exportação e filtro
$HtmlContent += @"
        </tbody>
    </table>

    <script>  
        function filterTable() {
            let input = document.getElementById("filterInput").value.toLowerCase();
            let rows = document.querySelectorAll("#dataTable tbody tr");
            
            rows.forEach(row => {
                let rowText = row.innerText.toLowerCase();
                row.style.display = rowText.includes(input) ? "" : "none";
            });
        }
    </script>

    <script src='https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js'></script>
</body>
</html>
"@


# Salvar arquivo HTML
$HtmlContent | Out-File -Encoding utf8 $HtmlFile

Write-Host "[+] Relatório gerado com eventos de falha de login em múltiplos servidores!" -ForegroundColor Green

