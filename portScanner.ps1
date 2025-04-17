#######################################################################################
# Encontrado no post Linkedin do Luiz Phellipe Borges referenciando Desec Security.
# Customizado por Thiago Passamani <thiagopassamani@gmail.com>
#######################################################################################

param($ip)

if(!$ip)
{

    Write-Host "[ PortScanner PS ]" -ForegroundColor Yellow
    echo "Modo de uso: .\portScanner.ps1 ip/host"
    
}
else 
{
     Write-Host "[+] Target: $ip" -ForegroundColor Yellow

    $topPorts = 21,22,23,25,53,69,80,81,110,115,123,143,443,445,465,587,993,995,989,990,2525,3200,3299,3300,3306,4800,4443,8000,8010,8080,8081,8100,5000,50001,50002,50003,50004,50005,50006,50007,50008,50010,65443

    try
    {
        
        foreach($porta in $topPorts)
        {
            if(Test-NetConnection $ip -Port $porta -WarningAction SilentlyContinue -InformationLevel Quiet)
            {
                #Write-Host "Porta $porta [ Aberta ]" -ForegroundColor Green
                Write-Host "[ $porta ]" -ForegroundColor Green
            }
            else
            {
                #Write-Host "Porta $porta [ Fechada ]" -ForegroundColor Red
                Write-Host "[ $porta ]" -ForegroundColor Red
            }
        }
    }
    catch{}
}
