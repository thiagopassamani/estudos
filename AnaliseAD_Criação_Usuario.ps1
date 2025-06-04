# Importa o módulo do Active Directory (se ainda não estiver carregado)
Import-Module ActiveDirectory

# Busca todos os usuários no Active Directory
$users = Get-ADUser -Filter * -Properties Name, SamAccountName, Enabled, whenCreated

# Exibe as propriedades desejadas para cada usuário
foreach ($user in $users) {
    Write-Host "Nome: $($user.Name)"
    Write-Host "Nome de logon do usuário: $($user.SamAccountName)"
    Write-Host "Habilitado: $($user.Enabled)"
    Write-Host "Data de Criação: $($user.whenCreated)"
    Write-Host "-------------------------"
}

Write-Host "Listagem de usuários do Active Directory concluída."