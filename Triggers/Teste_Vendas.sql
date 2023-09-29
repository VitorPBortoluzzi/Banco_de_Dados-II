--Atividade
CREATE DATABASE Mercado;

USE Mercado;

CREATE TABLE Tb_Saldos
(
	PRODUTO VARCHAR (10),
	SALDO_INICIAL NUMERIC(10),
	SALDO_FINAL NUMERIC(10),
	DATA_ULTIMA_MOV DATETIME
);

CREATE TABLE tb_Vendas
(
	ID_VENDAS INT,
	PRODUTO VARCHAR(10),
	QUANTIDADE INT,
	DATA DATETIME
);

CREATE SEQUENCE SEQ_TV_VENDAS
	AS NUMERIC
	START WITH 1
	INCREMENT BY 1;

CREATE TABLE TB_HISTORICO_VENDAS
(
	PRODUTO VARCHAR(10),
	QUANTIDADE INT,
	DATA_VENAS DATETIME
);

INSERT INTO Tb_Saldos VALUES ('PRODUTO A', 0 , 100,GETDATE());

SELECT * FROM Tb_Saldos;

CREATE TRIGGER tg_Alter_Saldo
on tb_vendas
Instead of INSERT
AS
BEGIN
	DECLARE		@Quantidade int,
				@Data DATETIME,
				@Produto VARCHAR(10)
	SELECT @Data = DATA,@Quantidade = Quantidade,@Produto = Produto
	From inserted

	UPDATE Tb_Saldos
	SET SALDO_FINAL = SALDO_FINAL - @Quantidade, DATA_ULTIMA_MOV = @Data
	WHERE PRODUTO = @Produto

	INSERT into TB_HISTORICO_VENDAS (PRODUTO, QUANTIDADE,DATA_VENAS)
	VALUES (@Produto, @Quantidade,@Data)
END;
GO

drop Trigger tg_Alter_Saldo;
--Foram vendidas 2 Unidades Produto A

Insert into tb_Vendas(ID_Vendas,Produto,Quantidade,DATA) 
VALUES (NEXT Value for seq_tv_vendas,'Produto A',5,GETDATE());

select * from tb_Vendas;

Select * from Tb_Saldos;