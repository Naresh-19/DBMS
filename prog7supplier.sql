show databases;
drop database supplier;
create database supplier;
use supplier;
create table supplier(
	sid int primary key,
    sname varchar(30),
    city varchar(30));
    
create table parts(
	pid int primary key,
    pname varchar(30),
    color varchar(20));
    
create table catalog(
    sid int,
    pid int,
    cost int,
    foreign key (sid) references supplier(sid),
    foreign key (pid) references parts(pid));

insert into supplier values
(10001,'Alice widget','Banglore'),
(10002,'Johns','Kolkata'),
(10003,'Vimal','Mumbai'),
(10004,'Reliance','Delhi');

insert into parts values
(20001,'Book','Red'),
(20002,'Pen','Red'),
(20003,'Pencil','Green'),
(20004,'Mobile','Green'),
(20005,'Charger','Black');

insert into catalog values
(10001,20001,10),
(10001,20002,10),
(10001,20003,30),
(10001,20004,10),
(10001,20005,10),
(10002,20001,10),
(10002,20002,20),
(10003,20003,30),
(10004,20003,40);

select distinct pname from parts p
join catalog c on p.pid=c.pid
where sid in(select distinct sid from catalog);

select distinct sname from supplier s
join catalog c on s.sid=c.sid
where s.sid in (select sid from catalog group by sid having count(pid)=(select count(distinct pid) from parts));

select  sname from supplier s
join catalog c on s.sid=c.sid
where pid in(select distinct pid from parts where color='Red');

select distinct pname 
from parts p
join catalog c on p.pid = c.pid 
where c.sid in (select sid from supplier s where sname = 'Alice widget')
and c.sid not in (select sid from supplier s where sname != 'Alice widget');



select  sname,pid  from supplier s
join catalog c on s.sid=c.sid
where c.pid in(select c2.pid from catalog c2 group by pid having cost=max(c2.cost) and c.pid=c2.pid);

select  distinct s.sid  from supplier s
join catalog c on s.sid=c.sid
where c.pid in(select c2.pid from catalog c2 group by pid having cost>avg(c2.cost) and c.pid=c2.pid);