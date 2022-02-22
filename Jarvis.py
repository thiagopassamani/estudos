from traceback import print_tb
from winreg import QueryValueEx
from plyer import notification
import speech_recognition as sr
import pyttsx3, datetime, wikipedia, pywhatkit, time, os, webbrowser, smtplib


audio =  sr.Recognizer()

engineJarvis = pyttsx3.init('sapi5')

voices = engineJarvis.getProperty('voices')
engineJarvis.setProperty('voice', voices[-3].id)

def speakJarvis(audio):
    engineJarvis.say(audio)
    engineJarvis.runAndWait()

def wishMe():    
    
    hour = int(datetime.datetime.now().hour)
    
    if hour>=0 and hour<12:
        speakJarvis("Bom dia!")
    elif hour>=12 and hour<18:
        speakJarvis("Boa tarde!")
    else:
        speakJarvis("Boa noite!")  

    speakJarvis("eu sou Jarvis, assistente pessoal, o que posso ajudar?")   
    
wishMe()    


def takeCommand():
    #It takes microphone input from the user and returns string output


    with sr.Microphone() as source:
        print("Ouvindo...")
        listeningAudio = audio.listen(source,timeout=2,phrase_time_limit=60)
        time.sleep(10)

    try:
        print("Reconhecendo...")    
        query = audio.recognize_google(listeningAudio, language='pt-BR')
        print(f"Usuário disse: {query}\n")
        speakJarvis(query)

    except Exception as e: 
        print("Desculpe, tente novamente, por favor...")  
        return "None"
    return query

def notifJarvis():
    while True:
        
        time.sleep(1)
    
        notification.notify(
            title = 'Texto do Titulo',
            message = 'Teste',
            app_icon = 'water.ico',
            timeout = 10
         )
    
        time.sleep(180)
    
        exit()

if __name__ == "__main__":    
    while True:
       
        query = takeCommand().lower()

        if 'abrir youtube' in query:
            webbrowser.open("youtube.com")
        
        elif 'ouvir musica' in query:
            music_dir = 'C:\\Tools\\Musica'
            songs = os.listdir(music_dir)
            print(songs)    
            os.startfile(os.path.join(music_dir, songs[0]))

        elif 'que hora são' in query:
            strTime = datetime.datetime.now().strftime("%H:%M:%S")    
            speakJarvis(f"Senhor, são {strTime}")

        elif 'hora de codar' in query:
            codePath = "C:\\Users\\thiago.passamani\\AppData\\Local\\Programs\\Microsoft VS Code\\Code.exe"
            os.startfile(codePath)
            
        elif 'tchau' in query:
            speakJarvis('Tchau')
            print('Tchau')
            exit()
            
        else:            
            notifJarvis()