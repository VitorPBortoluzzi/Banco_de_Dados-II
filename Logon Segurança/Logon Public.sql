--Instancia do Vitor

Select * from Disciplina;
--Tentativa falha de cria��o por falta de permiss�o;
Insert into Disciplina (nome) Values ('Teste de insert');

/*
Mensagem 229, N�vel 14, Estado 5, Linha 5
A permiss�o INSERT foi negada no objeto 'Disciplina', banco de dados 'Seguranca_logon_1', esquema 'dbo'.

Hor�rio de conclus�o: 2023-11-03T09:04:27.0109907-03:00
*/

--Uso de fun��o autorizada
Select * from fncDisciplina(3);

--Uso de View Permitida
Select * from vw_Disciplina;