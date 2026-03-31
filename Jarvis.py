from traceback import print_tb
from winreg import QueryValueEx
from plyer import notification
import speech_recognition as sr
import pyttsx3, datetime, wikipedia, pywhatkit, time, os, webbrowser, smtplib

engineJarvis = pyttsx3.init('sapi5')
voiceJarvis = engineJarvis.getProperty('voices')
engineJarvis.setProperty('voice', voiceJarvis[-3].id) # Voz feminina

recognizerJarvis =  sr.Recognizer()

def speakJarvis(recognizerJarvis):
    engineJarvis.say(recognizerJarvis)
    engineJarvis.runAndWait()

# Saudação
def greetingJarvis():    
    
    hour = int(datetime.datetime.now().hour)
    
    if (0 >= hour < 12):
        greeting = "Bom dia!"
    elif (12 <= hour < 18):
        greeting = "Boa tarde!"
    else:
        greeting = "Boa noite!"
        
    speakJarvis(f"{greeting} eu sou Jarvis, assistente pessoal, o que posso ajudar?")   
    
def takeCommand():
    # Ativa o microfone, reconhece o comando e transforma em texto
    with sr.Microphone() as capturingAudio:
        print("Ouvindo...")
        capturedAudio = recognizerJarvis.listen(capturingAudio,timeout=10,phrase_time_limit=60)
        time.sleep(10)
    # Reconhece o texto e tranformar em voz
    try:
        print("Reconhecendo...")    
        commandJarvis = recognizerJarvis.recognize_google(capturedAudio, language='pt-BR')
        print(f"Usuário disse: {commandJarvis}\n")
        speakJarvis(commandJarvis)
    # Caso não seja capturada a voz
    except Exception as e: 
        print("Desculpe, tente novamente, por favor...")  
        return "None"
    return commandJarvis

def notifJarvis():
    while True:
        
        time.sleep(1)
    
        notification.notify(
            title = 'Jarvis',
            message = 'Teste',
            app_icon = 'water.ico',
            timeout = 10
        )
    
        time.sleep(180)
    
        exit()

if __name__ == "__main__":    
    while True:
        greetingJarvis()
       
        commandJarvis = takeCommand().lower()

        if 'abrir youtube' in commandJarvis:
            webbrowser.open("youtube.com")
        
        elif 'ouvir musica' in commandJarvis:
            music_dir = 'C:\\Tools\\Musica'
            songs = os.listdir(music_dir)
            print(songs)    
            os.startfile(os.path.join(music_dir, songs[0]))

        elif 'que hora são' in commandJarvis:
            strTime = datetime.datetime.now().strftime("%H:%M:%S")    
            speakJarvis(f"Senhor, são {strTime}")

        elif 'hora de codar' in commandJarvis:
            codePath = "C:\\Users\\thiago.passamani\\AppData\\Local\\Programs\\Microsoft VS Code\\Code.exe"
            os.startfile(codePath)
            
        elif 'notificação' in commandJarvis:
            speakJarvis('Notificação')    
            notifJarvis()
            
        elif 'teste' in commandJarvis:
            speakJarvis('teste')    
                            
        else:        
            speakJarvis('Tchau')
            print('Tchau')
            exit()