/*======================================================================================================
================================Feito com pesquisas no chat GPT,========================================
================================Não pesquisa direta das perguntas,======================================
========================================================================================================*/





-- drop table FuncionariosHistorico;
-- Anotação: Fazerem em SQL SERVER na próxima;
-- Anotação: Fazerem em SQL SERVER na próxima;
-- Anotação: Fazerem em SQL SERVER na próxima;
-- Anotação: Fazerem em SQL SERVER na próxima;
-- Anotação: Fazerem em SQL SERVER na próxima;
-- 1.a)Crie uma tabela temporal para manter um histórico dos Funcionários.
/*==========================================================================================
================================Começo Tabela Temporal======================================
===========================================================================================*/
CREATE TABLE Funcionarios (
    FuncionarioID INT AUTO_INCREMENT primary key,
    Nome VARCHAR(255),
    Cargo VARCHAR(255),
    Salario DECIMAL(10, 2),
    DataInicio DATE,
    DataFim DATE
);

Create table FuncionariosHistorico (
	HistoricoID int auto_increment primary key,
    Alteração varchar(6),
    data_hora_alteracao TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FuncionarioID int,
    Nome varchar(255),
    Cargo varchar(255),
    Salario Decimal(10,2),
    DataInicio Datetime,
    DataFim Datetime null
);


Delimiter $$
Create Trigger Temporal_Historico_insert
AFTER insert on Funcionarios
for each row
begin
	insert into FuncionariosHistorico(Alteração,Nome,Cargo,Salario,DataInicio,DataFim) values ('Insert',New.Nome,New.Cargo,New.Salario,now(),NULL);
end;
$$
delimiter ;

Delimiter $$
Create Trigger Temporal_Historico_delete
before delete on Funcionarios
for each row
begin
	insert into FuncionariosHistorico(Alteração,Nome,Cargo,Salario,DataInicio,DataFim) values ('Delete',Old.Nome,Old.Cargo,Old.Salario,Old.DataInicio,now());
end;
$$
delimiter ;



Delimiter $$
Create Trigger Temporal_Historico_alter
before update on Funcionarios
for each row
begin
IF NEW.Nome <> OLD.Nome THEN
        INSERT INTO FuncionariosHistorico (Alteração, Nome, Cargo, Salario, DataInicio, DataFim)
        VALUES ('Update', NEW.Nome, OLD.Cargo, OLD.Salario, Old.DataInicio, NULL);
    END IF;

    -- Verifica se o cargo foi alterado
    IF NEW.Cargo <> OLD.Cargo THEN
        INSERT INTO FuncionariosHistorico (Alteração, Nome, Cargo, Salario, DataInicio, DataFim)
        VALUES ('Update', OLD.Nome, NEW.Cargo, OLD.Salario, Old.DataInicio, NULL);
    END IF;

    -- Verifica se o salário foi alterado
    IF NEW.Salario <> OLD.Salario THEN
        INSERT INTO FuncionariosHistorico (Alteração, Nome, Cargo, Salario, DataInicio, DataFim)
        VALUES ('Update', OLD.Nome, OLD.Cargo, NEW.Salario, Old.DataInicio, NULL);
    END IF;

    -- Verifica se a DataInicio foi alterada
    IF NEW.DataInicio <> OLD.DataInicio THEN
        INSERT INTO FuncionariosHistorico (Alteração, Nome, Cargo, Salario, DataInicio, DataFim)
        VALUES ('Update', OLD.Nome, OLD.Cargo, OLD.Salario, New.DataInicio, NULL);
    END IF;
    
    -- Verifica se a DataFim foi alterada
    IF NEW.DataFim <> OLD.DataFim THEN
        INSERT INTO FuncionariosHistorico (Alteração, Nome, Cargo, Salario, DataInicio, DataFim)
        VALUES ('Update', OLD.Nome, OLD.Cargo, OLD.Salario, Old.DataInicio, NEW.DataFim);
    END IF;
end;
$$
delimiter ;

Select * from funcionarioshistorico;

INSERT INTO Funcionarios (Nome, Cargo, Salario, DataInicio, DataFim)
VALUES
    ('João Silva', 'Analista', 5000.00, '2022-01-01', NULL),
    ('Maria Oliveira', 'Gerente', 7000.00, '2022-02-01', NULL),
    ('Pedro Castro', 'Desenvolvedor', 6000.00, '2022-02-10', NULL),
    ('Fernanda Lima', 'Analista', 5200.00, '2022-04-15', NULL),
    ('Lucas Andrade', 'Desenvolvedor Sênior', 6500.00, '2022-05-01', NULL),
    ('Camila Rocha', 'Desenvolvedor', 5800.00, '2022-06-20', NULL),
    ('Rafael Souza', 'Analista Sênior', 5600.00, '2022-08-01', NULL),
    ('Aline Costa', 'Gerente', 7100.00, '2022-09-10', NULL),
    ('Bruno Ribeiro', 'Analista', 5050.00, '2022-10-05', NULL),
    ('Amanda Gomes', 'Desenvolvedor', 5750.00, '2022-10-15', NULL),
    ('Carlos Peixoto', 'Desenvolvedor Sênior', 6550.00, '2022-11-01', NULL),
    ('Daniela Lopes', 'Analista', 5000.00, '2022-11-20', NULL),
    ('Eduardo Pires', 'Gerente', 7200.00, '2023-01-05', NULL),
    ('Gabriela Neves', 'Desenvolvedor', 5900.00, '2023-02-01', NULL),
    ('Roberto Moraes', 'Analista', 5100.00, '2023-02-15', NULL);

/*==========================================================================================
================================Fim Tabela Temporal=========================================
===========================================================================================*/

-- 1.b)Insira um novo funcionário na tabela Funcionarios.
insert into Funcionarios (Nome,cargo,salario,dataInicio,DataFim) values ('Paulo João', 'Estágiario', 1500.00, '2023-10-19', NULL);

-- 1.c)Promova 4 vezes o funcionários inserido para um novo cargo com um aumento salarial. Verifique como o histórico é mantido na tabela FuncionariosHistorico.
update Funcionarios Set cargo = 'Junior', Salario = 2300.0 where Nome like 'Paulo João'; 
update Funcionarios Set cargo = 'Analista', Salario = 5000.0 where Nome like 'Paulo João'; 
update Funcionarios Set cargo = 'Desenvolvedor', Salario = 5900.0 where Nome like 'Paulo João'; 
update Funcionarios Set cargo = 'Desenvolvedor Sênior', Salario = 6550.0 where Nome like 'Paulo João'; 

-- 1.d)Liste todos os cargos anteriores de um funcionário específico, juntamente com os períodos em que ele ocupou esses cargos.
-- Anotação: Fazerem SQL SERVER na próxima;
 select HistoricoId,nome,cargo,data_hora_alteracao as 'HoraAlterado',DataInicio as 'Data entrada na Empresa' from funcionarioshistorico where Nome like 'Paulo João';
 select * FROM FuncionariosHistorico;
-- 1.e)Determine o salário de um funcionário em uma data específica no passado.
insert into Funcionarios (Nome,cargo,salario,dataInicio,DataFim) values ('Vitor Bortoluzzi', 'Teste', 5500.00, '2003-02-20', NULL);
update Funcionarios Set cargo = 'Desenvolvedor', Salario = 50000.0 where Nome like 'Vitor Bortoluzzi'; 
Select salario from funcionarioshistorico where nome like 'Vitor Bortoluzzi' and '2013-10-19' between DataInicio And ifnull(DataFim, Now());

-- 1.f)Liste todos os funcionários que já ocuparam o cargo de "Gerente" em algum momento.
Select Nome,Cargo from funcionarioshistorico where Cargo like 'Gerente';

-- 1.g)Identifique as mudanças salariais de todos os funcionários no último ano.
Select Nome,salario from funcionarioshistorico where '2022-10-19' between DataInicio And ifnull(DataFim, Now());

-- 1.h) Desative o versionamento de sistema da tabela Funcionários e verifique o que acontece com a tabela FuncionariosHistorico.
drop trigger Temporal_Historico_alter;
drop trigger Temporal_Historico_insert;
drop trigger Temporal_Historico_delete;

Select * from funcionarioshistorico;
insert into Funcionarios (Nome,cargo,salario,dataInicio,DataFim) values ('Vitor 0', 'Teste2', 0.00, '0001-01-01', NULL);
Select * from funcionarioshistorico;

-- 1.i)
Select Nome,salario,data_hora_alteracao from funcionarioshistorico where Nome = 'João Silva' and DataInicio = '2022-01-01' And ifnull(DataFim, Now());
update Funcionarios Set Salario = '70000' where Nome like 'João Silva';

-- 1.j)A empresa está conduzindo uma revisão e deseja saber quantos cargos um funcionário específico ocupou nos últimos 5 anos. Forneça essa informação usando a tabela temporal
SELECT Nome, Cargo, MIN(data_hora_alteracao) AS data_hora_alteracao
FROM FuncionariosHistorico
WHERE Nome = 'João Silva'
  AND data_hora_alteracao BETWEEN '2015-01-01' AND IFNULL(DataFim, NOW())
GROUP BY Nome, Cargo;


/*======================================================================================================
========================================================================================================
================================Feito em ultima hora,===================================================
================================Feito em mySQL =========================================================
========================================================================================================*/