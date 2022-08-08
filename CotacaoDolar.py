import requests

url = 'https://economia.awesomeapi.com.br/all/USD-BRL'

response = requests.get(url)

if response.status_code == 200:
    dolar_low = response.json()['USD']['low']
    dolar_high = response.json()['USD']['high']
    print(f'O valor do Dólar é R${dolar_low} / R${dolar_high}')
else:
    print('Erro ao buscar valor do Dólar!')