--Primeiro banco de dados Temporal
Create Database DB_Temporal;
Go
--Colocando o banco em utilização
Use DB_Temporal;
Go
If OBJECT_ID('dbo.InventarioCarros','U') is not null
Begin
	--ao excluir uma tabela temporal, precisamos primeiro desativar o controle de versão
	Alter table dbo.InventarioCarros SET (System_Versioning = off)
	Drop table dbo.InventarioCarros
End
Go
/*

Principais coisas:
	1- Ela precisa conter uma chave primaria
	2- Tem que conter 2 campos de datetime2 marcados com Generated always as row start/end
	3- Tem que conter a instrução Period for system_time
	4- Ela precisa conter a propriedade de Systen_versioning = on
*/

Create table InventarioCarros 
(
	Carro_ID int primary key identity(1,1) /*primeiro registro 1 e incremente de 1 em 1*/,
	Ano int,
	Marca varchar(40),
	Modelo varchar(40),
	Cor varchar(40),
	Quilometragem int,
	Verificar_disp bit not null default(1),

	--Tabela Temporal, diferencial.
	SysStarTime datetime2 generated always as row start not null,
	SysEndTime datetime2 generated always as row end not null,
	Period for system_time(SysStarTime,SysEndTime)
)
with
(
	--Providencia um nome para a tabela de histórico
	System_versioning = on (History_Table = dbo.HistoricoInventarioCarros)
)
GO
--Consultar as tabelas
Select * from InventarioCarros;
Select * from dbo.HistoricoInventarioCarros;
Go

--Preencimento das tabelas
Insert into InventarioCarros (Ano,Marca,Modelo,Cor,Quilometragem,Verificar_disp)
Values (2004,'Fiat','Uno','Branco',150000,1),
(2015,'Ford','Ka','Preto',30000,1),
(2023,'Hyundai','HB20','Prata',0,1),
(2023,'Hyundai','HB20','Branco',0,1);
Go
--a tabela histórico só vai ser populada com a alteração de algum valor.
Insert into InventarioCarros (Ano,Marca,Modelo,Cor,Quilometragem,Verificar_disp)
Values
(2023,'Honda','City','Prata',50000,1);

--Atualizar dados
Update dbo.InventarioCarros SET Verificar_disp = 0
Where Carro_ID = 1;

Update dbo.InventarioCarros SET Verificar_disp = 0
Where Carro_ID = 4;

--Consutlar Tabelas
Select * from InventarioCarros;
Select * from dbo.HistoricoInventarioCarros; --Estados anteriores apenas
Go

--Após um tempo develvem os carros
Update dbo.InventarioCarros SET Verificar_disp = 1, Quilometragem = 50000
Where Carro_ID = 1;

Update dbo.InventarioCarros SET Verificar_disp = 1, Quilometragem = 60000
Where Carro_ID = 4;

Update dbo.InventarioCarros SET Verificar_disp = 0
Where Carro_ID = 1;

--PT no UNO]
Delete from dbo.InventarioCarros where Carro_ID = 1;

--relembrar dos dias do apíce daa saudo do nosso negócio
Select * from dbo.InventarioCarros for system_time as of '2023-10-06 13:07:59' order by Carro_ID;

--Recuperar todo o historico de um veículo 
Select * from dbo.InventarioCarros  for system_time all where Carro_ID = 1 order by SysStarTime desc;

--Verificando carros que derem PT (removido do Banco)
Select Distinct 
	h.Carro_ID AS CarroID_perdaTotal
from 
	dbo.InventarioCarros t
	right join dbo.HistoricoInventarioCarros h
	on t.Carro_ID = h.Carro_ID
where
	t.Carro_ID is NULL