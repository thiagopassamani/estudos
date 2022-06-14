import random
import string

length = int(input('Insira quantidade de digitos para a senha: '))

if (length > 6) :
    lower   = string.ascii_lowercase
    upper   = string.ascii_uppercase
    numbers = string.digits
    symbols = string.punctuation
else :
    lower   = "abcdfghijklmnopqrstuvwyz"
    upper   = "ABCDFGHIJKLMNOPQRSTUVWYZ" 
    numbers = "0123456789"
    symbols = "!@#$%&*+"

all = lower + upper + numbers + symbols

password = "".join(random.sample(all, length))

print(password)

exit()