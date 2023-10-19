-- Funcionarios
use DB_Temporal;
CREATE TABLE Funcionarios (
    FuncionarioID INT AUTO_INCREMENT primary key,
    Nome VARCHAR(255),
    Cargo VARCHAR(255),
    Salario DECIMAL(10, 2),
    DataInicio DATE,
    DataFim DATE
);

insert into Funcionarios (Nome,cargo,salario,dataInicio,DataFim) values ('Roberto Moraes', 'Analista', 5100.00, '2023-02-15', NULL);
update Funcionarios Set nome = 'Feijão' where FuncionarioID = 16;

Select * from funcionarios;
Select * from funcionarioshistorico;
drop table funcionarios;