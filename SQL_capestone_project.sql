create database Job_Portal_management_system;
use Job_portal_management_system;
create table Candidates(candidate_id int primary key, full_name varchar(20), phone bigint unique, email varchar(30) unique, city char(20));
desc Candidates;
create table Employers(employer_id int primary key, company_name varchar(20), industry varchar(20));
desc Employers;
create table Jobs(job_id int primary key, employer_id int, foreign key (employer_id) references Employers(employer_id), title varchar(20), location varchar(30), salary int);
desc Jobs;
create table Applications(application_id int primary key, candidate_id int, foreign key (candidate_id) references Candidates(candidate_id),
 job_id int,foreign key (job_id) references Jobs(job_id), application_date date, status varchar(20));
desc Applications;
drop table jobs;
create table Interviews(interview_id int primary key, application_id int, foreign key (application_id) references Applications(application_id),
interview_date date, mode char(10), result varchar(20));
desc Interviews;
INSERT INTO Candidates VALUES
(1,'Aarav','900000001','c1@mail.com','Hyderabad'),
(2,'Bhavya','900000002','c2@mail.com','Vijayawada'),
(3,'Charan','900000003','c3@mail.com','Vizag'),
(4,'Divya','900000004','c4@mail.com','Guntur'),
(5,'Esha','900000005','c5@mail.com','Warangal'),
(6,'Farhan','900000006','c6@mail.com','Nellore'),
(7,'Gopi','900000007','c7@mail.com','Kurnool'),
(8,'Hari','900000008','c8@mail.com','Tirupati'),
(9,'Isha','900000009','c9@mail.com','Chennai'),
(10,'John','900000010','c10@mail.com','Bengaluru');
select * from Candidates;
INSERT INTO Employers VALUES
(101,'TechNova','IT'),(102,'DataWave','Analytics'),(103,'CloudEdge','Cloud'),
(104,'FinCore','Finance'),(105,'HealthSoft','Healthcare');
select * from Employers;
INSERT INTO Jobs VALUES
(1001,101,'Python Developer','Hyderabad',650000),
(1002,101,'SQL Developer','Hyderabad',550000),
(1003,102,'Data Analyst','Vizag',600000),
(1004,103,'Cloud Engineer','Bengaluru',850000),
(1005,104,'BI Developer','Chennai',700000),
(1006,105,'ML Engineer','Hyderabad',950000);
select * from Jobs;
INSERT INTO Applications VALUES
(1,1,1001,'2026-07-01','Applied'),
(2,2,1003,'2026-07-02','Shortlisted'),
(3,3,1002,'2026-07-02','Rejected'),
(4,4,1004,'2026-07-03','Interview'),
(5,5,1005,'2026-07-03','Selected'),
(6,6,1006,'2026-07-04','Applied'),
(7,7,1001,'2026-07-05','Interview'),
(8,8,1002,'2026-07-06','Shortlisted'),
(9,9,1004,'2026-07-07','Applied'),
(10,10,1006,'2026-07-08','Selected');
select * from Applications;
INSERT INTO Interviews VALUES
(201,2,'2026-07-05','Online','Pending'),
(202,4,'2026-07-06','Offline','Pending'),
(203,5,'2026-07-07','Online','Selected'),
(204,7,'2026-07-08','Offline','Rejected'),
(205,8,'2026-07-09','Online','Pending'),
(206,10,'2026-07-10','Offline','Selected');
select * from Interviews;

#------------------------------------------------------------Queries-------------------------------------------------------------------
#list all jobs
SELECT * FROM jobs;
#applications with candidate names
SELECT a.application_id, c.full_name, a.job_id, a.application_date, a.status 
FROM Applications a
JOIN Candidates c ON a.candidate_id = c.candidate_id;
#employer names in upeercase/lowercase
SELECT UPPER(company_name) AS upper_name, LOWER(company_name) AS lower_name 
FROM Employers;
#first 5 charectars of every comeny name
SELECT LEFT(company_name, 5) AS short_name 
FROM Employers;
use job_portal_management_system;
#concatinate the candidates name and city
SELECT CONCAT(full_name, ' - ', city) AS candidate_info 
FROM Candidates;
#replace the word Engineer with Specialist in job titles
SELECT REPLACE(title, 'Engineer', 'Specialist') AS modified_title 
FROM Jobs;
#Find all jobs where the title contains the word Developer.
SELECT * FROM Jobs 
WHERE title LIKE '%Developer%';
# Find jobs in Hyderabad.
SELECT * FROM Jobs 
WHERE location = 'Hyderabad';
#Applications in last 7 days. 
SELECT * FROM Applications 
WHERE application_date >= CURDATE() - INTERVAL 7 DAY;
#count jobs compeny wise
SELECT employer_id, COUNT(*) AS job_count 
FROM Jobs 
GROUP BY employer_id;
#formate application dates in the formate mon-jul-26
SELECT DATE_FORMAT(application_date, '%a-%b-%y') AS formatted_date 
FROM Applications;
#candidates whose interviews are scheduled today
SELECT c.* 
FROM Candidates c
JOIN Applications a ON c.candidate_id = a.candidate_id
JOIN Interviews i ON a.application_id = i.application_id
WHERE i.interview_date = CURDATE();
#show the number of days since application was submitted
SELECT application_id, DATEDIFF(CURDATE(), application_date) AS days_elapsed 
FROM Applications;
#Display the highest and lowest salary offered
SELECT MAX(salary) AS highest_salary, MIN(salary) AS lowest_salary 
FROM Jobs;
#Calculate the total salary budget offered by each company.
SELECT employer_id, SUM(salary) AS total_budget 
FROM Jobs 
GROUP BY employer_id;
#Count applications by status.
SELECT status, COUNT(*) AS total_applications 
FROM Applications 
GROUP BY status;
#Employer with most jobs.
SELECT employer_id, COUNT(*) AS job_count 
FROM Jobs 
GROUP BY employer_id 
ORDER BY job_count DESC 
LIMIT 1;
#Candidate with most applications
SELECT candidate_id, COUNT(*) AS app_count 
FROM Applications 
GROUP BY candidate_id 
ORDER BY app_count DESC 
LIMIT 1;
#Selected candidates
SELECT DISTINCT c.* 
FROM Candidates c
JOIN Applications a ON c.candidate_id = a.candidate_id
WHERE a.status = 'Selected';
#Rejected applications
SELECT * FROM Applications 
WHERE status = 'Rejected';
#Companies with more than one job
SELECT employer_id 
FROM Jobs 
GROUP BY employer_id 
HAVING COUNT(*) > 1;
#Show locations having more than two job openings
SELECT location 
FROM Jobs 
GROUP BY location 
HAVING COUNT(*) > 2;
#Average salary by company
SELECT employer_id, AVG(salary) AS avg_salary 
FROM Jobs 
GROUP BY employer_id;
#Top 5 latest jobs
SELECT * FROM Jobs 
ORDER BY job_id DESC 
LIMIT 5;
#Jobs in IT industry
SELECT j.* 
FROM Jobs j
JOIN Employers e ON j.employer_id = e.employer_id
WHERE e.industry = 'IT';
#Display candidate name, company name, and job title for every application
SELECT c.full_name, e.company_name, j.title 
FROM Applications a
JOIN Candidates c ON a.candidate_id = c.candidate_id
JOIN Jobs j ON a.job_id = j.job_id
JOIN Employers e ON j.employer_id = e.employer_id;
#Display interview details along with candidate and company information
SELECT i.*, c.full_name, e.company_name 
FROM Interviews i
JOIN Applications a ON i.application_id = a.application_id
JOIN Candidates c ON a.candidate_id = c.candidate_id
JOIN Jobs j ON a.job_id = j.job_id
JOIN Employers e ON j.employer_id = e.employer_id;
#Display company names with the total number of applications received
SELECT e.company_name, COUNT(a.application_id) AS total_applications 
FROM Employers e
LEFT JOIN Jobs j ON e.employer_id = j.employer_id
LEFT JOIN Applications a ON j.job_id = a.job_id
GROUP BY e.company_name;
#Candidates without applications
SELECT * FROM Candidates 
WHERE candidate_id NOT IN (SELECT DISTINCT candidate_id FROM Applications);
#Display candidates who have never attended an interview
SELECT DISTINCT c.* 
FROM Candidates c
JOIN Applications a ON c.candidate_id = a.candidate_id
WHERE a.application_id NOT IN (SELECT DISTINCT application_id FROM Interviews);
#Create a view named Selected_Candidates showing selected candidates with company and job details
CREATE VIEW Selected_Candidates AS
SELECT c.full_name, e.company_name, j.title, a.status 
FROM Applications a
JOIN Candidates c ON a.candidate_id = c.candidate_id
JOIN Jobs j ON a.job_id = j.job_id
JOIN Employers e ON j.employer_id = e.employer_id
WHERE a.status = 'Selected';
select * from Selected_candidates;
#Create a view to display all active job postings
CREATE VIEW Active_Jobs AS
SELECT * FROM Jobs;
select * from Active_Jobs;
#Retrieve data from the created views
SELECT * FROM Selected_Candidates;
SELECT * FROM Active_Jobs;
#Start a transaction and update application status to Interview Scheduled
START TRANSACTION;
UPDATE Applications 
SET status = 'Interview Scheduled' 
WHERE application_id = 1;
COMMIT;
#Roll back a transaction after deleting an application accidentally
START TRANSACTION;
DELETE FROM Applications WHERE application_id = 1;
ROLLBACK;
#Create a stored procedure to display all jobs offered by a particular employer.
# Input: employer_id
# Display job title, location, and salary.
DELIMITER //
CREATE PROCEDURE GetJobsByEmployer(IN emp_id INT)
BEGIN
    SELECT title, location, salary 
    FROM Jobs 
    WHERE employer_id = emp_id;
END //
DELIMITER ;
#Create a stored procedure to display all applications with a particular status.
# Input: status
# For example, display all Shortlisted applications.
DELIMITER //
CREATE PROCEDURE GetApplicationsByStatus(IN app_status VARCHAR(50))
BEGIN
    SELECT * 
    FROM Applications 
    WHERE status = app_status;
END //
DELIMITER ;
#Create a trigger on the Applications table to log new inserts
CREATE TABLE Application_Log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    application_id INT,
    candidate_id INT,
    job_id INT,
    application_date DATE,
    logged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER trg_after_application_insert
AFTER INSERT ON Applications
FOR EACH ROW
BEGIN
    INSERT INTO Application_Log (application_id, candidate_id, job_id, application_date)
    VALUES (NEW.application_id, NEW.candidate_id, NEW.job_id, NEW.application_date);
END //
DELIMITER ;
#Create a trigger on the Interviews table to archive deleted interviews
CREATE TABLE Interview_Archive (
    archive_id INT AUTO_INCREMENT PRIMARY KEY,
    interview_id INT,
    application_id INT,
    interview_date DATE,
    mode VARCHAR(50),
    result VARCHAR(50),
    deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER trg_after_interview_delete
AFTER DELETE ON Interviews
FOR EACH ROW
BEGIN
    INSERT INTO Interview_Archive (interview_id, application_id, interview_date, mode, result)
    VALUES (OLD.interview_id, OLD.application_id, OLD.interview_date, OLD.mode, OLD.result);
END //
DELIMITER ;

#-------------------------------------------------------------END-----------------------------------------------------------------------------
