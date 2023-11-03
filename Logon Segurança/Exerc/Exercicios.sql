/*
Crie 2 usuarios para o banco biblioteca
-Usuario para fazer Crud
-Usuario para visualizar, sem acesso a tabela editor
*/
--Juca-Crud
USE [master]
GO
CREATE LOGIN [Juca-CRUD] WITH PASSWORD=N'123', 
DEFAULT_DATABASE=[Biblioteca], 
CHECK_EXPIRATION=OFF, 
CHECK_POLICY=OFF
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [Juca-CRUD]
GO
USE [Biblioteca]
GO
CREATE USER [Juca-CRUD] FOR LOGIN [Juca-CRUD]
GO

