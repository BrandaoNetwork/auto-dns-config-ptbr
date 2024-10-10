# 1. Configuração do Servidor de Nomes (NS)

# Defina o nome do domínio e o IP do servidor de nomes
$dominio = "example.com"     # Substitua pelo seu domínio
$ipNS = "192.168.1.2"        # Substitua pelo IP do seu servidor DNS

# Adiciona o registro NS para o domínio
Add-DnsServerResourceRecord -ZoneName $dominio -NS -Name $dominio -NsHost $ipNS
Write-Host "Servidor de Nomes (NS) configurado para o domínio $dominio com o IP $ipNS."

# 2. Habilitar Consulta Recursiva

# Habilita a recursividade no servidor DNS
Set-DnsServerRecursion -Enable 1
Write-Host "Consulta recursiva habilitada."

# 3. Definir Encaminhadores DNS Externos

# Lista de IPs de encaminhadores DNS externos (substitua pelos IPs desejados)
$encaminhadores = @("8.8.8.8", "8.8.4.4")    # Exemplo: DNS públicos do Google

# Configura os encaminhadores DNS
Set-DnsServerForwarder -IPAddress $encaminhadores
Write-Host "Encaminhadores DNS configurados: $($encaminhadores -join ', ')."

# 4. Configurar Root Hints

# Remove root hints antigos
Remove-DnsServerRootHint -NameServer ".*"
Write-Host "Root Hints antigos removidos."

# Adiciona novos root hints (substitua pelos root hints que deseja)
$rootHints = @("198.41.0.4", "192.228.79.201", "192.33.4.12")
foreach ($ip in $rootHints) {
    Add-DnsServerRootHint -NameServer $ip
    Write-Host "Root Hint adicionado: $ip."
}

# 5. Configurar DNS de Primeiro Nível (TLD)

# Defina a zona DNS de TLD e o servidor de nomes
$tld = "exampletld"            # Substitua pelo TLD desejado
$nsHost = "ns.exampletld"       # Nome do host do servidor de nomes para o TLD
$ipNSTLD = "192.168.1.3"        # IP do servidor de nomes para o TLD

# Cria a zona primária para o TLD
Add-DnsServerPrimaryZone -Name $tld -ZoneFile "$tld.dns" -ReplicationScope Domain
Write-Host "Zona de TLD $tld criada."

# Adiciona o registro NS para o TLD
Add-DnsServerResourceRecord -ZoneName $tld -NS -Name $nsHost -NsHost $ipNSTLD
Write-Host "Registro NS adicionado para o TLD $tld com host $nsHost e IP $ipNSTLD."

# 6. Configuração de Controle de Acesso (ACLs)

# Defina as redes que podem realizar consultas DNS
$allowList = @("192.168.1.0/24", "10.0.0.0/16")    # Substitua pelas suas redes confiáveis

# Configura ACL para permitir consultas somente das redes especificadas
foreach ($network in $allowList) {
    Add-DnsServerQueryResolutionPolicy -Name "AllowNetwork$($network)" -Action ALLOW -ApplyOnResolver -ServerInterfaceIP $network
}
Write-Host "Consultas DNS limitadas às redes confiáveis: $($allowList -join ', ')."

# 7. Configuração de Logging e Auditoria

# Habilitar logging de consultas DNS
Set-DnsServerDiagnostics -LogFilePath "C:\DNSLogs\DnsServerLog.etl" -MaxMBFileSize 100 -EnableLogQueries 1
Write-Host "Logging de consultas DNS habilitado em C:\DNSLogs."

# Habilitar auditoria de segurança para modificações DNS
auditpol /set /subcategory:"Other Object Access Events" /success:enable /failure:enable
Write-Host "Auditoria de modificações DNS habilitada."

# 8. Configuração de Cache DNS

# Definir o TTL (Time to Live) do cache DNS para melhorar o desempenho
Set-DnsServerCache -MaxTTL 01:00:00 -MinTTL 00:01:00
Write-Host "TTL do cache DNS configurado. Máx: 1 hora, Mín: 1 minuto."

# 9. Proteção contra DNS Amplification Attack

# Desabilitar consultas recursivas para redes não confiáveis
Set-DnsServerRecursionScope -Name "." -EnableRecursion $false
Write-Host "Consultas recursivas desabilitadas para redes não confiáveis."

# Habilitar proteção contra ataques de amplificação DNS
Set-DnsServerResponseRateLimiting -Enabled $true -LeakRate 3
Write-Host "Proteção contra ataques de amplificação DNS habilitada."

# 10. Configuração de Redundância e Alta Disponibilidade (Zona Secundária)

# Adicionar um servidor DNS secundário para replicação de zona
$secServer = "192.168.1.4"  # IP do servidor secundário
Add-DnsServerSecondaryZone -Name "example.com" -MasterServers $secServer -ZoneFile "example.com.dns"
Write-Host "Zona DNS secundária configurada com o servidor $secServer."

# 11. Configuração de DNSSEC (Domain Name System Security Extensions)

# Habilitar DNSSEC para a zona
Enable-DnsServerDnsSecZone -ZoneName $dominio -KeyMasterRole Primary
Write-Host "DNSSEC habilitado para a zona $dominio."

# Adicionar chaves de assinatura DNSSEC
Add-DnsServerSigningKey -ZoneName $dominio -CryptoAlgorithm RsaSha256 -KeyLength 2048 -Type KSK
Add-DnsServerSigningKey -ZoneName $dominio -CryptoAlgorithm RsaSha256 -KeyLength 1024 -Type ZSK
Write-Host "Chaves KSK e ZSK adicionadas e a zona $dominio foi assinada."

# 12. Verificação de Status e Diagnóstico

# Verificar o status do servidor DNS
Get-DnsServerStatistics
Write-Host "Estatísticas do servidor DNS verificadas."

# Diagnosticar consultas DNS
Resolve-DnsName example.com
Write-Host "Consulta DNS diagnosticada com sucesso para example.com."

# 13. Backup e Restauração de Zonas DNS

# Defina o caminho para backup das zonas DNS
$backupPath = "C:\DNSBackup\"
if (!(Test-Path -Path $backupPath)) {
    New-Item -Path $backupPath -ItemType Directory
}

# Realizar backup da zona DNS
Backup-DnsServerZone -Name "example.com" -Path $backupPath
Write-Host "Backup da zona DNS realizado em $backupPath."
