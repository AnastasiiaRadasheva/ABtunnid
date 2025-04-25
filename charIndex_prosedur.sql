-- Loome andmebaasi nimega "indexLoomine"
create database indexLoomine;

-- Kasutame loodud andmebaasi
use indexLoomine;

-- Loome tabelid IndianCustomers ja UKCustomers
create table IndianCustomers
(
    Id int identity(1,1), -- ID auto-kasvav väärtus
    Name nvarchar(25), -- Klientide nimi
    Email nvarchar(25) -- Klientide e-posti aadress
);

create table UKCustomers
(
    Id int identity(1,1),
    Name nvarchar(25),
    Email nvarchar(25)
);

-- Sisestame andmed tabelitesse
insert into IndianCustomers (Name, Email)
values ('Raj', 'R@R.com'),
       ('Sam', 'S@S.com');

insert into UKCustomers (Name, Email)
values ('Ben', 'B@B.com'),
       ('Sam', 'S@S.com');

-- Kuvame kõik read mõlemas tabelis
select * from IndianCustomers;
select * from UKCustomers;

-- Kasutame "union all", et kuvada kõik read (ka korduvad)
select Id, Name, Email from IndianCustomers
union all
select Id, Name, Email from UKCustomers;

-- Kasutame "union", et kuvada ainult unikaalsed read (korduvad eemaldatakse)
select Id, Name, Email from IndianCustomers
union
select Id, Name, Email from UKCustomers;

-- Soovime tulemusi sorteerida nime järgi, kasutades "union all"
select Id, Name, Email from IndianCustomers
union all
select Id, Name, Email from UKCustomers
order by Name;

-- Loome salvestatud protseduuri "spGetCustomers", et kuvada ainult UKCustomers tabeli andmeid
create procedure spGetCustomers
as begin
    select Name, Email from UKCustomers;
end;

select * from Employees
--loome tabile employees
create table Employees
(
Id int primary key,
Name nvarchar(50),
Gender nvarchar(10),
Salary nvarchar(50),
DepartmentId int
)

insert into Employees (Id, Name, Gender, Salary, DepartmentId)
values (1, 'Tom', 'Male', 4000, 1)
insert into Employees (Id, Name, Gender, Salary, DepartmentId)
values (2, 'Pam', 'Female', 3000, 1)
insert into Employees (Id, Name, Gender, Salary, DepartmentId)
values (3, 'John', 'Male', 3500, 1)
insert into Employees (Id, Name, Gender, Salary, DepartmentId)
values (4, 'Sam', 'Male', 4500, 2)
insert into Employees (Id, Name, Gender, Salary, DepartmentId)
values (5, 'Todd', 'Male', 2800, 1)
insert into Employees (Id, Name, Gender, Salary, DepartmentId)
values (6, 'Ben', 'Male', 7000, 1)
insert into Employees (Id, Name, Gender, Salary, DepartmentId)
values (7, 'Sara', 'Female', 4800, 3)
insert into Employees (Id, Name, Gender, Salary, DepartmentId)
values (8, 'Valarie', 'Female', 5500, 1)
insert into Employees (Id, Name, Gender, Salary, DepartmentId)
values (9, 'James', 'Male', 6500, NULL)
insert into Employees (Id, Name, Gender, Salary, DepartmentId)
values (10, 'Russell', 'Male', 8800, NULL)


--- kuidas muuta sp-d ja pane krüpteeringu peale, et keegi teine peale teid ei saaks muuta
alter proc spGetEmployeesByGenderAndDepartment
@Gender nvarchar(20),
@DepartmentId int
with encryption --krüpteerimine
as begin
	select FirstName, Gender, DepartmentId from Employees where Gender = @Gender
	and DepartmentId = @DepartmentId
end

sp_helptext spGetEmployeesByGenderAndDepartment
--
-- sp tegemine
create proc spGetEmployeeCountByGender
@Gender nvarchar(20),
@EmployeeCount int output
as begin
	select @EmployeeCount = count(Id) from Employees where Gender = @Gender
end
exec spGetEmployeeCountByGender 'Male'
-- annab tulemuse, kus loendab ära nõuetele vastavad read
-- prindib tulemuse konsooli

declare @TotalCount int
execute spGetEmployeeCountByGender 'Female', @TotalCount out
if(@TotalCount = 0)
	print 'TotalCount is null'
else
	print '@Total is not null'
print @TotalCount



-- Loome salvestatud protseduuri töötajate arvu lugemiseks soo järgi
create proc spGetEmployeeCountByGender
@Gender nvarchar(20),
@EmployeeCount int output
as begin
    select @EmployeeCount = count(Id) from Employees where Gender = @Gender;
end;

-- Käivitame protseduuri, et saada "Male" töötajate arv
exec spGetEmployeeCountByGender 'Male';

-- Kui soovime salvestatud protseduuri tekstilõike vaadata
sp_helptext spGetEmployeeCountByGender;

-- Protseduuride sõltuvused
sp_depends spGetEmployeeCountByGender;
sp_depends Employees;

-- Näide salvestatud protseduurist, mis ei tööta õigesti
create proc spGetnameById
@Id int,
@Name nvarchar(20) output
as begin
    select @Id = Id, @Name = Name from Employees;
end;

-- Näide õigest protseduurist, kus andmeid saab ID järgi
create proc spGetNameById1
@Id int,
@FirstName nvarchar(50) output
as begin
    select @FirstName = Name from Employees where Id = @Id;
end;

-- Kuvame salvestatud protseduuride sisu ja käivitame neid
sp_help spGetNameById1;
declare @FirstName nvarchar(50);
execute spGetNameById1 4, @FirstName output;
print 'Name of the employee = ' + @FirstName;

-- Näidatakse salvestatud protseduuride sisu, kus andmed tulevad ID järgi
create proc spGetNameById2
@Id int
as begin
    return (select Name from Employees where Id = @Id);
end;

-- Kuvame tulemusi
select * from Employees;

-- Näitame ASCII tähti ja nende väärtuseid
select ascii('a');
select char(66); -- Kuvab "B"

-- Eemaldame tühikud stringi algusest ja lõpust
select ltrim('        Hello');
select rtrim('      Hello          ');

-- Keerame stringi ümber (reverse)
select REVERSE(UPPER(ltrim(Name))) as FirstName, lower(Gender) as Gender, 
rtrim(ltrim(Name)) + ' ' + Gender as FullInfo from Employees;

-- Kuvame tähemärkide arvu nime järgi
select Name, len(Name) as [Total Characters] from Employees;

-- Kasutame LEFT, RIGHT ja SUBSTRING funktsioone
select left('ABCDEF', 4);
select right('ABCDEF', 3);
select SUBSTRING('pam@btbb.com', 5, 2);

-- Sisestame emailide väärtuste asemel tähti
select substring(Email, 1, 2) + REPLICATE('*', 5) + 
SUBSTRING(Email, CHARINDEX('@', Email), len(Email) - charindex('@', Email) + 1) as Email
from Employees;

-- Täiendame andmebaasi, et lisada uus veerg Email
alter table Employees
add Email nvarchar(20);

update Employees set Email = 'Tom@aaa.com' where Id = 1;
update Employees set Email = 'Pam@bbb.com' where Id = 2;
update Employees set Email = 'John@aaa.com' where Id = 3;
update Employees set Email = 'Sam@bbb.com' where Id = 4;
update Employees set Email = 'Todd@bbb.com' where Id = 5;

-- Kuvame lõpuks kogu Employees tabeli sisu
select * from Employees;
