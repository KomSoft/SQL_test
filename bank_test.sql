create database bank_test;
show databases;
show tables;
-- drop database bank_test;

use bank_test;

create table Bank ( bank_id int AUTO_INCREMENT, 
name varchar(20) NOT NULL,
address varchar(30) NOT NULL, 
PRIMARY KEY (bank_id) 
);

create table Customer ( customer_id int AUTO_INCREMENT, 
full_name varchar(20) NOT NULL,
address varchar(30) NOT NULL, 
bank_id int NOT NULL, 
PRIMARY KEY (customer_id), 
foreign key (bank_id) REFERENCES Bank (bank_id) 
);

create table Operation (operation_id int AUTO_INCREMENT, 
op_type ENUM ('deb', 'cre') NOT NULL,
PRIMARY KEY (operation_id) 
);

create table Amount (action_id int AUTO_INCREMENT,
operation_id int NOT NULL,
bank_id int NOT NULL,
customer_id int NOT NULL,
amount decimal(8,2) NOT NULL,
PRIMARY KEY (action_id),
FOREIGN KEY (operation_id) REFERENCES Operation (operation_id),
FOREIGN KEY (bank_id) REFERENCES Bank (bank_id),
FOREIGN KEY (customer_id) REFERENCES Customer (customer_id)
); 

create table Date (date date NOT NULL,
action_id int NOT NULL,
FOREIGN KEY (action_id) REFERENCES Amount (action_id)
);

INSERT INTO Bank (name, address) VALUES ('Alfa', 'Kyiv'),
('Delta', 'Kyiv, District Sol'),
('PUMB', 'Lviv'),
('Privat', 'Dnipro')
;

SELECT * FROM Bank;

INSERT INTO Customer (full_name, address, bank_id) VALUES 
('Ivan Petrov', 'Kyiv, Peremohy str', 1),
('Ivan Sidorov', 'Kyiv, Ushakova str', 4),
('Vovan Sidorenko', 'Lviv, Zabodailo str', 2),
('Sidor Sirko', 'Dnipro, Naberejna 15', 2),
('Petro Ivanko', 'Dnipro, Vokzalna str', 3),
('Simon Petlura', 'Lviv, Centralna str', 2),
('Ihor Moskalenko', 'Kyiv, Krajny str', 3),
('Dima Vovchenko', 'Tarny, Pobedy str', 4),
('Sima Shlomov', 'Berdichev', 1),
('Vasil Popaduk', 'Berezan', 4),
('Petro Ivanko', 'Dnipro, Vokzalna str', 1),
('Simon Petlura', 'Lviv, Centralna str', 1),
('Simon Petlura', 'Lviv, Centralna str', 4)
;
SELECT * FROM Customer;

INSERT INTO Operation VALUES (1, 'deb'), (2, 'cre');

SELECT * FROM Operation;

INSERT INTO Amount (operation_id, bank_id, customer_id, amount) VALUES  
(1, 1, 3, 38.45),
(2, 2, 4, 15.35),
(2, 3, 5, 18.56),
(1, 4, 6, 23.15),
(1, 3, 1, 12546),
(1, 2, 2, 2568),
(1, 1, 10, 185),
(2, 4, 8, 4586),
(2, 4, 8, 14),
(1, 1, 8, 56),
(1, 1, 8, 45),
(2, 2, 3, 38),
(1, 2, 2, 47),
(2, 3, 2, 23),
(1, 3, 2, 5),
(1, 3, 4, 16),
(2, 3, 5, 35),
(2, 1, 3, 845),
(2, 2, 2, 785),
(1, 2, 1, 3785),
(2, 1, 9, 155),
(2, 4, 9, 685),
(1, 4, 4, 155),
(2, 1, 5, 465),
(1, 3, 8, 22)
;

describe bank;
describe Customer;
describe Operation;
describe Amount;
describe Date;

SELECT * FROM Amount;

INSERT INTO Date VALUES
('2017-03-21', 1),
('2017-03-21', 2),
('2017-03-21', 3),
('2017-03-24', 4),
('2017-03-25', 5),
('2017-04-02', 6),
('2017-04-02', 7),
('2017-04-04', 8),
('2017-04-04', 9),
('2017-04-04', 10),
('2017-04-04', 11),
('2017-04-04', 12),
('2017-04-10', 13),
('2017-04-11', 14),
('2017-04-21', 15),
('2017-04-21', 16),
('2017-04-22', 17),
('2017-04-22', 18),
('2017-04-23', 19),
('2017-04-25', 20),
('2017-04-25', 21),
('2017-04-26', 22),
('2017-04-26', 23),
('2017-04-27', 24),
('2017-04-27', 25)
;

SELECT * FROM Date;

-- количество банков
SELECT COUNT(name) FROM Bank ;

-- количество клиентов банка А
SELECT DISTINCT COUNT(full_name) FROM Customer 
WHERE Customer.bank_id IN (SELECT Bank.bank_id FROM Bank WHERE name='Privat');

-- Количество клиентов банка А - через JOIN
SELECT count(full_name) FROM Customer JOIN Bank ON Customer.bank_id = Bank.bank_id
WHERE Bank.name = 'Privat';

-- список клиентов банка А
SELECT full_name FROM Customer 
WHERE Customer.bank_id IN (SELECT Bank.bank_id FROM Bank WHERE name='Privat') ORDER BY full_name;

-- список клиентов банка А через JOIN
SELECT full_name FROM Customer JOIN Bank ON Customer.bank_id = Bank.bank_id
WHERE Bank.name = 'Privat' ORDER BY full_name;

-- список банков John-а
SELECT DISTINCT name FROM Bank 
WHERE Bank.bank_id IN (SELECT Customer.bank_id FROM Customer WHERE full_name='Simon Petlura');

-- список банков John-а через JOIN
SELECT DISTINCT name FROM Bank JOIN Customer ON Bank.bank_id = Customer.bank_id 
WHERE Customer.full_name = 'Simon Petlura';

-- список всех операций банка А
SELECT Amount.bank_id AS 'Банк', Amount.operation_id AS 'Тип операции', amount AS 'Сумма' FROM Amount 
WHERE bank_id=(SELECT bank_id FROM Bank WHERE name='Delta'); 

-- список операций по выдаче (CREdit) денег банком А
SELECT Amount.bank_id AS 'Банк', Amount.operation_id AS 'Тип операции', amount AS 'Сумма' FROM Amount 
WHERE bank_id=(SELECT bank_id FROM Bank WHERE name='Delta') 
  AND operation_id=(SELECT operation_id FROM Operation WHERE op_type='cre'); 

-- список операций по выдаче (CREdit) денег банком А  - JOIN
SELECT Amount.bank_id AS 'Банк', Amount.operation_id AS 'Тип операции', amount AS 'Сумма' FROM Amount 
JOIN Bank ON Amount.bank_id = Bank.bank_id 
JOIN Operation ON Amount.operation_id = Operation.operation_id
WHERE Bank.name ='Delta' AND Operation.op_type = 'cre'; 

-- сумма выданных денег банком А
SELECT SUM(amount) AS 'Выдано банком' FROM Amount 
WHERE bank_id=(SELECT bank_id FROM Bank WHERE name='Delta') AND
operation_id=(SELECT operation_id FROM Operation WHERE op_type='cre'); 

-- сумма выданных денег банком А - JOIN
SELECT SUM(amount) AS 'Выдано банком' FROM Amount AS am
JOIN Bank ON am.bank_id = Bank.bank_id  
JOIN Operation AS op ON am.operation_id = op.operation_id 
WHERE Bank.name='Delta' AND op.op_type='cre'; 

-- список операций за конкретную дату (банк, клиент, сумма, дата) с id
SELECT bank_id AS 'Банк', customer_id AS 'Клиент', amount AS 'Сумма', operation_id AS 'ops'  
FROM Amount AS am  
WHERE am.action_id IN (SELECT Date.action_id FROM Date WHERE date='2017-04-04');

-- список операций за конкретную дату (банк, клиент, сумма, дата) с Названиями
SELECT Bank.name AS 'Банк', Customer.full_name AS 'Клиент', Amount.amount AS 'Сумма', Operation.op_type AS 'Операция', Date.date AS 'Дата операции'
FROM Bank, Customer, Amount, Operation, Date   
WHERE Bank.bank_id = Amount.bank_id AND Customer.customer_id = Amount.customer_id 
AND Amount.operation_id = Operation.operation_id AND Amount.action_id = date.action_id 
AND Date.date='2017-03-21' 
-- AND Date.date=TO_DAYS(now()) 
;

-- список операций за конкретную дату (банк, клиент, сумма, дата) с Названиями - JOIN
SELECT Bank.name AS 'Банк', Customer.full_name AS 'Клиент', am.amount AS 'Сумма', Operation.op_type AS 'Операция', Date.date AS 'Дата операции'
FROM Amount AS am
JOIN Bank ON am.bank_id = Bank.bank_id 
JOIN Customer ON am.customer_id = Customer.customer_id
JOIN Operation ON am.operation_id = Operation.operation_id
JOIN Date ON am.action_id = Date.action_id
-- WHERE Date.date = '2017-03-21'
WHERE Date.date = '2017-04-04'
-- AND Date.date=TO_DAYS(now()) 
;


