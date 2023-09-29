/*1.Crie um trigger que impeça a inserção de livros com o mesmo Titulo na tabela Livro.
*/

CREATE TRIGGER TGR_Duplicado
on dbo.Livro 
INSTEAD OF INSERT 
AS
	BEGIN
		DECLARE		@nome VARCHAR(100),
					@ISBN VARCHAR(100),
					@Ano int,
					@Editora int,
					@Categoria int;

		SELECT	@nome = titulo,
				@ISBN = isbn ,
				@Ano = ano ,
				@Editora = fk_editora ,
				@Categoria = fk_categoria From inserted;

		Print 'Nome: ' + @nome;
		Print 'ISBN: ' + @ISBN;
		if(Exists(Select * From Livro where titulo = (@nome)))
			Print 'Livro já inserido';
		Else 
			Begin	
				INSERT INTO Livro VALUES ((@ISBN),(@nome),(@Ano),(@Editora),(@Categoria));
				Print 'Livro ' + @nome + ' Cadastrado com sucesso';
			End
	END;

--Ativando o Trigger
Select * from Livro;
INSERT INTO Livro VALUES ('123456','Aprender a Contar','2022',1,4);
delete from Livro where isbn = '123456';
--Remover o Trigger Criado:
DROP TRIGGER TGR_Duplicado;



/*
2. Crie um trigger que atualize automaticamente o ano de publicação na tabela Livro
para o ano atual quando um novo livro é inserido.*/

Create Trigger att_YEAR
on dbo.Livro
instead of Insert
as
Begin

	DECLARE		@nome VARCHAR(100),
					@ISBN VARCHAR(100),
					@Ano int,
					@Editora int,
					@Categoria int;

		SELECT	@nome = titulo,
				@ISBN = isbn ,
				@Ano = ano ,
				@Editora = fk_editora ,
				@Categoria = fk_categoria From inserted;

	if(Exists(Select * From Livro where isbn = (@ISBN)))
		begin
			Print 'Livro já inserido, atualizando data';
			UPDATE Livro
			SET ano = YEAR(GETDATE())
			where ISBN = @ISBN;
		end
	Else 
		Begin	
			INSERT INTO Livro VALUES ((@ISBN),(@nome),(@Ano),(@Editora),(@Categoria));
			Print 'Livro ' + @nome + ' Cadastrado com sucesso';
		End
End;

drop trigger att_YEAR;
delete from Livro where isbn = '2312151123';

INSERT INTO Livro VALUES ('2312151123','Ola','2023',1,4);
Select * from Livro;

/*
4. Crie um trigger que exclua automaticamente registros da tabela LivroAutor quando o
livro correspondente é excluído da tabela Livro.*/

Create Trigger del_Livro
on dbo.Livro
after Delete
as
Begin

	DECLARE		@nome VARCHAR(100),
				@ISBN VARCHAR(100),
				@Ano int,
				@Editora int,
				@Categoria int;

		SELECT	@nome = titulo,
				@ISBN = isbn ,
				@Ano = ano ,
				@Editora = fk_editora ,
				@Categoria = fk_categoria From inserted;

	if(Exists(Select * From Livro where isbn = (@ISBN)))
		begin
			Print 'Livro já inserido, atualizando data';
			UPDATE Livro
			SET ano = YEAR(GETDATE())
			where ISBN = @ISBN;
		end
	Else 
		Begin	
			INSERT INTO Livro VALUES ((@ISBN),(@nome),(@Ano),(@Editora),(@Categoria));
			Print 'Livro ' + @nome + ' Cadastrado com sucesso';
		End
End;

Select * from LivroAutor;
/*
5. Crie um trigger que atualize o número total de livros em uma categoria específica na
tabela Categoria sempre que um novo livro é inserido nessa categoria.
6. Crie um trigger que restrinja a exclusão de categorias na tabela Categoria se houver
livros associados a essa categoria.
7. Crie um trigger que registre em uma tabela de auditoria sempre que um livro for
atualizado na tabela Livro.
8. Crie um trigger que calcule automaticamente o número total de livros escritos por um
autor na tabela Autor sempre que um novo livro é associado a esse autor na tabela
LivroAutor.
9. Crie um trigger que restrinja a atualização do ISBN na tabela Livro para impedir que
ele seja alterado.
10. Crie um trigger que limite o número de livros escritos por um autor na tabela
LivroAutor para um máximo de 5 livros por autor.
11. Crie um trigger que atualize automaticamente o campo total_livros na tabela
Categoria sempre que um novo livro daquela categoria for inserido na tabela Livro.
12. Crie um trigger que, quando um livro for excluído da tabela Livro, verifique se há
outros livros escritos pelo mesmo autor e, se não, remova automaticamente o autor
da tabela Autor.
13. Crie um trigger que limite o número de livros em uma categoria específica na tabela
Categoria para um máximo de 100 livros e não permita mais inserções além desse
limite.
14. Crie um trigger que atualize automaticamente o campo nacionalidade na tabela
Autor para 'Desconhecida' sempre que um autor for excluído da tabela Autor
15. Crie um trigger que registre automaticamente todas as exclusões de livros na tabela
LogExclusaoLivros com detalhes sobre o livro excluído, data e hora.
16. Crie um trigger que, quando um livro for atualizado na tabela Livro, verifique se o
novo título contém a palavra "proibido" e, se sim, reverta o título anterior.
17. Crie um trigger que, quando um livro for inserido na tabela Livro, verifique se a
editora está na lista de editoras proibidas e, se estiver, impeça a inserção.
18. Crie um trigger que atualize automaticamente o campo total_livros_escritos na
tabela Autor sempre que um livro for associado a esse autor na tabela LivroAutor.
19. Crie um trigger que registre automaticamente todas as atualizações de livros na
tabela LogAtualizacaoLivros com detalhes sobre o livro atualizado, data e hora.*/