CREATE DATABASE IF NOT EXISTS Clinica_Essencia_Viva;
USE Clinica_Essencia_Viva;

CREATE TABLE IF NOT EXISTS usuario (
 id INT AUTO_INCREMENT PRIMARY KEY,
 nome VARCHAR(120) NOT NULL,
 login VARCHAR(80) NOT NULL UNIQUE,
 senha_hash VARCHAR(255) NOT NULL,
 perfil ENUM('administrador','recepcionista') NOT NULL,
 status ENUM('ativo','inativo') NOT NULL DEFAULT 'ativo',
 tentativas_falhas INT NOT NULL DEFAULT 0,
 bloqueado_ate DATETIME NULL
);

CREATE TABLE IF NOT EXISTS sessao (
 id INT AUTO_INCREMENT PRIMARY KEY,
 usuario_id INT NOT NULL,
 token_hash CHAR(64) NOT NULL,
 criado_em DATETIME NOT NULL,
 ultima_atividade DATETIME NOT NULL,
 status ENUM('ativa','encerrada','expirada') NOT NULL,
 FOREIGN KEY(usuario_id) REFERENCES usuario(id),
 INDEX ix_sessao_token(token_hash)
);

CREATE TABLE IF NOT EXISTS log_seguranca (
 id INT AUTO_INCREMENT PRIMARY KEY,
 evento VARCHAR(80) NOT NULL,
 usuario_id INT NULL,
 criado_em DATETIME NOT NULL,
 FOREIGN KEY(usuario_id) REFERENCES usuario(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS cliente (
 id INT AUTO_INCREMENT PRIMARY KEY,
 nome VARCHAR(120) NOT NULL,
 cpf_hash CHAR(64) NOT NULL UNIQUE,
 cpf_cifrado TEXT NOT NULL,
 nascimento_cif TEXT NOT NULL,
 telefone_cif TEXT,
 email_cif TEXT,
 endereco_cif TEXT,
 observacoes_cif TEXT,
 status ENUM('ativo','inativo') NOT NULL DEFAULT 'ativo'
);

CREATE TABLE IF NOT EXISTS profissional (
 id INT AUTO_INCREMENT PRIMARY KEY,
 nome VARCHAR(120) NOT NULL,
 registro_profissional VARCHAR(50) NOT NULL UNIQUE,
 especialidade VARCHAR(120) NOT NULL,
 status ENUM('ativo','inativo') NOT NULL DEFAULT 'ativo'
);

CREATE TABLE IF NOT EXISTS procedimento (
 id INT AUTO_INCREMENT PRIMARY KEY,
 nome VARCHAR(120) NOT NULL,
 descricao VARCHAR(500),
 duracao_minutos INT NOT NULL,
 valor DECIMAL(10,2) NOT NULL,
 status ENUM('ativo','inativo') NOT NULL DEFAULT 'ativo'
);

CREATE TABLE IF NOT EXISTS agendamento (
 id INT AUTO_INCREMENT PRIMARY KEY,
 cliente_id INT NOT NULL,
 profissional_id INT NOT NULL,
 data DATE NOT NULL,
 hora_inicio TIME NOT NULL,
 hora_fim TIME NOT NULL,
 situacao ENUM('agendado','concluido','cancelado') NOT NULL DEFAULT 'agendado',
 valor_total DECIMAL(10,2) NOT NULL,
 FOREIGN KEY(cliente_id) REFERENCES cliente(id),
 FOREIGN KEY(profissional_id) REFERENCES profissional(id),
 INDEX ix_agenda_profissional_data(profissional_id,data)
);

CREATE TABLE IF NOT EXISTS agendamento_procedimento (
 agendamento_id INT NOT NULL,
 procedimento_id INT NOT NULL,
 valor_cobrado DECIMAL(10,2) NOT NULL,
 PRIMARY KEY(agendamento_id,procedimento_id),
 FOREIGN KEY(agendamento_id) REFERENCES agendamento(id) ON DELETE CASCADE,
 FOREIGN KEY(procedimento_id) REFERENCES procedimento(id)
);

-- Os dados de demonstração são gerados pela aplicação (SeedService), conforme solicitado na atividade.
