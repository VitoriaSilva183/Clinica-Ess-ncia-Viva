# Documentação - Essência Viva

## Introdução e escopo
O sistema gerencia clientes, profissionais, procedimentos, agendamentos e usuários da clínica estética Essência Viva. O cliente não possui acesso ao sistema.

## Requisitos funcionais atendidos
- Login e logout.
- Sessão com tempo de inatividade configurável, padrão de 15 minutos.
- Aviso nos últimos 60 segundos e renovação da sessão.
- CRUD de clientes, profissionais e procedimentos.
- Cadastro de usuários por administrador.
- Agendamento com cliente, profissional, data, horário e procedimentos.
- Situações agendado, concluído e cancelado.
- Bloqueio após três falhas de login.
- Consulta de dados sensíveis apenas na tela de detalhes.

## Regras de negócio
1. Um profissional não pode possuir atendimentos sobrepostos.
2. Um cliente com agendamento concluído não é apagado: fica inativo.
3. O valor total é a soma dos valores copiados para `agendamento_procedimento` no momento do agendamento.

## Segurança
### Senhas
As senhas usam BCrypt com salt e nunca são armazenadas em texto puro.

### Dados sensíveis
CPF, nascimento, telefone, e-mail, endereço e observações são armazenados com AES-256-GCM. Cada valor recebe nonce/IV aleatório e tag de autenticação.

### Busca por CPF
O CPF normalizado somente com dígitos gera HMAC-SHA256 e é armazenado em `cpf_hash` para busca e unicidade. O CPF original permanece em `cpf_cifrado`.

### Chave
A chave AES/HMAC é carregada de `CLINICA_ENCRYPTION_KEY_BASE64`, fora do código-fonte e do versionamento.

### Sessão
O token da sessão não é armazenado diretamente no banco. O banco recebe apenas SHA-256 do token. A sessão registra última atividade e é invalidada no logout ou na expiração.

### Logs
São registrados eventos de autenticação sem senha, chave ou dados pessoais.

### SQL injection
As consultas usam parâmetros do `MySqlCommand`.

### HTTPS
Como a solução reutilizada é desktop/Windows Forms e acessa o banco diretamente, não há tráfego HTTP do navegador para uma API. HTTPS deve ser tratado como melhoria arquitetural se o projeto for migrado para web/API.

## Dicionário de dados resumido
| Entidade | Campo | Proteção |
|---|---|---|
| Usuario | senha_hash | BCrypt |
| Sessao | token_hash | SHA-256 |
| Cliente | nome | texto claro |
| Cliente | cpf_hash | HMAC-SHA256 |
| Cliente | cpf_cifrado | AES-256-GCM |
| Cliente | nascimento_cif | AES-256-GCM |
| Cliente | telefone_cif | AES-256-GCM |
| Cliente | email_cif | AES-256-GCM |
| Cliente | endereco_cif | AES-256-GCM |
| Cliente | observacoes_cif | AES-256-GCM |
| Agendamento_Procedimento | valor_cobrado | snapshot do valor |

## Arquitetura
- Apresentação: Windows Forms em `Forms/`.
- Regras/segurança: `Services/`.
- Acesso a dados: `Repositories/`.
- Modelos: `Models/`.
- Banco: `Database/` e `banco.sql`.

## Demonstração de 5 minutos
1. Entrar como administrador.
2. Mostrar usuários e hash da senha no banco.
3. Cadastrar cliente e mostrar os campos cifrados no banco.
4. Mostrar CPF mascarado na listagem e completo somente no detalhe autorizado.
5. Criar um agendamento com dois procedimentos.
6. Tentar outro agendamento sobreposto para o mesmo profissional.
7. Concluir o atendimento e tentar excluir o cliente.
8. Definir timeout para 1 minuto e demonstrar aviso e expiração.
