###############################################################################################################################
# Em deseolvimento.
###############################################################################################################################
# Quantidade de eventos
$MaxEventsN = 1000

# Definir caminho do arquivo HTML
$HtmlFile = "C:\Tools\Analise_EventAD.html"

# Lista de servidores para consultar eventos
$Servers = @("SERVER1.LOCAL", "SERVER2.LOCAL")

# Definir intervalo de tempo para a data atual
$TodayStart = Get-Date -Hour 00 -Minute 00 -Second 00
$TodayEnd = Get-Date -Hour 23 -Minute 59 -Second 59

# Inicializar variável para armazenar eventos
$AllEvents = @()

foreach ($Server in $Servers) {

    try {
        Write-Host "[+] Consultando eventos no servidor: $Server" -ForegroundColor Yellow
        
        # Buscar eventos de falha de login (ID 4625)
        $Events = Get-WinEvent -LogName Security -ComputerName $Server -MaxEvents $MaxEventsN | Where-Object { $_.TimeCreated -ge $TodayStart -and $_.TimeCreated -le $TodayEnd -and $_.Id -eq 4624 -or $_.Id -eq 4625 -or $_.Id -eq 4740 } 
        
        if ($Events.Count -gt 0) {
            foreach ($Event in $Events) {
                $Message = $Event.Message
                $UserName = "Desconhecido"

                if ($Message -match "Account Name:\s+(\S+)") {
                    $UserName = $matches[1]
                }

                # Adiciona evento ao array
                $AllEvents += [PSCustomObject]@{
                    Servidor = $Server
                    Usuario = $UserName
                    DataHora = $Event.TimeCreated
                    Detalhes = $Message
                }
            }
        } else {
            Write-Host "[-] Nenhum evento encontrado hoje no servidor: $Server" -ForegroundColor Red
        }
    } catch {
        Write-Host "[-] Erro ao conectar-se ao servidor: $Server" -ForegroundColor Red
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
    <!-- <script src='https://cdn.jsdelivr.net/npm/jsPDF@2.5.1/dist/jspdf.umd.min.js'></script>-->
</head>
<body class='container mt-4'>
    <h2 class='text-center'>Relatório de Bloqueios de Conta no Active Directory</h2>
    
    <div class='mb-3'>
        <input type='text' id='filterInput' class='form-control' placeholder='Digite...' onkeyup='filterTable()'>
    </div>
    <!--
    <button class='btn btn-success' onclick='exportToCSV()'>Exportar CSV</button>
    <button class='btn btn-danger' onclick='exportToPDF()'>Exportar PDF</button>
    -->
    <table class='table table-striped table-bordered mt-3' id='dataTable' data-url="json/data1.json" data-filter-control="true" data-show-search-clear-button="true">
        <thead class='table-dark'>
            <tr>
                <th>Servidor</th>
                <!--<th>Falha</th>-->
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
            <!--<td>$($Event.Usuario)</td>-->
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

        /**
        function exportToCSV() {
            let csv = 'Usuário,Data e Hora,Detalhes\\n';
            let rows = document.querySelectorAll('#dataTable tbody tr');
            
            rows.forEach(row => {
                let data = [];
                row.querySelectorAll('td').forEach(cell => data.push(cell.innerText));
                csv += data.join(',') + '\\n';
            });
            
            let blob = new Blob([csv], { type: 'text/csv' });
            let a = document.createElement('a');
            a.href = URL.createObjectURL(blob);
            a.download = 'Bloqueios_AD.csv';
            a.click();
        }

        function exportToPDF() {
            let { jsPDF } = window.jspdf;
            let doc = new jsPDF();
            doc.text('Relatório de Bloqueios de Conta', 10, 10);
            
            let rows = document.querySelectorAll('#dataTable tbody tr');
            let y = 20;
            rows.forEach(row => {
                let data = [];
                row.querySelectorAll('td').forEach(cell => data.push(cell.innerText));
                doc.text(data.join(' | '), 10, y);
                y += 10;
            });

            doc.save('Bloqueios_AD.pdf');
        }
        */
    </script>

    <script src='https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js'></script>
</body>
</html>
"@


# Salvar arquivo HTML
$HtmlContent | Out-File -Encoding utf8 $HtmlFile

Write-Host "Relatório gerado com eventos de falha de login (ID 4625) em múltiplos servidores!" -ForegroundColor Green
