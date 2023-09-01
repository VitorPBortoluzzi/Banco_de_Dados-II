Use Biblioteca;

DECLARE @nome_Autor VARCHAR(100);
SELECT @nome_Autor;
SET @nome_Autor = 'Juca da Silva';/*N�o Salva no Banco, apenas existem em tempo de Execu��o*/
SELECT @nome_Autor AS "Nome do Autor";/*AS = Aliases --> Muda nome de exibi��o da coluna*/
--@@@@@@@@@@@@@@@@@@
DECLARE @titulo_livro VARCHAR(100);
SELECT @titulo_livro = Biblioteca.dbo.Livro.titulo
FROM Biblioteca.dbo.Livro
WHERE Livro.isbn = '9788577343348';
SELECT @titulo_livro As 'Titulo do Livro';
--@@@@@@@@@@@@@@@@@@

--##################
--Exemplo com C�lculo--
--Atribuindo valores � uma vari�vel atrav�s de um select--
--Declara��o Variaveis
DECLARE @ano_publicado INT,@ano_atual INT,@nome VARCHAR(100)
SET @ano_atual = 2023;

SELECT @ano_publicado=ano,@nome=titulo
FROM Livro
WHERE isbn = '9788577343348';

--C�lculo e Exibir--
SELECT @nome As 'Nome Livro',
@ano_atual-@ano_publicado AS 'Idade do Livro';
--##################



--@@@@@@@@@@@@@@@@@@
--CONVERS�O DE DADOS--

--===================================
--CAST (express�o AS novo_tipo_dados
SELECT 'O livro ' + titulo + ' � do ano ' +
CAST(ano AS VARCHAR(10)) AS Ano
FROM Livro
WHERE isbn = '9788577343348';
--===================================
/*
CONVERT (novo_tipo_dados, express�o, estilo)
*estilo � usado normalemnte para converter datas ou trabalhar com float/real
*/
SELECT 'O livro ' + titulo + ' � do ano ' +
CONVERT(VARCHAR(10), ano) AS 'Informa��o de Lan�amento'
FROM Livro
WHERE isbn = '9788577343348';
--===================================

Select * from Biblioteca.dbo.Autor;

Alter Table Biblioteca.dbo.Autor 
ADD data_nascimento date;

Update Biblioteca.dbo.Autor 
SET Autor.data_nascimento = '1965-07-31'
WHERE id =1;
--===========================================
SELECT 'A data de nascimento � : ' +
CONVERT(VARCHAR(50),data_nascimento)
FROM Autor
WHERE id = 1;

--===========================================Britanico/Frnac�s formato
SELECT 'A data de nascimento � : ' +
CONVERT(VARCHAR(50),data_nascimento,103)
FROM Autor
WHERE id = 1;
--===========================================
--Tabela de formato Data
--https://learn.microsoft.com/pt-br/sql/t-sql/functions/cast-and-convert-transact-sql?redirectedfrom=MSDN&view=sql-server-ver16
--===========================================

--if(condi��o){
--	Begin
--		Bloco de Comando
--	End;
--}

--Se n tiver nenhum autor com nome juca da silva, cadastrar.

Select * from Autor;

insert into autor (nome, nacionalidade,data_nascimento) values ('Juca da Silva','Brasil','1964-07-23');

--=====================

DECLARE @nome_Autor1 VARCHAR(100) = 'Juca da Silva'
if not exists (Select * from Autor Where autor.nome like @nome_Autor1)
	insert into autor (nome, nacionalidade,data_nascimento) values ('Juca da Silva','Brasil','1964-07-23');
else
	Update Autor
	Set Autor.data_nascimento = '2001-01-01'
	where Autor.nome = @nome_Autor1;



--=======================

SET @valor = 0

WHILE @valor<10
	BEGIN
		PRINT 'N�mero: ' + CAST(@valor AS VARCHAR(2))
		SET @valor = @valor+1
	END


--====================

--Usando while mude todas as datas de nascimento dos autores
select count(*) from Autor;
select * from autor;
select MAX(id) from Autor;

DECLARE @valor INT
SET @valor = 0
While @valor<(select MAX(id) from Autor)
	Begin
		Update Autor
		SET Autor.data_nascimento = '2001-01-01'
		where autor.id = @valor;
		SET @valor = @valor+1
	END

--===================================================================

--TRIGGER
--Usando AFTER
CREATE TRIGGER TGR_PRIMEIRO
on dbo.Editora
AFTER INSERT
AS
PRINT 'OLA COMO VAI';

--Ativando o Trigger
Select * from Editora;
INSERT INTO Editora (nome) VALUES ('Editora do Juca');

--Remover o Trigger Criado:
--DROP TRIGGER TGR_PRIMEIRO;

--==================================================================

select * from editora;

CREATE TRIGGER TGR_TESTE_I
on dbo.Editora 
AFTER INSERT 
AS
DELETE FROM dbo.Editora where Nome like '%Editora do Juca%';

--Ativando o Trigger
Select * from Editora;
INSERT INTO Editora (nome) VALUES ('Editora do Juca');

--Remover o Trigger Criado:
--DROP TRIGGER TGR_TESTE_I;

--==================================================================

--USANDO INSTEAD OF
CREATE TRIGGER TGR_Duplicado
on dbo.Editora 
INSTEAD OF INSERT 
AS
	BEGIN
		DECLARE @nome VARCHAR(100);
		SELECT @nome = nome FROM inserted;
		Print 'Nome: ' + @nome;
		if(Exists(Select * From Editora where nome like (@nome)))
			Print 'Nome j� inserido';
		Else 
			Begin	
				INSERT INTO Editora (nome) VALUES (@nome);
				Print @nome + ' Cadastrada com sucesso';
			End
	END;

--Ativando o Trigger
Select * from Editora;
INSERT INTO Editora (nome) VALUES ('E123');

--Remover o Trigger Criado:
DROP TRIGGER TGR_Duplicado;

--==================================================================