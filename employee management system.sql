create database employees_mangament_system;
use employees_mangament_system;
create table departments(
DepartmentID int primary key auto_increment,
DepartmentNAME varchar(100) not null unique,
location varchar(100)
); 
create table roles(
roleid int primary key auto_increment,
rolename varchar(100) unique,
responsibilities text
);
create table employes(
employeeid int primary key auto_increment,
firstname varchar(50) not null,
lastname varchar(50) not null,
departmentID int,
roleid int,
dateofjoining date,
phone varchar(15),
foreign key(DepartmentID) references departments(DepartmentID) on delete set null,
foreign key(roleid) references roles(roleid) on delete set null
);
create table attendence(
attendenceid int primary key auto_increment,
employeeid int,
attendencedate date not null,
status enum('absent','present','leave'),
foreign key(EmployeeID) references Employes(EmployeeID) on delete cascade
);
INSERT INTO Departments (DepartmentNAME, Location)
VALUES ('IT', 'Building A'),
('HR', 'Building B'),
('Finance', 'Building C');
INSERT INTO Roles (RoleName, Responsibilities)
VALUES ('Software Engineer', 'Develop and maintain software applications.'),
('HR Manager', 'Manage HR activities and employee relations.'),
('Accountant', 'Manage financial records and reporting.');
INSERT INTO Employes (FirstName, LastName, DepartmentID, RoleID, DateOfJoining, Phone)
VALUES ('John', 'Doe', 1, 1, '2021-06-15', '1234567890'),
('Jane', 'Smith', 2, 2, '2020-01-10', '0987654321'),
('Emily', 'Johnson', 3, 3, '2019-08-20', '1122334455');
INSERT INTO Attendence (EmployeeID, attendencedate , Status)
VALUES (1, '2023-10-01', 'Present'),
(1, '2023-10-02', 'Absent'),
(2, '2023-10-01', 'Present'),
(3, '2023-10-01', 'Absent');
SELECT E.FirstName, E.LastName, d.departmentNAME, r.rolename,
COUNT(CASE WHEN A.Status = 'Present' THEN 1 END) AS PresentCount,
COUNT(CASE WHEN A.Status = 'Absent' THEN 1 END) AS AbsentCount,
COUNT(CASE WHEN A.Status = 'Leave' THEN 1 END) AS LeaveCount
FROM Employes E
LEFT JOIN Attendence A ON E.EmployeeID = A.EmployeeID
LEFT JOIN departments d ON E.DepartmentID = D.DepartmentID
LEFT JOIN roles r ON E.roleid = r.roleid
GROUP BY E.EmployeeID;



