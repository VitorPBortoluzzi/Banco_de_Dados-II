--Instancia do Vitor
Select * from Disciplina;
--Tentativa falha de cria��o por falta de permiss�o;
Insert into Disciplina (nome) Values ('Teste de insert');
go
/*
Mensagem 229, N�vel 14, Estado 5, Linha 5
A permiss�o INSERT foi negada no objeto 'Disciplina', banco de dados 'Seguranca_logon_1', esquema 'dbo'.

Hor�rio de conclus�o: 2023-11-03T09:04:27.0109907-03:00
*/

--Uso de fun��o autorizada
Select * from fncDisciplina(3);
go

--Uso de View Permitida
Select * from vw_Disciplina;
go

--Exec de procedure Permitida
Exec sp_Disciplina_01;


Exec sp_Disciplina_04;
go

--Exec de procedure negada;
Exec sp_Disciplina_05;
go


--Select apos negado
Select * from fncDisciplina(3);