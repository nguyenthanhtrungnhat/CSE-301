use problem2;

-- II. Creating constraint for database:
-- 1. Check constraint to value of gender in “Nam” or “Nu”.
alter table employees
add constraint chk_gender
check(gender in('Nam','Nu'));
-- 2. Check constraint to value of salary > 0.
alter table employees
add constraint chk_positive_salary
check (salary >0);
-- 3. Check constraint to value of relationship in Relative table in “Vo chong”, “Con trai”, “Con 
-- gai”, “Me ruot”, “Cha ruot”.
alter table relative
add constraint chk_relationship
check (relationship in('Vo chong', 'Con trai', 'Con gai', 'Me ruot', 'Cha ruot'));
-- III. Writing SQL Queries.
-- 1. Look for employees with salaries above 25,000 in room 4 or employees with salaries above 
-- 30,000 in room 5.
SELECT employeeID, lastName, firstName, salary, departmentID
FROM EMPLOYEES
WHERE (salary > 25000 AND departmentID = 4)
   or (salary > 30000 AND departmentID = 5);

-- 2. Provide full names of employees in HCM city.
SELECT  lastName,middleName ,firstName from EMPLOYEES
where address like '%TPHCM%';

-- 3. Indicate the date of birth of Dinh Ba Tien staff.
SELECT dateOfBirth from EMPLOYEES
where lastName='Dinh'and middleName='Ba' and firstName='Tien';
-- 4. The names of the employees of Room 5 are involved in the "San pham X" project and this 
-- employee is directly managed by "Nguyen Thanh Tung".
select lastName,middleName,firstName from employees
inner join projects on employees.departmentID = projects.departmentID
where managerID=(select employeeID from employees where lastName='Nguyen' and  middleName='Thanh' and firstName='Tung') 
and employees.departmentID=5 and projects.projectName='San pham X';

-- 5. Find the names of department heads of each department.
select employees.firstName,department.departmentName  from  employees
inner join department on employees.departmentID=department.departmentID
where  department.managerID=employees.employeeID;
-- 6. Find projectID, projectName, projectAddress, departmentID, departmentName,
-- departmentID, date0fEmploymeemployeesnt.
SELECT d.departmentName, d.departmentID, d.date0fEmployment, p.departmentID,
       p.projectID, p.projectName, p.projectAddress
FROM department d
INNER JOIN projects p ON d.departmentID = p.departmentID;

-- 7. Find the names of female employees and their relatives.
select employees.firstName,relative.relativeName from employees
inner join relative on relative.employeeID=employees.employeeID
where employees.gender='Nu';
-- 8. For all projects in "Hanoi", list the project code (projectID), the code of the project lead 
-- department (departmentID), the full name of the manager (lastName, middleName, 
-- firstName) as well as the address (Address) and date of birth (date0fBirth) of the 
-- Employees.
-- 9. For each employee, include the employee's full name and the employee's line manager.
SELECT 
    CONCAT(e.firstName, ' ', e.middleName, ' ', e.lastName) AS employeeFullName,
    CONCAT(m.firstName, ' ', m.middleName, ' ', m.lastName) AS managerFullName
FROM 
    EMPLOYEES e
LEFT JOIN 
    EMPLOYEES m ON e.managerID = m.employeeID;

-- 10. For each employee, indicate the employee's full name and the full name of the head of the 
-- department in which the employee works.
SELECT 
    CONCAT(e.firstName, ' ', e.middleName, ' ', e.lastName) AS employeeFullName,
    CONCAT(m.firstName, ' ', m.middleName, ' ', m.lastName) AS departmentHeadFullName
FROM 
    employees e
INNER JOIN 
    department d ON e.departmentID = d.departmentID
INNER JOIN 
    employees m ON d.managerID = m.employeeID;

-- 11. Provide the employee's full name (lastName, middleName, firstName) and the names of 
-- the projects in which the employee participated, if any.
SELECT 
    CONCAT(e.lastName, ' ', e.middleName, ' ', e.firstName) AS employeeFullName,
    p.projectName
FROM 
    employees e
INNER JOIN 
    assignment a ON e.employeeID = a.employeeID
INNER JOIN 
    projects p ON a.projectID = p.projectID;

-- 12. For each scheme, list the scheme name (projectName) and the total number of hours 
-- worked per week of all employees attending that scheme.
SELECT 
    p.projectName,
    SUM(a.workingHour) AS totalHoursPerWeek
FROM 
    projects p
INNER JOIN 
    assignment a ON p.projectID = a.projectID
GROUP BY 
    p.projectName;

-- 13. For each department, list the name of the department (departmentName) and the average 
-- salary of the employees who work for that department.
SELECT 
    d.departmentName,
    AVG(e.salary) AS averageSalary
FROM 
    department d
INNER JOIN 
    employees e ON d.departmentID = e.departmentID
GROUP BY 
    d.departmentName;

-- 14. For departments with an average salary above 30,000, list the name of the department and 
-- the number of employees of that department.
WITH AvgSalary AS (
    SELECT 
        departmentID,
        AVG(salary) AS avgSalary
    FROM 
        employees
    GROUP BY 
        departmentID
)
SELECT 
    d.departmentName,
    COUNT(e.employeeID) AS numberOfEmployees
FROM 
    AvgSalary AS a
INNER JOIN 
    department d ON a.departmentID = d.departmentID
INNER JOIN 
    employees e ON d.departmentID = e.departmentID
WHERE 
    a.avgSalary > 30000
GROUP BY 
    d.departmentName;

-- 15. Indicate the list of schemes (projectID) that has: workers with them (lastName) as 'Dinh' 
-- or, whose head of department presides over the scheme with them (lastName) as 'Dinh'.
SELECT DISTINCT 
    p.projectID
FROM 
    projects p
LEFT JOIN 
    assignment a ON p.projectID = a.projectID
LEFT JOIN 
    employees e ON a.employeeID = e.employeeID
LEFT JOIN 
    department d ON p.departmentID = d.departmentID
LEFT JOIN 
    employees m ON d.managerID = m.employeeID
WHERE 
    e.lastName = 'Dinh' OR m.lastName = 'Dinh';

-- 16. List of employees (lastName, middleName, firstName) with more than 2 relatives.
SELECT CONCAT(e.lastName, ' ', e.middleName, ' ', e.firstName) AS employeeFullName
FROM employees e
INNER JOIN relative r ON e.employeeID = r.employeeID
GROUP BY e.employeeID, e.lastName, e.middleName, e.firstName
HAVING COUNT(r.employeeID) >= 2;

-- 17. List of employees (lastName, middleName, firstName) without any relatives.
SELECT CONCAT(e.lastName, ' ', e.middleName, ' ', e.firstName) AS employeeFullName
FROM employees e
LEFT JOIN relative r ON e.employeeID = r.employeeID
GROUP BY e.employeeID, e.lastName, e.middleName, e.firstName
HAVING COUNT(r.employeeID) = 0;


-- 18. List of department heads (lastName, middleName, firstName) with at least one relative.
SELECT CONCAT(e.lastName, ' ', e.middleName, ' ', e.firstName) AS employeeFullName
FROM employees e
INNER JOIN department d ON e.employeeID = d.managerID
LEFT JOIN relative r ON e.employeeID = r.employeeID
GROUP BY e.employeeID, e.lastName, e.middleName, e.firstName
HAVING COUNT(r.employeeID) > 0;


-- 19. Find the surname (lastName) of unmarried department heads.
select employees.lastName from employees
inner join department on employees.employeeID=department.managerID
inner join relative on relative.employeeID = department.managerID
where relative.relationship is null;
-- 20. Indicate the full name of the employee (lastName, middleName, firstName) whose salary 
-- is above the average salary of the "Research" department.
SELECT CONCAT(e.lastName, ' ', e.middleName, ' ', e.firstName) AS employeeFullName
FROM employees e
INNER JOIN department d ON e.departmentID = d.departmentID
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    INNER JOIN department d2 ON e2.departmentID = d2.departmentID
    WHERE d2.departmentName = 'Nghien cuu'
);

-- 21. Indicate the name of the department and the full name of the head of the department with 
-- the largest number of employees.
SELECT d.departmentName, CONCAT(e.lastName, ' ', e.middleName, ' ', e.firstName) AS headFullName
FROM department d
INNER JOIN employees e ON d.managerID = e.employeeID
WHERE d.departmentID = (
    SELECT d2.departmentID
    FROM department d2
    INNER JOIN employees e2 ON d2.departmentID = e2.departmentID
    GROUP BY d2.departmentID
    ORDER BY COUNT(e2.employeeID) DESC
    LIMIT 1
);

-- 22. Find the full names (lastName, middleName, firstName) and addresses (Address) of 
-- employees who work on a project in 'HCMC' but the department they belong to is not 
-- located in 'HCMC'.
SELECT DISTINCT e.lastName, e.middleName, e.firstName, e.address
FROM EMPLOYEES e
INNER JOIN ASSIGNMENT a ON e.employeeID = a.employeeID
INNER JOIN PROJECTS p ON a.projectID = p.projectID
INNER JOIN DEPARTMENT d ON e.departmentID = d.departmentID
INNER JOIN DEPARTMENTADDRESS da ON d.departmentID = da.departmentID
WHERE p.projectAddress LIKE '%TP HCM%'
AND da.address NOT LIKE '%TP HCM%';
 
-- 23. Find the names and addresses of employees who work on a scheme in a city but the 
-- department to which they belong is not located in that city.
-- 4
-- 24. Create procedure List employee information by department with input data 
-- departmentName.
-- 25. Create a procedure to Search for projects that an employee participates in based on the 
-- employee's last name (lastName).
-- 26. Create a function to calculate the average salary of a department with input data 
-- departmentID.
-- 27. Create a function to Check if an employee is involved in a particular project input data is 
-- employeeID, projectID.

