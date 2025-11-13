drop database supplier;
create  database supplier;
use supplier;

CREATE TABLE Supplier (
    SID INT PRIMARY KEY,
    SName VARCHAR(50),
    City VARCHAR(50)
);


CREATE TABLE Parts (
    PID INT PRIMARY KEY,
    PName VARCHAR(50),
    Color VARCHAR(20)
);


CREATE TABLE Catalog (
    SID INT,
    PID INT,
    Cost INT,
    FOREIGN KEY (SID) REFERENCES Supplier(SID),
    FOREIGN KEY (PID) REFERENCES Parts(PID)
);


INSERT INTO Supplier VALUES
(10001, 'Acme Widget', 'Bangalore'),
(10002, 'Johns', 'Kolkata'),
(10003, 'Vimal', 'Mumbai'),
(10004, 'Reliance', 'Delhi');


INSERT INTO Parts VALUES
(20001, 'Book', 'Red'),
(20002, 'Pen', 'Red'),
(20003, 'Pencil', 'Green'),
(20004, 'Mobile', 'Green'),
(20005, 'Charger', 'Black');


INSERT INTO Catalog VALUES
(10001, 20001, 10),
(10001, 20002, 10),
(10001, 20003, 30),
(10001, 20004, 10),
(10001, 20005, 10),
(10002, 20001, 10),
(10002, 20002, 20),
(10003, 20003, 30),
(10004, 20003, 40);

select distinct pname from parts 
join catalog on parts.pid=catalog.pid
where sid in (select distinct sid from catalog);

select distinct sname from supplier s 
join catalog c on s.sid=c.sid 
where s.sid in(select distinct sid from catalog group by sid having count(catalog.pid)=(select count(pid) from parts));

select distinct sname from supplier s 
join catalog c on s.sid=c.sid 
where c.pid in(select distinct pid from parts where color='red');


select pname from parts p 
join catalog c  on p.pid=c.pid 
where p.pid in(select c.pid from catalog c join supplier s on c.sid=s.sid where s.sname='Acme Widget') and 
p.pid not in (select c.pid from catalog c join supplier s on c.sid=s.sid where s.sname !='Acme Widget');

select pid, sname from supplier s 
join catalog c on s.sid=c.sid 
where c.cost in(select max(c2.cost) from catalog c2  where c.pid=c2.pid);

select s.sid from supplier s
join catalog c on s.sid=c.sid
where c.cost>(select avg(c2.cost) from catalog c2 where c.pid=c2.pid);

