import os, time, sys
from win10toast import ToastNotifier

# Empresa
notifEmpresa = "Novaforma"
# Titulo 
notifTitulo = f"TI - {notifEmpresa}"
# Tempo para exibição em segundos
notifDuracao = "300"
# Mensagem para exibição
notifMsg = f"Seu computador será desligado automaticamente em breve de acordo com a politica da empresa {notifEmpresa}! Seu desligamento será feito em 5 minutos, caso necessite, desative o desligamento utilizando o atalho no seu desktop."

# Iniciando 
toaster = ToastNotifier()

# Notificação
toaster.show_toast(
    notifTitulo,
    notifMsg,
    threaded=True,
    icon_path=None, # custom.ico
    duration=notifDuracao
)

# Enquando estiver ativa a notificação permanece visivel
while toaster.notification_active(): time.sleep(0.1)

# Reiniciando o computador
os.system('shutdown /s /f /t ' + str(notifDuracao) + ' /c " ' + str(notifMsg) + '"')

# Finaliza
sys.exit()