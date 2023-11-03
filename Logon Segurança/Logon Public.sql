--Instancia do Vitor

Select * from Disciplina;
--Tentativa falha de criação por falta de permissão;
Insert into Disciplina (nome) Values ('Teste de insert');

/*
Mensagem 229, Nível 14, Estado 5, Linha 5
A permissão INSERT foi negada no objeto 'Disciplina', banco de dados 'Seguranca_logon_1', esquema 'dbo'.

Horário de conclusão: 2023-11-03T09:04:27.0109907-03:00
*/

--Uso de função autorizada
Select * from fncDisciplina(3);

--Uso de View Permitida
Select * from vw_Disciplina;