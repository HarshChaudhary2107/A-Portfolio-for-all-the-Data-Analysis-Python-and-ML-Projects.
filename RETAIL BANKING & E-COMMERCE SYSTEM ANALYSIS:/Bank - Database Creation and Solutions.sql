
-- 1.	Create DataBase BANK and Write SQL query to create above schema with constraints

CREATE DATABASE bank;

USE bank; 

CREATE TABLE branch
  (
     branch_no INT auto_increment NOT NULL,
     branch_name      VARCHAR (50) NOT NULL,
     PRIMARY KEY (branch_no)
  ); 
  


CREATE TABLE employees
  (
     emp_no    INT auto_increment NOT NULL,
     branch_no INT,
     fname     VARCHAR(20),
     mname     VARCHAR(20),
     lname     VARCHAR(20),
     dept      VARCHAR(20),
     desig     VARCHAR(20),
     mngr_no   INT NOT NULL,
     PRIMARY KEY (emp_no),
     CONSTRAINT fk_branch_no FOREIGN KEY (branch_no) REFERENCES branch(branch_no)
  ); 

CREATE TABLE customers
  (
     cust_no    INT auto_increment NOT NULL,
     fname      VARCHAR(20),
     mname      VARCHAR(20),
     lname      VARCHAR(20),
     city       VARCHAR(20),
     dob        DATE,
     occupation VARCHAR(20),
     PRIMARY KEY (cust_no)
  ); 

CREATE TABLE accounts
  (
     acc_no          INT auto_increment NOT NULL,
     branch_no       INT NOT NULL,
     cust_no         INT NOT NULL,
     acc_type        ENUM ('Current', 'Savings'),
     acc_open_date   DATE,
     current_balance INT,
     account_status  ENUM ('Active', 'Suspended', 'Terminatd'),
     PRIMARY KEY (acc_no),
     CONSTRAINT fk_cust_no FOREIGN KEY (cust_no) REFERENCES customers(cust_no),
     CONSTRAINT fk_branch_no_1 FOREIGN KEY (branch_no) REFERENCES branch(
     branch_no)
  ); 
 
-- 2. Inserting records into create tables

INSERT INTO branch (branch_NAME)
VALUES      ('Delhi'),('Mumbai'); 

INSERT INTO customers (cust_no, fname, mname, lname, occupation, dob)
VALUES
('1','Ramesh', 'Chandra', 'Sharma', 'Service', '1976-12-06'),
('2','Avinash', 'Sunder', 'Minha', 'Business', '1974-10-16');

INSERT INTO accounts (acc_no, cust_no, branch_no, current_balance, acc_open_date, acc_type, account_status)
VALUES
('1', '1', '1', '10000', '2012-12-15', 'Savings', 'Active'),
('2', '2', '2', '5000', '2012-06-12', 'Savings', 'Active');

INSERT INTO Employees (emp_no, branch_no, fname, mname, lname, dept, desig, mngr_no)
VALUES
(1, 1, 'Mark', 'Steve', 'Lara', 'Account', 'Accountant', 2),
(2, 2, 'Bella', 'James', 'Ronald', 'Loan', 'Manager', 1);

# 3. Select unique occupation from customer table :

SELECT DISTINCT occupation
FROM   customers;

# 4. Sort account according to current balance

SELECT *
FROM   accounts
ORDER  BY current_balance; 

# 5. Find the Date of Birth of customer name ‘Ramesh’

SELECT dob
FROM   customers
WHERE  fname = 'Ramesh'; 

# 6. Add a column city to the branch table

ALTER TABLE branch ADD COLUMN CITY VARCHAR(20);
SELECT * FROM branch;

#7. Update the mname and lname of employee ‘Bella’ and set to ‘Karan’, ‘Singh’ 
UPDATE employees SET Mname = "Karan", Lname = "Singh" WHERE Fname = "Bella";
SELECT*FROM employees;

# 8. Select accounts opened between '2012-07-01' AND '2013-01-01'
SELECT * FROM accounts where acc_open_date BETWEEN '2012-07-01' AND '2013-01-01';

# 9. List the names of customers having ‘a’ as the second letter in their names :
SELECT * FROM customers WHERE fname LIKE '_a%';

# 10. Find the lowest balance from customer and account table :

SELECT c.cust_no,
       c.fname,
       c.mname,
       c.lname,
       a.current_balance
FROM   customers c
       JOIN accounts a
         ON c.cust_no = a.cust_no
ORDER  BY a.current_balance
LIMIT  1; 

-- 11.	Give the count of customer for each occupation
SELECT occupation,
       Count(cust_no) AS count_of_customer
FROM   customers
GROUP  BY occupation; 

-- 12.	Write a query to find the name (first_name, last_name) of the employees who are managers.
SELECT fname,
       lname
FROM   employees
WHERE  desig = 'Manager'; 

-- 13. List name of all employees whose name ends with a
SELECT fname,
       mname,
       lname
FROM   employees
WHERE  lname LIKE '%a'; 

-- 14.	Select the details of the employee who work either for department ‘loan’ or ‘credit’ 
SELECT *
FROM   employees
WHERE  dept LIKE 'Loan'
        OR 'Credit'; 
        
-- 15. Write a query to display the customer number, customer firstname, account number for the customer’s who are born after 15th of any month.
SELECT c.cust_no,
       c.fname,
       a.acc_no,
       c.dob
FROM   customers c
       JOIN accounts a
         ON c.cust_no = a.cust_no
WHERE  Day(dob) > 15; 

-- 16.	Write a query to display the customer’s number, customer’s firstname, branch id and balance amount for people using JOIN.
SELECT c.cust_no,
       c.fname,
       b.branch_no,
       a.current_balance
FROM   customers c
       JOIN accounts a
         ON c.cust_no = a.cust_no
       JOIN branch b
         ON a.branch_no = b.branch_no; 
         
-- 17.	Create a virtual table to store the customers who are having the accounts in the same city as they live
UPDATE customers
SET    city = 'Delhi';

CREATE VIEW city_cust
AS
  SELECT c.cust_no, c.fname, c.mname, c.lname, c.city, c.dob, c.occupation,
         a.acc_no, b.branch_name
  FROM   customers AS c
         JOIN accounts AS a
           ON a.cust_no = c.cust_no
         JOIN branch AS b
           ON b.branch_no = a.branch_no
  WHERE  c.city = b.branch_name;
   
SELECT *
FROM   city_cust; 

-- 18.	A. Create a transaction table with following details 
-- TID – transaction ID – Primary key with autoincrement 
-- Custid – customer id (reference from customer table
-- account no – acoount number (references account table)
-- bid – Branch id – references branch table
-- amount – amount in numbers
-- type – type of transaction (Withdraw or deposit)
-- DOT -  date of transaction

CREATE TABLE TRANSACTION (
    TID INT PRIMARY KEY AUTO_INCREMENT,
    custid INT,
    account_no INT,
    branch_id INT,
    amount INT,
    type_of_transaction VARCHAR(20) CHECK (type_of_transaction IN ('Withdraw', 'Deposit')),
    DOT DATE,
    FOREIGN KEY (custid) REFERENCES customers(cust_no),
    FOREIGN KEY (account_no) REFERENCES accounts(acc_no),
    FOREIGN KEY (branch_id) REFERENCES branch(branch_no)
);

-- a. Write trigger to update balance in account table on Deposit or Withdraw in transaction table
DELIMITER //
CREATE TRIGGER update_account_balance 
After
INSERT ON TRANSACTION 
FOR each row 
BEGIN
DECLARE current_balance_updated decimal (10,2);
select current_balance
INTO   current_balance_updated
FROM   accounts
WHERE  acc_no = new.account_no;

UPDATE accounts
SET    current_balance =
       CASE
              WHEN new.type_of_transaction = 'deposit' THEN current_balance_updated + new.amount
              WHEN new.type_of_transaction = 'withdraw' THEN current_balance_updated - new.amount
       END
WHERE  acc_no = new.account_no;

end//
delimiter ;

-- b. Insert values in transaction table to show trigger success

INSERT INTO transaction (TID, custid, account_no, branch_id, amount, type_of_transaction, DOT)
VALUES
('1', '1', '1', '1', '3000', 'Withdraw', '2023-06-23');

-- 19. Write a query to display the details of customer with second highest balance

select c.cust_no, c.fname, c.mname, c.lname, a.current_balance
from customers c
join accounts a 
on c.cust_no = a.cust_no
order by current_balance desc
limit 1,1;

-- 20. Take backup of the database created in the case study

 