-- Criar duas database pare teste de Logon
--Database1
if EXISTS(Select name from sys.databases Where name = 'Seguranca_logon_1')
	drop database Seguranca_logon_1
Create database Seguranca_logon_1

if EXISTS(Select name from sys.databases Where name = 'Seguranca_logon_2')
	drop database Seguranca_logon_2
Create database Seguranca_logon_2

Use Seguranca_logon_1;
--Role Public
USE [master]
GO
CREATE LOGIN [Vitor] WITH PASSWORD=N'Gol25demais', 
DEFAULT_DATABASE=[Seguranca_logon_1], 
CHECK_EXPIRATION=OFF, 
CHECK_POLICY=OFF
GO
USE [Seguranca_logon_1]
GO
CREATE USER [Vitor] FOR LOGIN [Vitor]
GO

--+Roles
/*USE [master]
GO
CREATE LOGIN [Vitor] WITH PASSWORD=N'Gol25demais', 
DEFAULT_DATABASE=[master],
CHECK_EXPIRATION=OFF, 
CHECK_POLICY=OFF
GO
USE [Seguranca_logon_1]
GO
CREATE USER [Vitor] FOR LOGIN [Vitor]
GO
USE [Seguranca_logon_1]
GO
ALTER ROLE [db_datareader] ADD MEMBER [Vitor]
GO
USE [Seguranca_logon_1]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [Vitor]
GO
USE [Seguranca_logon_1]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [Vitor]
GO*/

--Query para verificar informação de todos os logins criados & senhas criptografadas
Select name ,
	create_date,
	modify_date,
	LOGINPROPERTY(name,'DaysUntilExpiration') DaysUntilExpiration,
	LOGINPROPERTY(name,'PasswordLastSetTime') PasswordLastSetTime,
	LOGINPROPERTY(name,'IsExpired') IsExpired,
	LOGINPROPERTY(name,'IsMustChange') IsMustChange,*
from sys.sql_logins
Go

--Tentativa de criação de tabela como "Vitor"
Create table Disciplina(
	id int identity,
	data datetime default (Getdate()),
	nome varchar(100)
)
Go

--Resultado
/*
Mensagem 262, Nível 14, Estado 1, Linha 1
Permissão CREATE TABLE negada no banco de dados 'Seguranca_logon_1'.

Horário de conclusão: 2023-11-03T08:43:27.3625083-03:00
*/

--Verificar como Sa = Sys.admin instancias de conexão
Select * from sys.sysprocesses where loginame = 'Vitor';
Go


--Como sa preenchendo tabelas
Insert into Disciplina (nome) Select 'Nome Preenchido'
Go 10


--Conceder acesso ao Vitor a:
--Grant Select Apenas Select
Grant Select on Disciplina to Vitor;
Go
--Criar função
Create function fncDisciplina (@id int)
returns Table
as
return
	(Select * from Disciplina where id= @id);
Go

Select * from fncDisciplina(3);
--Conceder acesso a função;
Grant select on fncDisciplina to Vitor;
Go

--Fazendo uso de View;
Create view vw_Disciplina
AS
Select data,nome from Disciplina;
Go

--Conceder visão Ao vitor das View's do banco
Grant select on vw_Disciplina to Vitor;
Go

Create procedure sp_Disciplina_01
as
select * from disciplina;
Go
--Dando acesso ao procedure
--Dar acesso á Execução, e não ao Select do procedure
Grant Execute on sp_Disciplina_01 to Vitor;
go

Create procedure sp_Disciplina_02
as
select * from disciplina;
Go

Create procedure sp_Disciplina_03
as
select * from disciplina;
Go

Create procedure sp_Disciplina_04
as
select * from disciplina;
Go

-- Dar acesso a execução de todos os procedures
Grant Execute to Vitor;
go

Create procedure sp_Disciplina_05
as
select * from disciplina;
Go
--Não quero que vitor tenha acesso ao procedure 05
Deny execute on sp_Disciplina_05 to Vitor;
go

--Negar select 
Deny select to Vitor;
go

Use Seguranca_logon_2;

go
Create table Instituicao
(
	id int identity,
	nome varchar(255),
	cod int 
);
Go

Insert into instituicao (nome,cod) 
select 'Nome instituicao', 123
Go 19

Select * from Instituicao
go


Use Seguranca_logon_1;
go

Create procedure sp_disciplina_06
as begin
	Select * from Disciplina
	Select * from Seguranca_logon_2..Instituicao
end
go

Exec sp_Disciplina_06;


--Query
SELECT	state_desc, prmsn.permission_name as [Permission], sp.type_desc, sp.name,
		grantor_principal.name AS [Grantor], grantee_principal.name as [Grantee]
FROM sys.all_objects AS sp
	INNER JOIN sys.database_permissions AS prmsn 
	ON prmsn.major_id = sp.object_id AND prmsn.minor_id=0 AND prmsn.class = 1
	INNER JOIN sys.database_principals AS grantor_principal
	ON grantor_principal.principal_id = prmsn.grantor_principal_id
	INNER JOIN sys.database_principals AS grantee_principal 
	ON grantee_principal.principal_id = prmsn.grantee_principal_id
WHERE grantee_principal.name = 'Vitor'

Drop user Vitor;