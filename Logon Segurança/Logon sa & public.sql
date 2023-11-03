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