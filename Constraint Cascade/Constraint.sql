Create database AulaRestricoes;
go

use AulaRestricoes;
-- Cadastrar pet shop
create table tbl_pessoas_pet
(
	id integer primary key identity,
	nome_cliente varchar(255) not null,
	idade_cliente integer check (idade_cliente between 18 and 85),
	nome_pet varchar(50),
	num_pets integer check(num_pets > 0),
	sex_pet char check(sex_pet in('M','F','N'))
);
go

-- testando
Insert into tbl_pessoas_pet values ('Vitor',20,'Estrelinha',1,'F');
select * from tbl_pessoas_pet;

-- Exemplo para aplicar CASCADE
create table tbl_pais(
	id_pais int primary key,
	nome_pais varchar(50) unique not null,
	cod_pais varchar(3) unique not null
);
Create table tbl_states(
	id_estados int primary key,
	nome_estado varchar(50) not null,
	cod_estado varchar(3) not null,
	id_pais int
);
go
--Criando restrição check + cascade
alter table tbl_states with check 
add constraint [FK_Estado_pais] foreign key(id_pais) references tbl_pais (id_pais)
on Delete cascade;

--Informações das tabelas;
sp_help tbl_states;
go

insert into tbl_pais values (1, 'Brasil','BR');
							(2, 'Canada','CA'),
							(3, 'Estados Unidos das Américas','USA');

insert into tbl_states values (1, 'Rio Grande do Sul','RS',1),(2, 'Acre','AC',1),(3, 'São Paulo','SP',1),(4, 'Sergipe','SE',1);
insert into tbl_states values (5, 'California','CA',3),(6, 'Alasca','AL',3),(7, 'Florida','FL',3),(8, 'Arizona','AZ',3);
insert into tbl_states values (9, 'Ontario','OA',2),(10, 'Quebec','QC',2),(11, 'Toronto','TR',2),(12, 'Nova Escocia','NS',2);

select * from tbl_pais;
select * from tbl_states;

Delete from tbl_pais where id_pais =1;

create table tbl_produto(
	id_produto int primary key,
	nome_produto varchar(50),
	categoria varchar(25)
);

create table tbl_inventarios (
	id_inventario int primary key,
	fk_id_produto int,
	quantidade int,
	min_level int,
	max_level int,
	constraint fk_inv_produto
		foreign key (fk_id_produto)
		references tbl_produto (id_produto)
		on delete cascade
		on update cascade
);

--Inserir Alguns produtos
Insert into tbl_produto values
(1,'Refrigerante','Bebidas'),
(2,'Cerveja','Bebidas'),
(3,'Tequila','Bebidas'),
(4,'Energético','Bebidas');

Insert into tbl_inventarios Values
(1,1,500,10,10000),
(2,4,50,5,50),
(3,2,1000,5,5000);

--drop table tbl_inventarios;

Select * from tbl_produto;
Select * from tbl_inventarios;

update tbl_produto set id_produto = 550 where id_produto = 1;

delete from tbl_produto where id_produto = 550;

--Remover restrição
Alter table tbl_inventarios drop constraint fk_inv_produto;

--Alterando constraint
Alter table tbl_inventarios with check
add constraint [fk_inv_produto] 
foreign key (fk_id_produto)
references tbl_produto (id_produto)
on update cascade
on delete set NULL; -- pode ser set default


--Remover o energético
Delete from tbl_produto where id_produto = 4;