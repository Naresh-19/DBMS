show databases;
drop database bank;
create database bank;
use bank;
CREATE TABLE Branch (
    Branch_name VARCHAR(50) PRIMARY KEY,
    Branch_city VARCHAR(50),
    Assets DECIMAL(15,2)
);


CREATE TABLE BankCustomer (
    Customer_name VARCHAR(50) PRIMARY KEY,
    Customer_street VARCHAR(100),
    City VARCHAR(50)
);

CREATE TABLE BankAccount (
    Accno INT PRIMARY KEY,
    Branchname VARCHAR(50),
    Balance DECIMAL(15,2),
    FOREIGN KEY (Branchname) REFERENCES Branch(Branch_name)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Depositer (
    Customername VARCHAR(50),
    Accno INT,
    PRIMARY KEY (Customername, Accno),
    FOREIGN KEY (Customername) REFERENCES BankCustomer(Customer_name)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (Accno) REFERENCES BankAccount(Accno)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Loan (
    Loan_number INT PRIMARY KEY,
    Branchname VARCHAR(50),
    Amount DECIMAL(15,2),
    FOREIGN KEY (Branchname) REFERENCES Branch(Branch_name)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
INSERT INTO Branch VALUES
('SBI_Chamrajpet', 'Bangalore', 50000),
('SBI_ResidencyRoad', 'Bangalore', 10000),
('SBI_ShivajiRoad', 'Bombay', 20000),
('SBI_ParlimentRoad', 'Delhi', 10000),
('SBI_Jantarmantar', 'Delhi', 20000);

INSERT INTO BankAccount VALUES
(1, 'SBI_Chamrajpet', 2000),
(2, 'SBI_ResidencyRoad', 5000),
(3, 'SBI_ShivajiRoad', 6000),
(4, 'SBI_ParlimentRoad', 8000),
(5, 'SBI_Jantarmantar', 9000),
(6, 'SBI_ShivajiRoad', 4000),
(8, 'SBI_ResidencyRoad', 4000),
(9, 'SBI_ParlimentRoad', 3000),
(10, 'SBI_ResidencyRoad', 5000),
(11, 'SBI_Jantarmantar', 2000);

INSERT INTO BankCustomer VALUES
('Avinash', 'Bull_Temple_Road', 'Bangalore'),
('Dinesh', 'Bannerghatta_Road', 'Bangalore'),
('Mohan', 'NationalCollege_Road', 'Bangalore'),
('Nikhil', 'Akbar_Road', 'Delhi'),
('Ravi', 'Prithviraj_Road', 'Delhi');

INSERT INTO Depositer VALUES
('Avinash', 1),
('Dinesh', 2),
('Nikhil', 4),
('Ravi', 5),
('Avinash', 8),
('Nikhil', 9),
('Dinesh', 10),
('Nikhil', 11);

INSERT INTO Loan VALUES
(1, 'SBI_Chamrajpet', 1000),
(2, 'SBI_ResidencyRoad', 2000),
(3, 'SBI_ShivajiRoad', 3000),
(4, 'SBI_ParlimentRoad', 4000),
(5, 'SBI_Jantarmantar', 5000);
select Branch_name,(Assets/100000) as assets_in_Lakhs from Branch;
select d.Customername,b.Branchname,count(b.Accno)
from Depositer d,Bankaccount b
where d.Accno=b.Accno
group by Branchname,Customername
having count(b.Accno)>=2;
create view Bank_loan as
select Branchname,sum(Amount) from Loan
group by Branchname;
select * from Bank_loan;

select Branch_name,Assets from Branch where assets>(select max(Assets) from Branch where Branch_city='Bangalore');

select distinct D.Customername
from Depositer D
join BankAccount A on D.Accno = A.Accno
join Branch B1 on A.Branchname = B1.Branch_name
join Loan L on L.Branchname = B1.Branch_name
join Branch B2 on L.Branchname = B2.Branch_name
where B1.Branch_city = 'Bangalore'
  and B2.Branch_city = 'Bangalore';
  
select d.customername
from depositer d
join bankaccount ba on d.accno = ba.accno
join branch b on ba.branchname = b.branch_name
where b.branch_city = 'Delhi'
group by d.customername
having count(distinct b.branch_name) = (
    select count(*)
    from branch
    where branch_city = 'Delhi'
);


delete from depositer
where accno in (
    select accno
    from bankaccount
    where branchname in (
        select branch_name
        from branch
        where branch_city = 'Bombay'
    )
);
delete from bankaccount
where branchname in (
    select branch_name
    from branch
    where branch_city = 'Bombay'
);


set sql_safe_updates = 0;
update bankaccount
set balance = balance * 1.05;
