CREATE DATABASE PROJETO_SAD

USE PROJETO_SAD

CREATE SCHEMA OLTP

----------------------------------------------------------------------------------------------------------------------
-- Ambiente Operacional

DROP TABLE STG.VIO_FUNCIONARIO
SELECT * FROM STG.

CREATE TABLE OLTP.TB_CLIENTE (
	COD_CLIENTE INT NOT NULL,
	NOME VARCHAR(100) NOT NULL,
	APELIDO VARCHAR(100) NOT NULL,
	DATA_NASCIMENTO DATETIME NULL,
	TELEFONE VARCHAR(11) NULL,
	ENDERECO VARCHAR(200) NULL,
	CPF VARCHAR(11) NULL,
	SENHA VARCHAR(10) NOT NULL
)

CREATE TABLE OLTP.TB_FUNCIONARIO (
	COD_FUNCIONARIO INT NOT NULL,
	NOME VARCHAR(100) NOT NULL,
	DATA_NASCIMENTO DATETIME NOT NULL,
	TELEFONE VARCHAR(10) NOT NULL,
	ENDERECO VARCHAR(200) NOT NULL,
	SALARIO NUMERIC(10,2) NOT NULL,
	CPF VARCHAR(11) NOT NULL,
	SENHA VARCHAR(10) NOT NULL
)

CREATE TABLE OLTP.TB_CATEGORIA (
	COD_CATEGORIA INT NOT NULL,
	CATEGORIA VARCHAR(50) NOT NULL,
	VALOR NUMERIC(10,2) NOT NULL
)

CREATE TABLE OLTP.TB_DIVIDA (
	COD_DIVIDA INT NOT NULL,
	COD_CLIENTE INT NOT NULL,
	COD_FUNCIONARIO INT NOT NULL,
	COD_CATEGORIA INT NOT NULL,
	DATA DATETIME NOT NULL,
	VALOR NUMERIC(10,2) NOT NULL
)

CREATE TABLE OLTP.TB_PAGAMENTO (
	COD_PAGAMENTO INT NOT NULL,
	COD_CLIENTE INT NOT NULL,
	COD_FUNCIONARIO INT NOT NULL,
	DATA DATETIME NOT NULL,
	VALOR NUMERIC(10,2) NOT NULL
)



----------------------------------------------------------------------------------------------------------------------
-- Area Staging

CREATE SCHEMA STG

CREATE TABLE STG.AUX_CLIENTE (
	DATA_CARGA DATETIME NOT NULL,
	COD_CLIENTE INT NULL,
	NOME VARCHAR(100) NULL,
	APELIDO VARCHAR(100) NULL,
	DATA_NASCIMENTO DATETIME NULL,
	TELEFONE VARCHAR(11) NULL,
	ENDERECO VARCHAR(200) NULL,
	CPF VARCHAR(11) NULL,
	SENHA VARCHAR(10) NULL
)

CREATE TABLE STG.VIO_CLIENTE (
	DATA_CARGA DATETIME NOT NULL,
	COD_CLIENTE INT NULL,
	NOME VARCHAR(100) NULL,
	APELIDO VARCHAR(100) NULL,
	DATA_NASCIMENTO DATETIME NULL,
	TELEFONE VARCHAR(11) NULL,
	ENDERECO VARCHAR(200) NULL,
	CPF VARCHAR(11) NULL,
	SENHA VARCHAR(10) NULL,
	DATA_ERRO DATETIME NOT NULL,
	MSG_ERRO VARCHAR(100) NOT NULL
)

CREATE TABLE STG.AUX_FUNCIONARIO (
	DATA_CARGA DATETIME NOT NULL,
	COD_FUNCIONARIO INT NULL,
	NOME VARCHAR(100) NULL,
	DATA_NASCIMENTO DATETIME NULL,
	TELEFONE VARCHAR(10) NULL,
	ENDERECO VARCHAR(200) NULL,
	SALARIO NUMERIC(10,2) NULL,
	CPF VARCHAR(11) NULL,
	SENHA VARCHAR(10) NULL
)

CREATE TABLE STG.VIO_FUNCIONARIO (
	DATA_CARGA DATETIME NOT NULL,
	COD_FUNCIONARIO INT NULL,
	NOME VARCHAR(100) NULL,
	DATA_NASCIMENTO DATETIME NULL,
	TELEFONE VARCHAR(10) NULL,
	ENDERECO VARCHAR(200) NULL,
	SALARIO NUMERIC(10,2) NULL,
	CPF VARCHAR(11) NULL,
	SENHA VARCHAR(10) NULL,
	DATA_ERRO DATETIME NOT NULL,
	MSG_ERRO VARCHAR(100) NOT NULL
)

CREATE TABLE STG.AUX_DIVIDA (
	DATA_CARGA DATETIME NOT NULL,
	COD_DIVIDA INT NULL,
	COD_CLIENTE INT NOT NULL,
	COD_FUNCIONARIO INT NOT NULL,
	COD_CATEGORIA INT NOT NULL,
	DATA DATETIME NOT NULL,
	VALOR NUMERIC(10,2) NOT NULL
)

CREATE TABLE STG.VIO_DIVIDA (
	DATA_CARGA DATETIME NOT NULL,
	COD_DIVIDA INT NULL,
	COD_CLIENTE INT NULL,
	COD_FUNCIONARIO INT NULL,
	COD_CATEGORIA INT NULL,
	DATA DATETIME NULL,
	VALOR NUMERIC(10,2) NULL,
	DATA_ERRO DATETIME NOT NULL,
	MSG_ERRO VARCHAR(100) NOT NULL
)

CREATE TABLE STG.AUX_CATEGORIA (
	DATA_CARGA INT NOT NULL,
	COD_CATEGORIA INT NULL,
	CATEGORIA VARCHAR(100),
	VALOR NUMERIC(10,2) NULL
)

CREATE TABLE STG.VIO_CATEGORIA (
	DATA_CARGA INT NOT NULL,
	COD_CATEGORIA INT NULL,
	CATEGORIA VARCHAR(100),
	VALOR NUMERIC(10,2) NULL,
	DATA_ERRO DATETIME NOT NULL,
	MSG_ERRO VARCHAR(100) NOT NULL
)

CREATE TABLE STG.AUX_PAGAMENTO (
	DATA_CARGA DATETIME NOT NULL,
	COD_PAGAMENTO INT NULL,
	COD_CLIENTE INT NULL,
	COD_FUNCIONARIO INT NULL,
	DATA DATETIME NULL,
	VALOR NUMERIC(10,2) NULL
)

CREATE TABLE STG.VIO_PAGAMENTO (
	DATA_CARGA DATETIME NOT NULL,
	COD_PAGAMENTO INT NULL,
	COD_CLIENTE INT NULL,
	COD_FUNCIONARIO INT NULL,
	DATA DATETIME NULL,
	VALOR NUMERIC(10,2) NULL,
	DATA_ERRO DATETIME NOT NULL,
	MSG_ERRO VARCHAR(100) NOT NULL
)

----------------------------------------------------------------------------------------------------------------------
-- Area DW

CREATE SCHEMA DW

CREATE TABLE DW.DIM_TEMPO (
	ID_TEMPO INT IDENTITY(1,1) NOT NULL,    
	NIVEL VARCHAR(8) NOT NULL,			
	DATA DATETIME NULL,
	DIA SMALLINT NULL,						
	DIASEMANA VARCHAR(25) NULL,			
	DIAUTIL CHAR(3) NULL,
	FERIADO CHAR(3) NULL,					
	FIMSEMANA CHAR(3) NULL,				
	QUINZENA SMALLINT NULL,
	MES SMALLINT NULL,						
	NOMEMES VARCHAR(20) NULL,			
	FIMMES CHAR(3) NULL,
	TRIMESTRE SMALLINT NULL,				
	NOMETRIMESTRE VARCHAR(20) NULL,		
	SEMESTRE SMALLINT NULL,
	NOMESEMESTRE VARCHAR(20) NULL,			
	ANO SMALLINT NOT NULL
)

ALTER TABLE DIM_TEMPO ADD CONSTRAINT PK_DIM_TEMPO PRIMARY KEY (Id_Tempo)

CREATE TABLE DW.DIM_CLIENTE (
	ID_CLIENTE INT IDENTITY NOT NULL,
	COD_CLIENTE INT NOT NULL,
	NOME VARCHAR(100) NOT NULL,
	APELIDO VARCHAR(100) NOT NULL,
	ENDERECO VARCHAR(200) NOT NULL,
	TELEFONE VARCHAR(10) NOT NULL,
	CPF VARCHAR(11) NOT NULL,
	SENHA VARCHAR(10) NOT NULL
)

CREATE TABLE DW.DIM_FUNCIONARIO (
	ID_FUNCIONARIO INT IDENTITY NOT NULL,
	COD_FUNCIONARIO INT NOT NULL,
	NOME VARCHAR(100) NOT NULL,
	DATA_NASCIMENTO DATETIME NOT NULL,
	TELEFONE VARCHAR(10) NOT NULL,
	ENDERECO VARCHAR(200) NOT NULL,
	CPF VARCHAR(11) NOT NULL,
	SENHA VARCHAR(10) NOT NULL,
	SALARIO NUMERIC(10,2) NOT NULL, -- TIPO 2
	DATA_INICIO DATETIME NOT NULL,
	DATA_FIM DATETIME NULL,
	FLAG_CORRENTE VARCHAR(3) NOT NULL CHECK (FLAG_CORRENTE = 'SIM' OR FLAG_CORRENTE = 'N�O')
)

CREATE TABLE DW_DIM_CATEGORIA (
	ID_CATEGORIA INT IDENTITY NOT NULL,
	COD_CATEGORIA INT NOT NULL,
	CATEGORIA VARCHAR(50) NOT NULL,
	VALOR NUMERIC(10,2) NOT NULL
)

CREATE TABLE DW_FATO_DIVIDA (
	ID_DIVIDA INT IDENTITY NOT NULL,
	ID_CLIENTE INT NOT NULL,
	ID_FUNCIONARIO INT NOT NULL,
	ID_CATEGORIA INT NOT NULL,
	ID_DATA_DIVIDA DATETIME NOT NULL,
	ID_DATA_POSSIVEL_PAGAMENTO DATETIME NOT NULL,
	VALOR NUMERIC(10,2) NOT NULL,
	QUANTIDADE INT NOT NULL
)

CREATE TABLE DW_FATO_PAGAMENTO (
	ID_PAGAMENTO INT IDENTITY NOT NULL,
	ID_CLIENTE INT NOT NULL,
	ID_FUNCIONARIO INT NOT NULL,
	ID_DATA_PAGAMENTO DATETIME NOT NULL,
	VALOR NUMERIC(10,2) NOT NULL,
	QUANTIDADE INT NOT NULL
)

----------------------------------------------------------------------------------------------------------------------
-- CARGA OLTP PARA STAGING

--------------------------							--------------------------
--------------------------			CLIENTE			--------------------------
--------------------------							--------------------------

CREATE PROCEDURE SP_CLIENTE_OLTP_STG @DATA_CARGA DATETIME AS
DECLARE @COD_CLIENTE INT, @NOME VARCHAR(100) ,@APELIDO VARCHAR(100) ,@DATA_NASCIMENTO DATETIME,
		@TELEFONE VARCHAR(11), @ENDERECO VARCHAR(200), @CPF VARCHAR(11), @SENHA VARCHAR(10)

DECLARE C_CURSOR CURSOR FOR SELECT COD_CLIENTE, NOME,APELIDO, DATA_NASCIMENTO,
		TELEFONE, ENDERECO, CPF, SENHA FROM OLTP.TB_CLIENTE
OPEN C_CURSOR
FETCH C_CURSOR INTO @COD_CLIENTE, @NOME,@APELIDO, @DATA_NASCIMENTO,
		@TELEFONE, @ENDERECO, @CPF, @SENHA
WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO STG.AUX_CLIENTE VALUES (@DATA_CARGA, @COD_CLIENTE, @NOME, @APELIDO, @DATA_NASCIMENTO, @TELEFONE, @ENDERECO,
											@CPF, @SENHA)
		IF @COD_CLIENTE IS NULL OR @NOME IS NULL OR @APELIDO IS NULL OR  @DATA_NASCIMENTO IS NULL OR @TELEFONE IS NULL OR  
		   @ENDERECO IS NULL OR @CPF IS NULL OR  @SENHA IS NULL
			BEGIN
				INSERT INTO STG.VIO_CLIENTE VALUES(@DATA_CARGA, @COD_CLIENTE, @NOME, @APELIDO, @DATA_NASCIMENTO, @TELEFONE, @ENDERECO,
												   @CPF, @SENHA, GETDATE(), 'CAMPOS SEM PREENCHER')
			END
	END
CLOSE C_CURSOR
DEALLOCATE C_CURSOR

--------------------------								--------------------------
--------------------------			FUNCIONARIO			--------------------------
--------------------------								--------------------------

CREATE PROCEDURE SP_FUNCIONARIO_OLTP_STG @DATA_CARGA DATETIME AS
DECLARE @COD_FUNCIONARIO INT, @NOME VARCHAR(100), @DATA_NASCIMENTO DATETIME, @TELEFONE VARCHAR(11),
		@ENDERECO VARCHAR(200),@SALARIO NUMERIC(10,2), @CPF VARCHAR(11), @SENHA VARCHAR(10)

DECLARE C_CURSOR CURSOR FOR SELECT COD_FUNCIONARIO, NOME, DATA_NASCIMENTO,
		TELEFONE, ENDERECO, SALARIO, CPF, SENHA FROM OLTP.TB_FUNCIONARIO
OPEN C_CURSOR
FETCH C_CURSOR INTO @COD_FUNCIONARIO, @NOME, @DATA_NASCIMENTO,@TELEFONE, @ENDERECO, @SALARIO, @CPF, @SENHA
WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO STG.AUX_FUNCIONARIO VALUES (@DATA_CARGA, @COD_FUNCIONARIO, @NOME, @DATA_NASCIMENTO, @TELEFONE, @ENDERECO,
											    @SALARIO, @CPF, @SENHA)
		IF @COD_FUNCIONARIO IS NULL OR @NOME IS NULL OR  @DATA_NASCIMENTO IS NULL OR @TELEFONE IS NULL OR  
		   @ENDERECO IS NULL OR @SALARIO IS NULL OR @CPF IS NULL OR  @SENHA IS NULL
			BEGIN
				INSERT INTO STG.VIO_FUNCIONARIO VALUES(@DATA_CARGA, @COD_FUNCIONARIO, @NOME, @DATA_NASCIMENTO, @TELEFONE, @ENDERECO,
												       @SALARIO, @CPF, @SENHA, GETDATE(), 'CAMPOS SEM PREENCHER')
			END
	END
CLOSE C_CURSOR
DEALLOCATE C_CURSOR

--------------------------								--------------------------
--------------------------			CATEGORIA			--------------------------
--------------------------								--------------------------

CREATE PROCEDURE SP_CATEGORIA_OLTP_STG @DATA_CARGA DATETIME AS
DECLARE @COD_CATEGORIA INT, @CATEGORIA VARCHAR(100), @VALOR NUMERIC(10,2)

DECLARE C_CURSOR CURSOR FOR SELECT COD_CATEGORIA, CATEGORIA, VALOR FROM OLTP.TB_CATEGORIA
OPEN C_CURSOR
FETCH C_CURSOR INTO @COD_CAETGORIA, @CATEGORIA, @VALOR
WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO STG.AUX_CATEGORIA VALUES (@DATA_CARGA, @COD_CATEGORIA, @CATEGORIA, @VALOR)
		IF @COD_CATEGORIA IS NULL OR @CATEGORIA IS NULL OR  @VALOR IS NULL
			BEGIN
				INSERT INTO STG.VIO_CATEGORIA VALUES(@DATA_CARGA, @COD_CATEGORIA, @CATEGORIA, @VALOR, GETDATE(), 'CAMPOS SEM PREENCHER')
			END
	END
CLOSE C_CURSOR
DEALLOCATE C_CURSOR


----------------------------------------------------------------------------------------------------------------------
-- CARGA STAGING PARA DW

--------------------------							--------------------------
--------------------------			TEMPO			--------------------------
--------------------------							--------------------------

CREATE PROCEDURE SP_DIM_TEMPO (@DATA_INICIAL DATETIME, @DATA_FINAL DATETIME) AS
SET LANGUAGE BRAZILIAN
DECLARE	
	@NIVEL VARCHAR(8),				@AUX DATETIME ,				@SEMESTRE SMALLINT, 
	@NOMESEMESTRE VARCHAR(20),		@TRIMESTRE SMALLINT,		@NOMEMES VARCHAR(20), 
	@NOMETRIMESTRE VARCHAR(20),		@DIASEMANA VARCHAR(25),		@FIMSEMANA CHAR(3),
	@DIAUTIL CHAR(3),				@QUINZENA SMALLINT,			@FIMMES CHAR(3),
	@FERIADO CHAR(3),				@ID_TEMPO INT

	IF(@DATA_INICIAL >= @DATA_FINAL)
		BEGIN
			SELECT @AUX = @DATA_FINAL, @DATA_FINAL = @DATA_INICIAL, @DATA_INICIAL = @AUX
		END
	ELSE
	BEGIN 
		WHILE(@DATA_INICIAL <= @DATA_FINAL)
		BEGIN
		IF(EXISTS(SELECT DATA FROM DW.DIM_TEMPO WHERE DATA = @DATA_INICIAL))
			BEGIN
				PRINT 'J� EXISTE ESTA DATA: ' + CONVERT(VARCHAR, @DATA_INICIAL)
			END -- FIM DO IF
		ELSE
			BEGIN
				IF(NOT EXISTS (SELECT ANO FROM DW.DIM_TEMPO WHERE ANO = YEAR(@DATA_INICIAL)))
					BEGIN
						SET @NIVEL = 'ANO'
						INSERT INTO DW.DIM_TEMPO VALUES (@NIVEL, @DATA_INICIAL,NULL,NULL,NULL,NULL,NULL,NULL,
												NULL, NULL, NULL,NULL,NULL,NULL,NULL,YEAR(@DATA_INICIAL))
					END -- FIM DO IF

				IF(NOT EXISTS (SELECT MES FROM DW.DIM_TEMPO WHERE MES = MONTH(@DATA_INICIAL)))
					BEGIN
						SELECT @NIVEL = 'MES', @NOMEMES = DATENAME(MM, @DATA_INICIAL)
						IF(MONTH(@DATA_INICIAL) < 7)
							BEGIN
								SET @SEMESTRE = 1
								SET @NOMESEMESTRE = '1� SEMESTRE/' + CONVERT(VARCHAR, YEAR(@DATA_INICIAL))
							END --END DO IF

						ELSE 
							BEGIN
								SET @SEMESTRE = 2
								SET @NOMESEMESTRE = '2� SEMESTRE/' + CONVERT(VARCHAR, YEAR(@DATA_INICIAL))
							END --END DO ELSE

						IF(MONTH(@DATA_INICIAL) < 4)
							BEGIN 
								SET @TRIMESTRE = 1
								SET @NOMETRIMESTRE = '1� TRIMESTRE/' + CONVERT(VARCHAR, YEAR(@DATA_INICIAL))
							END -- FIM DO IF

						ELSE
						IF(MONTH(@DATA_INICIAL) < 7)
							BEGIN 
								SET @TRIMESTRE = 2
								SET @NOMETRIMESTRE = '2� TRIMESTRE/' + CONVERT(VARCHAR, YEAR(@DATA_INICIAL))
							END -- FIM DO IF

						ELSE
						IF(MONTH(@DATA_INICIAL) < 10)
							BEGIN 
								SET @TRIMESTRE = 3
								SET @NOMETRIMESTRE = '3� TRIMESTRE/' + CONVERT(VARCHAR, YEAR(@DATA_INICIAL))
							END -- FIM DO IF

						ELSE
						IF(MONTH(@DATA_INICIAL) < 13)
							BEGIN 
								SET @TRIMESTRE = 4
								SET @NOMETRIMESTRE = '4� TRIMESTRE/' + CONVERT(VARCHAR, YEAR(@DATA_INICIAL))
							END -- FIM DO IF

						INSERT INTO DW.DIM_TEMPO VALUES (@NIVEL, @DATA_INICIAL,NULL,NULL,NULL,NULL,NULL,NULL,MONTH(@DATA_INICIAL),
														  @NOMEMES,NULL,@TRIMESTRE,@NOMETRIMESTRE,@SEMESTRE,@NOMESEMESTRE,YEAR(@DATA_INICIAL))
					END -- FIM DO IF

					SET @NIVEL = 'DIA'
					SET @DIASEMANA = DATENAME (DW, @DATA_INICIAL)
					SET @FERIADO = NULL;

				IF (@DIASEMANA = 'SABADO' OR @DIASEMANA = 'DOMINGO')
					SELECT @FIMSEMANA = 'SIM', @DIAUTIL = 'NAO'
				ELSE
					SELECT @FIMSEMANA = 'NAO', @DIAUTIL = 'SIM'

				IF(DATEPART(DD, @DATA_INICIAL + 1) = 1)
					SET @FIMMES = 'SIM'
				ELSE
					SET @FIMMES = 'NAO'

				IF(DATEPART(DD, @DATA_INICIAL) <= 15)
					SET @QUINZENA = 1
				ELSE
					SET @QUINZENA = 2

				INSERT INTO DW.DIM_TEMPO VALUES (@NIVEL, @DATA_INICIAL,DAY(@DATA_INICIAL),@DIASEMANA,@DIAUTIL,NULL,@FIMSEMANA,@QUINZENA,MONTH(@DATA_INICIAL),
											@NOMEMES,@FIMMES,@TRIMESTRE,@NOMETRIMESTRE,@SEMESTRE,@NOMESEMESTRE,YEAR(@DATA_INICIAL))
			END
			SET @DATA_INICIAL = DATEADD (DD, 1, @DATA_INICIAL)
		END --FIM DO WHILE
	END -- FIM DO ELSE


----------------------------------------------------------------------------------------------------------------------
-- CARGA DOS AGREGADOS