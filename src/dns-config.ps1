# 1. Configuração do Servidor de Nomes (NS)

# Insira o nome do domínio e o endereço IP do servidor de nomes
$dominio = "example.com"     # Substitua por seu domínio
$ipNS = "192.168.1.2"        # Substitua pelo IP do seu servidor DNS

# Adiciona o registro de servidor de nomes (NS) para a zona do domínio
Add-DnsServerResourceRecord -ZoneName $dominio -NS -Name $dominio -NsHost $ipNS
Write-Host "Servidor de Nomes (NS) configurado para o domínio $dominio com o IP $ipNS."

# 2. Habilitar Consulta Recursiva

# Habilita a recursividade no servidor DNS (isso permite que ele encaminhe consultas que não pode resolver)
Set-DnsServerRecursion -Enable 1
Write-Host "Consulta recursiva habilitada."

# 3. Definir Encaminhadores DNS Externos

# Lista de IPs de encaminhadores DNS externos, como os DNS públicos do Google (8.8.8.8, 8.8.4.4)
$encaminhadores = @("8.8.8.8", "8.8.4.4")    # Substitua pelos IPs dos servidores DNS que deseja usar como encaminhadores

# Configura os encaminhadores DNS para consultas externas
Set-DnsServerForwarder -IPAddress $encaminhadores
Write-Host "Encaminhadores DNS configurados: $($encaminhadores -join ', ')."

# 4. Configurar Root Hints

# Remove todos os root hints existentes no servidor DNS
Remove-DnsServerRootHint -NameServer ".*"
Write-Host "Root Hints antigos removidos."

# Adiciona novos root hints. Insira os IPs dos servidores raiz (root hints)
$rootHints = @("198.41.0.4", "192.228.79.201", "192.33.4.12")  # Substitua pelos root hints que deseja adicionar

# Adiciona os novos servidores raiz
foreach ($ip in $rootHints) {
    Add-DnsServerRootHint -NameServer $ip
    Write-Host "Root Hint adicionado: $ip."
}

# 5. Configurar DNS de Primeiro Nível (TLD)

# Defina a zona DNS de primeiro nível (TLD) e o servidor de nomes
$tld = "exampletld"            # Substitua pelo TLD que deseja configurar
$nsHost = "ns.exampletld"       # Substitua pelo nome do host do servidor de nomes para esse TLD
$ipNSTLD = "192.168.1.3"        # Substitua pelo IP do servidor de nomes para esse TLD

# Cria uma nova zona primária para o TLD
Add-DnsServerPrimaryZone -Name $tld -ZoneFile "$tld.dns" -ReplicationScope Domain
Write-Host "Zona de TLD $tld criada."

# Adiciona o registro de NS para a zona de primeiro nível
Add-DnsServerResourceRecord -ZoneName $tld -NS -Name $nsHost -NsHost $ipNSTLD
Write-Host "Registro NS adicionado para o TLD $tld com host $nsHost e IP $ipNSTLD."
