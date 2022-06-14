# Thiago Passamani <thiagopassamani@gmail.com>
# Conexão com MS SQL Server da Secullum Acesso.net

import pyodbc 

cnxn = pyodbc.connect("Driver={SQL Server};"
                      "Server=10.101.40.13\SQLEXPRESS;"
                      "UID=sa;"
                      "PWD=ata43690;"
                      "Database=SecullumAcessoNet;"
                      "Trusted_Connection=yes;")

cursor = cnxn.cursor()
# cursor.execute('SELECT id, descricao, lotacao_maxima, quantidade_atual FROM SecullumAcessoNet.dbo.ambientes WHERE id = 1')
cursor.execute('SELECT lotacao_maxima, quantidade_atual FROM SecullumAcessoNet.dbo.ambientes WHERE id = 1')

for row in cursor:
  # Teste
  #print(row[0], row[1])
  
  # lotacao_maxima menos quantidade_atual   
  qtd_disponivel = row[0] - row[1]
  
  if qtd_disponivel == 0:
      print('Não há vagas disponíveis, aguarde um momento!')
  elif qtd_disponivel >= 8 :
      print(qtd_disponivel, 'Vagas')
  else:
      print(qtd_disponivel, 'Vagas')
  ##print(row[0])
  #row = cursor.fetchone()
  
   