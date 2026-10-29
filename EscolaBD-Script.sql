

-- =========================================================================
-- AULA PRÁTICA: TRANSFORMAÇÃO DO MODELO CONCEITUAL (DER)
-- Contexto: Sistema Escolar / Matrícula de Alunos
-- =========================================================================

-- Remove o banco de dados se ele já existir para evitar erros
DROP DATABASE IF EXISTS EscolaDB;

-- Criação do banco de dados
CREATE DATABASE EscolaDB;
USE EscolaDB;


-- =========================================================================
-- 1. TABELA ALUNO (Entidade Forte)
--
-- CONCEITO:
-- A tabela Aluno armazena os dados pessoais dos alunos da escola.
--
-- APLICAÇÃO DA 1ª FORMA NORMAL (1FN):
-- O endereço foi dividido em campos simples e atômicos:
-- logradouro, numero, bairro, cidade, uf e cep.
--
-- O CPF é único para cada aluno e não pode ser repetido.
-- =========================================================================

CREATE TABLE Aluno (

    -- idAluno: Chave Primária (PK).
    -- Identifica unicamente cada aluno cadastrado.
    -- AUTO_INCREMENT gera um novo número automaticamente.
    idAluno INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

    -- Nome completo do aluno
    nome VARCHAR(100) NOT NULL,

    -- CPF do aluno: obrigatório e não pode ser repetido.
    -- CHAR(11) armazena os 11 dígitos sem pontuação.
    CPF CHAR(11) NOT NULL UNIQUE,

    -- Endereço dividido em atributos simples
    logradouro VARCHAR(150) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    bairro VARCHAR(60) NOT NULL,
    cidade VARCHAR(60) NOT NULL,
    uf CHAR(2) NOT NULL,
    cep CHAR(8) NOT NULL
);


-- =========================================================================
-- 2. TABELA MATRICULA (Relacionamento 1:N com Aluno)
--
-- CONCEITO:
-- Um aluno pode possuir várias matrículas.
-- Cada matrícula pertence a um único aluno.
--
-- A chave primária de Aluno (idAluno) é utilizada como chave
-- estrangeira (FK) nesta tabela.
-- =========================================================================

CREATE TABLE Matricula (

    -- idMatricula: Chave Primária (PK).
    -- Identifica unicamente cada matrícula.
    idMatricula INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

    -- Data em que a matrícula foi realizada
    data_matricula DATE NOT NULL,

    -- Situação da matrícula: Ativo, Trancado ou Cancelado.
    status VARCHAR(45),

    -- idAluno: Chave Estrangeira (FK).
    -- Identifica o aluno associado à matrícula.
    idAluno INT UNSIGNED NOT NULL,

    -- Integridade referencial entre Matricula e Aluno
    CONSTRAINT fk_aluno
        FOREIGN KEY (idAluno)
        REFERENCES Aluno(idAluno)
);


-- =========================================================================
-- 3. POVOANDO O BANCO DE DADOS (INSERÇÃO DE DADOS - DML)
-- =========================================================================

-- CONCEITO DE ORDEM DE INSERÇÃO:
-- Primeiro cadastramos os alunos e depois as matrículas,
-- pois a tabela Matricula depende da tabela Aluno.


-- -------------------------------------------------------------------------
-- 3.1. CADASTRANDO OS ALUNOS
-- -------------------------------------------------------------------------

-- Os CPFs e endereços abaixo são fictícios, para fins de teste.
-- Informe o CPF com 11 dígitos e o CEP com 8 dígitos, sem pontuação.

INSERT INTO Aluno
    (nome, CPF, logradouro, numero, bairro, cidade, uf, cep)
VALUES
    ('Carlos Eduardo Silva', '12345678901',
     'Rua das Flores', '100', 'Centro', 'Natal', 'RN', '59000000'),

    ('Maria Fernanda Oliveira', '23456789012',
     'Avenida Brasil', '250', 'Alecrim', 'Natal', 'RN', '59010000'),

    ('João Pedro Santos', '34567890123',
     'Rua das Palmeiras', '45', 'Lagoa Nova', 'Natal', 'RN', '59050000');


-- -------------------------------------------------------------------------
-- 3.2. CADASTRANDO AS MATRÍCULAS
-- -------------------------------------------------------------------------

-- Carlos possui duas matrículas, demonstrando o relacionamento 1:N.
INSERT INTO Matricula (data_matricula, status, idAluno)
VALUES
    ('2026-03-01', 'Ativo', 1),
    ('2026-08-01', 'Trancado', 1);

-- Maria possui uma matrícula ativa.
INSERT INTO Matricula (data_matricula, status, idAluno)
VALUES
    ('2026-03-05', 'Ativo', 2);

-- João ainda não possui matrícula cadastrada.


-- =========================================================================
-- 4. CONSULTANDO OS DADOS (SELECT)
-- =========================================================================

-- -------------------------------------------------------------------------
-- CONSULTA 1: Listar todos os alunos cadastrados
-- Exibe nome, CPF e endereço, entre outros campos.
-- -------------------------------------------------------------------------

SELECT * FROM Aluno;


-- -------------------------------------------------------------------------
-- CONSULTA 2: Listar todas as matrículas cadastradas
-- -------------------------------------------------------------------------

SELECT * FROM Matricula;


-- -------------------------------------------------------------------------
-- CONSULTA 3: Cruzamento de dados (INNER JOIN)
-- Exibe as matrículas junto com os nomes e CPFs dos alunos.
-- -------------------------------------------------------------------------

SELECT
    a.nome AS 'Nome do Aluno',
    a.CPF AS 'CPF',
    m.data_matricula AS 'Data da Matrícula',
    m.status AS 'Status'
FROM Aluno a
INNER JOIN Matricula m
    ON a.idAluno = m.idAluno;

-- EXPLICAÇÃO DO INNER JOIN:
-- 1. 'Aluno a' e 'Matricula m': utilizamos apelidos para facilitar a leitura.
-- 2. 'ON a.idAluno = m.idAluno': relaciona a chave primária do aluno
--    com a chave estrangeira da matrícula.
-- 3. Somente aparecem os alunos que possuem matrículas cadastradas.


-- =========================================================================
-- 5. TESTE DE INTEGRIDADE REFERENCIAL
-- =========================================================================

-- O comando abaixo está comentado porque, se executado, gerará um erro.
-- O aluno de código 99 não existe na tabela Aluno.
-- A chave estrangeira impede a matrícula de um aluno inexistente.

-- INSERT INTO Matricula (data_matricula, status, idAluno)
-- VALUES ('2026-09-01', 'Ativo', 99);


-- =========================================================================
-- FIM DA AULA PRÁTICA
-- =========================================================================




