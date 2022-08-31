---------------------------------------------------------------------------------------------------------------------
-- CREATE TABLES 
-- DROP TABLE EmployeeDemographics
Create Table EmployeeDemographics
(EmployeeID int, FirstName VARCHAR(25), LastName VARCHAR(25), Age int, Gender  VARCHAr(25))
insert INTO EmployeeDemographics
Values (1001, 'Jim', 'Halpert', 30, 'Male'),
(1002, 'Pam', 'Beasley', 30, 'Female'),
(1003, 'Dwight', 'Schrute', 29, 'Male'),
(1004, 'Angela', 'Martin', 31, 'Female'),
(1005, 'Toby', 'Flenderson', 32, 'Male'),
(1006, 'Michael', 'Scott', 35, 'Male'),
(1007, 'Meredith', 'Palmer', 32, 'Female'),
(1008, 'Stanley', 'Hudson', 38, 'Male'),
(1009, 'Kevin', 'Malone', 31, 'Male'),
(1011, 'Ryan', 'Howard', 26, 'Male'),
(Null, 'Holly', 'Flax', NULL, NULL),
(1013, 'Darryl', 'Philbin', NULL, 'Male')

Create Table EmployeeSalary
(EmployeeID int, JobTitle VARCHAR(25), Salary int)
insert INTO EmployeeSalary
Values (1001, 'Salesman', 45000),
(1002, 'Receptionist', 36000),
(1003, 'Salesman', 63000),
(1004, 'Accountant', 47000),
(1005, 'HR', 50000),
(1006, 'Regional Manager', 65000),
(1007, 'Supplier', 41000),
(1008, 'Salesman', 48000),
(1009, 'Accountant', 42000),
(1010, NULL, 47000),
(Null, 'Salesman', 43000)
---------------------------------------------------------------------------------------------------------------------
--VIEW TABLES
select * from EmployeeDemographics
select * from EmployeeSalary

--INNER JOIN WILL RETURN ALL OF THE SAME VALUES (for employeeID from both tables)
Select *
From EmployeeDemographics
inner join EmployeeSalary
	on EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

--FULL OUTER JOIN WILL RETURN ALL OF THE VALUES (for employeeID from both tables)
Select *
From EmployeeDemographics
full outer join EmployeeSalary
	on EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

--This LEFT OUTER JOIN WILL RETURN ALL OF THE VALUES OF EMPLOYEEID FROM THE FIRST TABLE (EmployeeSalary)
Select *
From EmployeeDemographics
left outer join EmployeeSalary
	on EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

--THIS RIGHT OUTER JOIN WILL RETURN ALL OF THE VALUES OF EMPLOYEEID FROM THE SECOND TABLE (EmployeeDemographics)
Select *
From EmployeeDemographics
right outer join EmployeeSalary
	on EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

--NOTE: AN INNER JOIN WILL RESULT IN THE SAME OUTPUT NO MATTER WHAT TABLE YOU HAVE AS THE FIRST
Select EmployeeDemographics.EmployeeID,FirstName, LastName, JobTitle, Salary
From EmployeeDemographics
Inner join EmployeeSalary
	on EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

--NOTE: FOR THIS RIGHT OUTER JOIN WE ARE LOOKING AT EVERYTHING FROM THE RIGHT TABLE BUT WITH A LEFT TABLE VIEW
Select EmployeeDemographics.EmployeeID,FirstName, LastName, JobTitle, Salary
From EmployeeDemographics
Right outer join EmployeeSalary
	on EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
--NOTE: FOR THIS RIGHT OUTER JOIN WE ARE LOOKING AT EVERYTHING FROM THE RIGHT TABLE BUT WITH A RIGHT TABLE VIEW
Select EmployeeSalary.EmployeeID,FirstName, LastName, JobTitle, Salary
From EmployeeDemographics
Right outer join EmployeeSalary
	on EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

select * from EmployeeDemographics
select * from EmployeeSalary

--PROBLEM: MICHAEL SCOTT NEEDS TO REDUCE THE SALRAY OF THE HIGHEST EARNER NOT INCLUDING HIMSELF
-- FULL VIEW
Select EmployeeID,FirstName, LastName, Salary
From EmployeeDemographics
FULL outer join EmployeeSalary
	on EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
--only looking at data that contains an employeeID
Select employeedemographics.EmployeeID,FirstName, LastName, Salary
From EmployeeDemographics
inner join EmployeeSalary
	on EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
where FirstName<> 'Michael'
order by Salary DESC
--POOR DWIGHT
--END OF CODE