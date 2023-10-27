sp_help livro;

Select * from autor;
Select * from Livro;
Select * from LivroAutor;
Select * from editora;
select * from categoria;


 drop view vw_visao_geral;

Create view vw_visao_geral AS
select livro.isbn as 'ISBN', livro.titulo as 'Título', livro.ano as 'Ano', editora.nome as 'Editora', 
concat(autor.nome, ' (' ,autor.nacionalidade, ')') as  'Autor/Nascionalidade',categoria.tipo_categoria as 'Categoria'
from livro, editora, categoria, autor, livroautor
where livro.fk_editora = editora.id
and livro.fk_categoria = categoria.id
and livroautor.fk_autor = autor.id
and livroautor.fk_livro = livro.isbn

Select * from vw_visao_geral order by Título;