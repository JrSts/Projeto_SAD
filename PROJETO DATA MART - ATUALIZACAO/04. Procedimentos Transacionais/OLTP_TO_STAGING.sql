USE PROJETO_SAD

----------------------------------------------------------------------------------------------------------------------
-- CARGA OLTP PARA STAGING

--------------------------							--------------------------
--------------------------			CLIENTE			--------------------------
--------------------------							--------------------------

CREATE PROCEDURE SP_CLIENTE_OLTP_STG @DATA_CARGA DATETIME AS
DECLARE @COD_CLIENTE INT, @NOME VARCHAR(100) ,@APELIDO VARCHAR(100), @DATA_NASCIMENTO DATETIME,
		@TELEFONE VARCHAR(11), @ENDERECO VARCHAR(200), @CPF VARCHAR(11), @SENHA VARCHAR(10)
DECLARE C_CURSOR CURSOR FOR SELECT COD_CLIENTE, NOME, APELIDO, DATA_NASCIMENTO, TELEFONE, ENDERECO, CPF, SENHA FROM OLTP.TB_CLIENTE
OPEN C_CURSOR
FETCH C_CURSOR INTO @COD_CLIENTE, @NOME, @APELIDO, @DATA_NASCIMENTO, @TELEFONE, @ENDERECO, @CPF, @SENHA
WHILE @@FETCH_STATUS = 0
	BEGIN
		IF(EXISTS(SELECT DATA_CARGA FROM STG.AUX_CLIENTE WHERE COD_CLIENTE = @COD_CLIENTE AND DATA_CARGA = @DATA_CARGA))
			DELETE FROM STG.AUX_CLIENTE WHERE DATA_CARGA = @DATA_CARGA
		INSERT INTO STG.AUX_CLIENTE VALUES (@DATA_CARGA, @COD_CLIENTE, @NOME, @APELIDO, @DATA_NASCIMENTO, @TELEFONE, @ENDERECO, @CPF, @SENHA)
		FETCH C_CURSOR INTO @COD_CLIENTE, @NOME, @APELIDO, @DATA_NASCIMENTO, @TELEFONE, @ENDERECO, @CPF, @SENHA
	END
CLOSE C_CURSOR
DEALLOCATE C_CURSOR

TRUNCATE TABLE DW.DIM_CLIENTE
EXEC SP_CLIENTE_OLTP_STG '20180824'
EXEC SP_CLIENTE_STG_DW '20180824'
SELECT * FROM STG.VIO_CLIENTE
UPDATE OLTP.TB_CLIENTE SET ENDERECO = 'RUA C' WHERE COD_CLIENTE = 3


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
		IF(EXISTS(SELECT DATA_CARGA FROM STG.AUX_FUNCIONARIO WHERE COD_FUNCIONARIO = @COD_FUNCIONARIO AND DATA_CARGA = @DATA_CARGA))
			DELETE FROM STG.AUX_FUNCIONARIO WHERE DATA_CARGA = @DATA_CARGA
		INSERT INTO STG.AUX_FUNCIONARIO VALUES (@DATA_CARGA, @COD_FUNCIONARIO, @NOME, @DATA_NASCIMENTO, @TELEFONE, @ENDERECO,
											    @SALARIO, @CPF, @SENHA)
		FETCH C_CURSOR INTO @COD_FUNCIONARIO, @NOME, @DATA_NASCIMENTO,@TELEFONE, @ENDERECO, @SALARIO, @CPF, @SENHA	
	END
CLOSE C_CURSOR
DEALLOCATE C_CURSOR

EXEC SP_FUNCIONARIO_OLTP_STG '20180824'
EXEC SP_FUNCIONARIO_STG_DW '20180824'
SELECT * FROM DW.DIM_FUNCIONARIO
UPDATE OLTP.TB_FUNCIONARIO SET NOME = 'JO�O NETO', SALARIO = 1200 WHERE COD_FUNCIONARIO = 10

--------------------------								--------------------------
--------------------------			CATEGORIA			--------------------------
--------------------------								--------------------------

CREATE PROCEDURE SP_CATEGORIA_OLTP_STG @DATA_CARGA DATETIME AS
DECLARE @COD_CATEGORIA INT, @CATEGORIA VARCHAR(100)

DECLARE C_CURSOR CURSOR FOR SELECT COD_CATEGORIA, CATEGORIA FROM OLTP.TB_CATEGORIA
OPEN C_CURSOR
FETCH C_CURSOR INTO @COD_CATEGORIA, @CATEGORIA
WHILE @@FETCH_STATUS = 0
	BEGIN
		IF(EXISTS(SELECT DATA_CARGA FROM STG.AUX_CATEGORIA WHERE COD_CATEGORIA = @COD_CATEGORIA AND DATA_CARGA = @DATA_CARGA))
			DELETE FROM STG.AUX_CATEGORIA WHERE DATA_CARGA = @DATA_CARGA
		INSERT INTO STG.AUX_CATEGORIA VALUES (@DATA_CARGA, @COD_CATEGORIA, @CATEGORIA)
		FETCH C_CURSOR INTO @COD_CATEGORIA, @CATEGORIA
	END
CLOSE C_CURSOR
DEALLOCATE C_CURSOR

EXEC SP_CATEGORIA_OLTP_STG '20180824'
EXEC SP_CATEGORIA_STG_DW '20180824'
SELECT * FROM DW.DIM_CATEGORIA

--------------------------							--------------------------
--------------------------			DIVIDA			--------------------------
--------------------------							--------------------------

CREATE PROCEDURE SP_DIVIDA_OLTP_STG @DATA_CARGA DATETIME AS
DECLARE @COD_DIVIDA INT, @COD_CLIENTE INT, @COD_FUNCIONARIO INT, @COD_CATEGORIA INT, @DATA_DIVIDA DATETIME, @VALOR NUMERIC(10,2),
		@STATUS_DIVIDA VARCHAR(20)

DECLARE C_CURSOR CURSOR FOR SELECT COD_DIVIDA, COD_CLIENTE, COD_FUNCIONARIO, COD_CATEGORIA, DATA, VALOR, STATUS_DIVIDA FROM OLTP.TB_DIVIDA
OPEN C_CURSOR
FETCH C_CURSOR INTO @COD_DIVIDA, @COD_CLIENTE, @COD_FUNCIONARIO, @COD_CATEGORIA, @DATA_DIVIDA, @VALOR, @STATUS_DIVIDA
WHILE @@FETCH_STATUS = 0
	BEGIN
		IF(EXISTS(SELECT DATA_CARGA FROM STG.AUX_DIVIDA WHERE COD_DIVIDA = @COD_DIVIDA AND DATA_CARGA = @DATA_CARGA))
			DELETE FROM STG.AUX_DIVIDA WHERE DATA_CARGA = @DATA_CARGA
		INSERT INTO STG.AUX_DIVIDA VALUES (@DATA_CARGA, @COD_DIVIDA, @COD_CLIENTE, @COD_FUNCIONARIO, @COD_CATEGORIA, @DATA_DIVIDA, @VALOR, @STATUS_DIVIDA)
		FETCH C_CURSOR INTO @COD_DIVIDA, @COD_CLIENTE, @COD_FUNCIONARIO, @COD_CATEGORIA, @DATA_DIVIDA, @VALOR, @STATUS_DIVIDA
	END
CLOSE C_CURSOR
DEALLOCATE C_CURSOR

TRUNCATE TABLE STG.AUX_DIVIDA
EXEC SP_DIVIDA_OLTP_STG '20180824'
SELECT * FROM STG.AUX_DIVIDA
EXEC SP_DIVIDA_STG_DW '20180824'
SELECT * FROM DW.FATO_DIVIDA

--------------------------								--------------------------
--------------------------			PAGAMENTO			--------------------------
--------------------------								--------------------------

CREATE PROCEDURE SP_PAGAMENTO_OLTP_STG @DATA_CARGA DATETIME AS
DECLARE @COD_PAGAMENTO INT, @COD_CLIENTE INT, @COD_FUNCIONARIO INT, @DATA_PAGAMENTO DATETIME, @VALOR NUMERIC(10,2)

DECLARE C_CURSOR CURSOR FOR SELECT COD_PAGAMENTO, COD_CLIENTE, COD_FUNCIONARIO, DATA, VALOR FROM OLTP.TB_PAGAMENTO
OPEN C_CURSOR
FETCH C_CURSOR INTO @COD_PAGAMENTO, @COD_CLIENTE, @COD_FUNCIONARIO, @DATA_PAGAMENTO, @VALOR
WHILE @@FETCH_STATUS = 0
	BEGIN
		IF(EXISTS(SELECT DATA_CARGA FROM STG.AUX_PAGAMENTO WHERE COD_PAGAMENTO = @COD_PAGAMENTO AND DATA_CARGA = @DATA_CARGA))
			DELETE FROM STG.AUX_PAGAMENTO WHERE DATA_CARGA = @DATA_CARGA
		INSERT INTO STG.AUX_PAGAMENTO VALUES (@DATA_CARGA, @COD_PAGAMENTO, @COD_CLIENTE, @COD_FUNCIONARIO, @DATA_PAGAMENTO, @VALOR)
		FETCH C_CURSOR INTO @COD_PAGAMENTO, @COD_CLIENTE, @COD_FUNCIONARIO, @DATA_PAGAMENTO, @VALOR
	END
CLOSE C_CURSOR
DEALLOCATE C_CURSOR


TRUNCATE TABLE STG.AUX_PAGAMENTO
EXEC SP_PAGAMENTO_OLTP_STG '20180824'
SELECT * FROM STG.AUX_PAGAMENTO
EXEC SP_PAGAMENTO_STG_DW '20180824'
SELECT * FROM DW.FATO_PAGAMENTO

--------------------------								--------------------------
--------------------------		CARGA OLTP STGING		--------------------------
--------------------------								--------------------------

CREATE PROCEDURE SP_CARGA_OLTP_STG @DATA_CARGA DATETIME AS
EXEC SP_CLIENTE_OLTP_STG @DATA_CARGA
EXEC SP_FUNCIONARIO_OLTP_STG @DATA_CARGA
EXEC SP_CATEGORIA_OLTP_STG @DATA_CARGA
EXEC SP_DIVIDA_OLTP_STG @DATA_CARGA
EXEC SP_PAGAMENTO_OLTP_STG @DATA_CARGA

EXEC SP_CARGA_OLTP_STG '20180824'
EXEC SP_CARGA_DW_STG '20180824'