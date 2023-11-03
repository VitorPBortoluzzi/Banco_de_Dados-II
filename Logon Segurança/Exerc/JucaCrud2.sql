USE [master]
GO
CREATE LOGIN [JucaS] WITH PASSWORD=N'123', DEFAULT_DATABASE=[Biblioteca], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
use [master];
GO
USE [Biblioteca]
GO
CREATE USER [JucaS] FOR LOGIN [JucaS]
GO
USE [Biblioteca]
GO
ALTER ROLE [db_datareader] ADD MEMBER [JucaS]
GO


Deny select on dbo.Editora to JucaS;