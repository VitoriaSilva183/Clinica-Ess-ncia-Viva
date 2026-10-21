# Clínica Estética Essência Viva

Sistema web para gerenciamento de uma clínica de estética, desenvolvido
em **ASP.NET Core 8 MVC** com **MySQL**.

## 1. Tecnologias utilizadas

-   .NET 8 / ASP.NET Core MVC
-   C#
-   Razor Views
-   MySQL
-   MySqlConnector
-   BCrypt.Net-Next
-   HTTPS em ambiente de desenvolvimento

## 2. Funcionalidades

O sistema possui:

-   Login e controle de sessão;
-   Expiração automática da sessão por inatividade;
-   Logout;
-   Cadastro, consulta, alteração e exclusão de clientes;
-   Cadastro, consulta, alteração e exclusão de profissionais;
-   Cadastro, consulta, alteração e exclusão de procedimentos;
-   Cadastro e consulta de agendamentos;
-   Controle de conflito de horários para profissionais;
-   Cadastro de usuários;
-   Perfis de acesso de administrador e recepcionista;
-   Registro de sessões;
-   Registro de eventos de segurança;
-   Proteção de senha utilizando BCrypt;
-   Proteção de dados pessoais do cliente com criptografia;
-   Comunicação por HTTPS em desenvolvimento.

## 3. Requisitos

Para executar o projeto, é necessário ter instalado:

-   .NET 8 SDK
-   MySQL Server
-   Visual Studio Code ou Visual Studio
-   MySQL Workbench (recomendado para administrar o banco)

## 4. Banco de dados

O projeto utiliza o banco:

``` text
clinica_essencia_viva
```

O script de criação está no arquivo:

``` text
banco.sql
```

### Criando o banco

1.  Abra o MySQL Workbench.
2.  Conecte-se ao servidor MySQL local.
3.  Abra o arquivo `banco.sql`.
4.  Execute o script pelo botão de raio.
5.  Atualize a lista de Schemas.
6.  Verifique se `clinica_essencia_viva` aparece e contém as tabelas do
    sistema.

## 5. Configuração da conexão

A configuração local deve apontar para o MySQL utilizado no computador.

Exemplo:

``` json
{
  "ConnectionString": "Server=localhost;Port=3306;Database=clinica_essencia_viva;User ID=root;Password=;",
  "SessionTimeoutMinutes": 15
}
```

Se o MySQL do ambiente possuir senha, informe a senha correspondente no
arquivo de configuração local.

> O arquivo de configuração local não deve ser versionado quando
> contiver credenciais ou chaves reais.

## 6. Tempo de sessão

O sistema possui controle de sessão por inatividade.

A configuração pode ser alterada em:

``` text
appsettings.local.json
```

Exemplo para teste rápido:

``` json
"SessionTimeoutMinutes": 1
```

Para uma utilização normal:

``` json
"SessionTimeoutMinutes": 15
```

Após alterar a configuração, reinicie a aplicação.

## 7. Executando o projeto

Abra o terminal na pasta que contém:

``` text
ClinicaEsteticaWeb.csproj
```

Execute:

``` powershell
dotnet restore
```

Depois:

``` powershell
dotnet build
```

Se a compilação terminar sem erros:

``` powershell
dotnet run
```

O terminal exibirá os endereços da aplicação, por exemplo:

``` text
https://localhost:7157
http://localhost:5157
```

Para utilizar HTTPS, abra:

``` text
https://localhost:7157
```

A tela de login pode ser acessada em:

``` text
https://localhost:7157/Account/Login
```

## 8. Usuários iniciais

O sistema possui usuários de demonstração criados pelo mecanismo de seed
da aplicação.

### Administrador

``` text
Usuário: admin
Senha: admin123
```

### Recepcionista

``` text
Usuário: recepcao
Senha: recepcao123
```

Em um ambiente real, essas credenciais devem ser alteradas.

## 9. Controle de sessão

A sessão é controlada no servidor.

O sistema registra a sessão e a última atividade do usuário. Quando o
período configurado de inatividade é ultrapassado, a sessão é encerrada
e o usuário é redirecionado para o login.

O cookie de autenticação/sessão utiliza configurações de segurança
adequadas, incluindo:

-   HttpOnly;
-   Secure;
-   SameSite.

O botão **Sair** encerra a sessão explicitamente.

## 10. Segurança

### Senhas

As senhas não são armazenadas em texto puro. O sistema utiliza
**BCrypt** para armazenamento seguro dos hashes.

### Dados pessoais

Dados pessoais do cliente, como:

-   CPF;
-   data de nascimento;
-   telefone;
-   e-mail;
-   endereço;
-   observações;

devem ser armazenados de forma protegida no banco.

A aplicação utiliza criptografia autenticada **AES-256-GCM** para os
dados protegidos e HMAC para permitir buscas controladas quando
necessário.

### Chave de criptografia

A chave real de criptografia não deve ser colocada diretamente no
código-fonte nem enviada para um repositório público.

Em ambiente acadêmico/local, mantenha a configuração real fora do
versionamento.

## 11. Regras de negócio

O sistema considera, entre outras, as seguintes regras:

-   Um profissional não pode possuir dois atendimentos em horários
    sobrepostos.
-   Um cliente que possui agendamentos concluídos não deve ser excluído
    definitivamente; deve ser inativado.
-   O valor total de um agendamento é obtido pela soma dos procedimentos
    selecionados.
-   O valor do procedimento utilizado no atendimento deve ser preservado
    no momento do agendamento.
-   Apenas usuários autenticados podem acessar as áreas protegidas do
    sistema.

## 12. Estrutura do projeto

``` text
ClinicaEsteticaWeb/
├── Controllers/
├── Models/
├── Services/
├── Views/
├── wwwroot/
├── Program.cs
├── appsettings.json
├── appsettings.local.json
├── banco.sql
└── ClinicaEsteticaWeb.csproj
```

## 13. Teste da expiração de sessão

Para demonstrar a funcionalidade:

1.  Configure temporariamente:

    ``` json
    "SessionTimeoutMinutes": 1
    ```

2.  Reinicie a aplicação.

3.  Faça login.

4.  Não realize nenhuma ação durante mais de 1 minuto.

5.  Tente acessar outra página do sistema.

6.  O sistema deverá encerrar a sessão e retornar à tela de login.

Depois da demonstração, recomenda-se voltar para:

``` json
"SessionTimeoutMinutes": 15
```

## 14. Observação sobre HTTPS

Em desenvolvimento, o ASP.NET Core utiliza um certificado HTTPS local. O
navegador pode mostrar um aviso de certificado não confiável.

Isso é esperado em ambiente de desenvolvimento. Em produção, deve ser
utilizado um certificado válido.

## 15. Entrega acadêmica

O projeto deve ser entregue acompanhado de:

-   código-fonte;
-   script SQL;
-   README;
-   DER;
-   diagrama de casos de uso;
-   documentação do sistema;
-   instruções de configuração e execução.

A chave real de criptografia e outras credenciais privadas não devem ser
incluídas na entrega pública.
