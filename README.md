
# Automação de Configuração de Servidor DNS no Windows Server

Este projeto oferece um script PowerShell para configurar automaticamente um servidor DNS no Windows Server, seguindo as melhores práticas de segurança, desempenho e disponibilidade. O objetivo é simplificar a implementação e garantir que o servidor DNS seja configurado de maneira adequada, robusta e segura.

## Funcionalidades

Este script de automação inclui as seguintes configurações:

1. **Configuração do Servidor de Nomes (NS)**: Adiciona registros NS para definir o servidor de nomes autoritativo para um domínio.
2. **Habilitação de Consulta Recursiva**: Ativa a capacidade do servidor DNS de realizar consultas recursivas para resolver domínios que ele não tem diretamente.
3. **Encaminhadores DNS Externos**: Configura encaminhadores externos (como o Google DNS) para que consultas não resolvidas localmente sejam redirecionadas de forma eficiente.
4. **Configuração de Root Hints**: Remove antigos e adiciona novos root hints, otimizando a consulta aos servidores raiz.
5. **Configuração de DNS de Primeiro Nível (TLD)**: Cria uma zona para TLDs e define os servidores de nomes correspondentes.
6. **Controle de Acesso (ACLs)**: Implementa políticas de controle de acesso para restringir as consultas DNS a redes confiáveis, garantindo maior segurança.
7. **Logging e Auditoria**: Habilita logs detalhados de consultas e modificações no DNS, facilitando auditorias e investigações de segurança.
8. **Cache DNS**: Configura políticas de cache para melhorar o desempenho e otimizar a resolução de nomes.
9. **Proteção contra Amplificação de DNS**: Habilita proteção contra ataques de amplificação de DNS, uma das ameaças mais comuns a servidores DNS.
10. **Redundância e Alta Disponibilidade**: Configura um servidor DNS secundário para replicação das zonas e garantir disponibilidade contínua.
11. **DNSSEC (Domain Name System Security Extensions)**: Habilita DNSSEC para assegurar a integridade e autenticidade das respostas DNS.
12. **Diagnóstico e Verificação de Status**: Inclui comandos de diagnóstico para verificar a saúde do servidor DNS e suas zonas.
13. **Backup de Zonas DNS**: Automatiza o backup regular das zonas DNS para recuperação em caso de falhas ou corrupção de dados.

## Requisitos

- **Windows Server**: O script foi projetado para funcionar em servidores que rodam o Windows Server com o recurso DNS instalado.
- **PowerShell**: Certifique-se de ter privilégios de administrador para executar o script.

## Como Usar

1. Clone este repositório em seu servidor DNS:
   
   ```bash
   git clone https://github.com/seu-usuario/nome-do-repositorio.git
   ```

2. Abra o PowerShell com permissões de administrador.

3. Execute o script `configurar_dns.ps1`:
   
   ```powershell
   cd nome-do-repositorio
   .\configurar_dns.ps1
   ```

4. Siga as instruções do script, inserindo informações específicas do seu servidor DNS, como IPs, domínios e redes confiáveis.

## Personalização

O script contém diversos pontos onde você pode personalizar as configurações, como:
- **Domínio e IP do Servidor DNS**: Defina o nome do domínio e o IP do servidor DNS.
- **Encaminhadores DNS**: Modifique os encaminhadores DNS externos conforme sua necessidade.
- **Redes Confiáveis para Consultas**: Insira as redes autorizadas a realizar consultas DNS.
- **Chaves DNSSEC**: Configure as chaves de assinatura e outros parâmetros de segurança.

## Contribuição

Sinta-se à vontade para contribuir com melhorias, abrindo issues ou fazendo pull requests. Todas as sugestões são bem-vindas!

## Licença

Este projeto está licenciado sob a licença MIT. Consulte o arquivo `LICENSE` para obter mais detalhes.
