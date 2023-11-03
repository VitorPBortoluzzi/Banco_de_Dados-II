drop database Biblioteca;
/*Cria o banco de dados - Biblioteca*/
create database Biblioteca;
/*Usa o banco de dados - Biblioteca*/
use Biblioteca;

/*Cria todas as tabelas do banco de dados  - Categoria - Autor - Editora - Livro - LivroAutor*/
CREATE TABLE [Categoria] (
  [id] int not null identity,
  [tipo_categoria] varchar(50) not null unique,
  PRIMARY KEY ([id])
);

CREATE TABLE [Autor] (
  [id] int not null identity,
  [nome] varchar(100) not null,
  [nacionalidade] varchar(50),
  PRIMARY KEY ([id])
);

CREATE TABLE [Editora] (
  [id] int not null identity,
  [nome] varchar(100) unique,
  PRIMARY KEY ([id])
);

/*existe uma peculiaridade nesta tabela o isbn � um valor inteiro, mas um int possui 4 bytes comporta somente 
valores entre -2147483648 to +2147483647, logo n�o podemos setar o isb como int. Para solucionar isto podemos
utilizar varhcar ou bigint */
CREATE TABLE [Livro] (
  [isbn] varchar (50) not null,
  [titulo] varchar (100) not null,
  [ano] int not null,
  [fk_editora] int not null,
  [fk_categoria] int not null,
  PRIMARY KEY ([isbn]),
  CONSTRAINT [FK_Livro.fk_categoria]
    FOREIGN KEY ([fk_categoria])
      REFERENCES [Categoria]([id]),
  CONSTRAINT [FK_Livro.fk_editora]
    FOREIGN KEY ([fk_editora])
      REFERENCES [Editora]([id])
);

CREATE TABLE [LivroAutor] (
  [id] int not null identity,
  [fk_autor] int not null,
  [fk_livro] varchar(50) not null,
  PRIMARY KEY ([id]),
  CONSTRAINT [FK_LivroAutor.fk_autor]
    FOREIGN KEY ([fk_autor])
      REFERENCES [Autor]([id]),
  CONSTRAINT [FK_LivroAutor.fk_livro]
    FOREIGN KEY ([fk_livro])
      REFERENCES [Livro]([isbn])
);

select * from Livro;

/*Abaixo todas as inser��es das tabela do banco de dados
Insere valores na tabela categoria
INSERT INTO table_name (column1, column2, column3, ...)
VALUES (value1, value2, value3, ...);*/

insert into categoria (tipo_categoria) values ('Literatura Juvenil');
insert into categoria (tipo_categoria) values ('Fic��o Cient�fica');
insert into categoria (tipo_categoria) values ('Humo');
insert into categoria (tipo_categoria) values ('A��o');
insert into categoria (tipo_categoria) values ('Romance');


/*Altera o atributo da tabela categoria onde o id � 3 */
update categoria
set tipo_categoria = 'Humor'
where id = 3;

/*Insere valores na tabela autor*/
insert into autor (nome) values ('J.K. Rowling');
insert into autor (nome, nacionalidade) values ('Clive Staples Lewis','Inglaterra');
insert into autor (nome, nacionalidade) values ('Affonso Solano','Brasil');
insert into autor (nome, nacionalidade) values ('Marcos Piangers','Brasil');
insert into autor (nome, nacionalidade) values ('Ciro Botelho - Tiririca','Brasil');
insert into autor (nome, nacionalidade) values ('Bianca M�l','Brasil');

/*Insere valores na tabela editora*/
insert into editora (nome) values ('Rocco');
insert into editora (nome) values ('Wmf Martins Fontes');
insert into editora (nome) values ('Casa da Palavra');
insert into editora (nome) values ('Belas Letras');
insert into editora (nome) values ('Matrix');

/*Insere valores na tabela de livros*/
insert into livro values('8532511015','Harry Potter e A Pedra Filosofal','2000',1,1);
insert into livro values('9788578270698','As Crônicas de N�rnia','2009',2,1);
insert into livro values('9788577343348','O Espadachim de Carv�o','2013',3,2);
insert into livro values('9788581742458','O Papai � Pop','2015',4,3);
insert into livro values('9788582302026','Pior Que T� N�o Fica','2015',5,3);
insert into livro values('9788577345670','Garota Desdobr�vel','2015',3,1);
insert into livro values('8532512062','Harry Potter e o Prisioneiro de Azkaban','2000',1,1);

/*Insere valores na tabela livroautor - Rela��o de cada livro com seu respectivo autor*/
insert into livroautor (fk_livro, fk_autor) values('8532511015',1);
insert into livroautor (fk_livro, fk_autor) values('9788578270698',2);
insert into livroautor (fk_livro, fk_autor) values('9788577343348',3);
insert into livroautor (fk_livro, fk_autor) values('9788581742458',4);
insert into livroautor (fk_livro, fk_autor) values('9788582302026',5);
insert into livroautor (fk_livro, fk_autor) values('9788577345670',6);
insert into livroautor (fk_livro, fk_autor) values('8532512062',1);

/*Exemplo de inser��o errada, aqui vinculamos 
o livro Harry Potter e o Prisioneiro de Azkabam ao autor Clive Staples*/
insert into livroautor (fk_livro, fk_autor) values('8532512062',2);
/*Exemplo de como removemos o registro que estava errado.*/
delete from livroautor where fk_livro = '8532512062' and fk_autor = 2;




