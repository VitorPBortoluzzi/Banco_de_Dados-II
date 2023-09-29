use EMPRESA;

--questão 11 Prova
--==========================
Select * from dbo.FUNCIONARIO;

go
Create trigger tr_duplicado
ON FUNCIONARIO
instead of insert
as
begin
	Declare @nome varchar(50),@sobrenome varchar(50),@datanasc date;
	Select @nome = Pnome, @sobrenome = Unome, @datanasc = Datanasc from inserted;
	--if(exists(Select 1 ...) or (Select * ...)
	if(exists(Select Pnome,Unome,Datanasc from dbo.FUNCIONARIO where Pnome = (@nome) and Unome = (@sobrenome) and Datanasc = (@datanasc)))
		begin
			Print('Funcionario já cadastrado');
			RAISERROR('Já existe Funcionario com mesmo nome,sobrenome e datanasc',16,1);
		end
	else
		insert into FUNCIONARIO Select * from inserted;
end
go

INSERT INTO FUNCIONARIO VALUES ( 'Jorge', 'E', 'Brito', '1', '1937-11-10', 'Rua do Horto, 35, São Paulo, SP', 'M', 55000, NULL , 1 );
INSERT INTO FUNCIONARIO VALUES ( 'Lucas', 'E', 'Brito', '2', '1937-11-10', 'Rua do Horto, 35, São Paulo, SP', 'M', 55000, NULL , 1 );

delete from FUNCIONARIO where cpf = '2';

drop trigger tr_duplicado;

Select * from FUNCIONARIO order by Pnome;
--===========================

--Questão 12
--===========================
Create table LogFunc(
	LogId int Primary key Identity(1,1),
	tipo varchar(6),
	datahora datetime,
	resumo varchar(255),
	Pnome varchar(50),
	Unome varchar(50),
	Datanasc date,
	Endereco varchar(255),
	Sexo char(1),
	Salario decimal(10,2),
	CPF char(11)
	);
go


go
Create trigger tr_logFunc
on FUNCIONARIO
after insert
as
begin
	Insert into LogFunc (tipo,datahora,Pnome,Unome,Datanasc,Endereco,Sexo,Salario,CPF) 
	select 'Insert',GETDATE(),Pnome,Unome,Datanasc,Endereco,Sexo,Salario,Cpf from inserted;
end
go

Create trigger tr_logFuncDelete
on FUNCIONARIO
after delete
as
begin
	Insert into LogFunc (tipo,datahora,Pnome,Unome,Datanasc,Endereco,Sexo,Salario,CPF) 
	select 'Delete',GETDATE(),Pnome,Unome,Datanasc,Endereco,Sexo,Salario,Cpf from deleted;
end
go

go
Create trigger tr_logFunc_Update
on FUNCIONARIO
after Update
as
begin
	Insert into LogFunc (tipo,datahora,Pnome,Unome,Datanasc,Endereco,Sexo,Salario,CPF) 
	select 'Update',GETDATE(),Pnome,Unome,Datanasc,Endereco,Sexo,Salario,Cpf from inserted;
end
go


INSERT INTO FUNCIONARIO VALUES ( 'Jorge', 'E', 'Brito', '1', '1937-11-10', 'Rua do Horto, 35, São Paulo, SP', 'M', 55000, NULL , 1 );
INSERT INTO FUNCIONARIO VALUES ( 'Lucas', 'E', 'Brito', '2', '1937-11-10', 'Rua do Horto, 35, São Paulo, SP', 'M', 55000, NULL , 1 );

Select * from LogFunc;

delete from FUNCIONARIO where cpf = '2';

update FUNCIONARIO
set Cpf = '20391293' where Cpf = '2';

delete from FUNCIONARIO where cpf = '20391293';

--===================

--Questão 13
drop trigger demissao;
go
Create trigger demissao
on Funcionario
instead of delete
as
begin
	declare @cpf varchar(11);
	Select @cpf = cpf from deleted;

	Update FUNCIONARIO set Cpf_supervisor = NULL where Cpf_supervisor = @cpf;
	Update DEPARTAMENTO Set Cpf_gerente = NULL where Cpf_gerente = @cpf;
	Delete from Dependente where Fcpf = @cpf;
	Delete from TRABALHA_EM where Fcpf = @cpf;
	Delete from FUNCIONARIO where Cpf = @cpf;
	--Delete from Dependente where Fcpf in (Select Cpf from deleted);
	--Remover funcionario dos projetos
end
go

Delete from FUNCIONARIO where cpf = '33344555587';

--=============
--Questao 14
--Procedure
go
Create procedure sp_adiciona_funcionario
(
	@cpf varchar(11),
	@Pnome varchar(50),
	@Unome varchar(50),
	@Datanasc date,
	@Endereco varchar(255),
	@Sexo char(1),
	@Salario decimal(10,2),
	@Supervisor char(11) = NULL,
	@Dnr int
)
as
begin
	insert into FUNCIONARIO (Cpf,Pnome,Unome,Datanasc,Endereco,Sexo,Salario,Cpf_supervisor,Dnr)
	values (@cpf,@Pnome,@Unome,@Datanasc,@Endereco,@Sexo,@Salario,@Supervisor,@Dnr)
	Print('Funcionario inserido');
end
go

exec sp_adiciona_funcionario 
	@Cpf = '12345678910',
	@Pnome = 'João',
	@Unome = 'Silva',
	@Datanasc = '1990-01-01',
	@Endereco = 'Rua ABC, 103',
	@Sexo = 'M',
	@Salario = 3000.00,
	@Dnr = 5;

--=============
--Questao 15
--Procedure
Create procedure sp_Aumenta_salario(
	@Porcentagem decimal(5,2),
	@Dnome varchar(15)
)
As
begin
	Update FUNCIONARIO set Salario = Salario + Salario*(@Porcentagem/100)
	where Dnr in (Select Dnumero From DEPARTAMENTO where Dnome = @Dnome)
end

exec sp_Aumenta_salario
	@Porcentagem = 10,
	@Dnome = 'Pesquisa';