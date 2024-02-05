create database HR;

use HR;


SELECT * FROM hr.`human resources`;

-- Data Cleaning and Preprocessing 

ALTER Table `human resources`
change column ï»¿id emp_id VARCHAR(20) NULL;

DESCRIBE `human resources`;

SELECT * FROM hr.`human resources`;

SET sql_safe_updates = 0;

UPDATE `human resources`
SET birthdate = CASE 
                WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate,'%m/%d/%Y'),'%Y-%m-%d')
				WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate,'%m-%d-%Y'),'%Y-%m-%d')
                ELSE NULL
                END;
                
ALTER table `human resources`
modify column birthdate date;

                
  
-- Changing the data format and data type of hire date column

UPDATE `human resources`
SET hire_date = CASE 
                WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date,'%m/%d/%Y'),'%Y-%m-%d')
				WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date,'%m-%d-%Y'),'%Y-%m-%d')
                ELSE NULL
                END;
                
 ALTER table `human resources`
modify column hire_date date;      
         

DESCRIBE `human resources`;   



 -- Changing the data format and data type of term date column     

UPDATE `human resources`
set termdate = date(str_to_date(termdate,'%Y-%m-%d %H:%i:%s UTC'))
where termdate IS NOT NULL AND termdate != '';

UPDATE  `human resources`
set termdate = NULL
where termdate ='';

SELECT * FROM hr.`human resources`;




-- Creating an age column

ALTER table `human resources`
ADD column age int;


UPDATE `human resources`
SET age = timestampdiff(YEAR,birthdate,curdate());

SELECT min(age), max(age) from `human resources`;




-- Checking the gender distribution in the company 

SELECT gender, COUNT(*) as Count
from `human resources`
WHERE termdate is NULL
GROUP BY gender;

-- Checking the race breakdown of employees in the company 

SELECT race, COUNT(*) as Count
from `human resources`
WHERE termdate is NULL
GROUP BY race;


-- Checking the Age distribution of employess in the company 

SELECT 
      CASE 
      WHEN age >=18 AND age<= 24 THEN '18-24'
      WHEN age>=25 AND  age <=34 THEN '25-34'
      WHEN age >=35 AND age <=44 THEN '35-44'
      WHEN age >=45 AND age <=54 THEN '45-54'
      WHEN age >=55 AND age <=64 THEN '55-64'
      ELSE '65+'
      END AS age_group, COUNT(*)
      from `human resources`
      WHERE termdate is NULL
      GROUP BY age_group
      ORDER BY 1;
      
      
--  Checkimng employess working locations 
      
SELECT location , COUNT(*) as location_counts
from `human resources`
WHERE termdate is NULL
GROUP BY location;


-- Checking the average length of employement who have been terminated

SELECT ROUND(AVG(year(termdate) - year(hire_date)),0) as leng_of_emp
from `human resources`
WHERE termdate is NOT NULL and  termdate<= curdate();


-- Checking the gender distribution vary across department and job titles

SELECT department, gender, COUNT(*) 
from `human resources`
WHERE termdate is NOT NULL 
GROUP BY department, gender;

SELECT jobtitle, gender, COUNT(*) 
from `human resources`
WHERE termdate is NOT NULL 
GROUP BY jobtitle, gender;


-- Checking the distribution of job titles

SELECT jobtitle , COUNT(*) as location_counts
from `human resources`
WHERE termdate is NULL
GROUP BY jobtitle;


-- Checking the which department has rthe highest termiantion rate

SELECT department,  COUNT(*) as total_counts,
	   count(Case 
                 WHEN termdate is NOT NULL and termdate <= curdate() THEN 1
                 END ) as terminated_count,
	   ROUND((count(Case 
                 WHEN termdate is NOT NULL and termdate <= curdate() THEN 1
                 END ) / COUNT(*))*100,1) as Termination_rate
                 
from `human resources`
GROUP BY department
ORDER BY 4;



-- Checking the distribution of employees across location state 

SELECT location_state, COUNT(*) 
from `human resources`
WHERE termdate is  NULL 
GROUP BY location_state;


-- Checking the distribution of employees across location city

SELECT location_city, COUNT(*) 
from `human resources`
WHERE termdate is  NULL 
GROUP BY location_city;



-- Checking the company employee count changed over time based on hire and termination date 


select year,
      hires,
      terminations,
      hires-terminations as net_change,
      (terminations/hires) * 100 as percentage_change
   from (
        SELECT YEAR(hire_date) as year ,
	    COUNT(*) as hires,
        sum(case 
              WHEN termdate IS NOT NULL and termdate <= curdate() THEN 1
              END ) as terminations
       from `human resources`
       group by YEAR(hire_date)) as sub_query 
group by year
order by 1;


-- Checking the tenure distribution for each department 

SELECT department, ROUND(avg(datediff(termdate,hire_date)/365),0) as avg_tenure
from `human resources`
WHERE termdate is NOT NULL AND termdate<= curdate()	
group by department;


-- Termination and Gender Breakdown by gender wise

select gender,
      total_hires,
      total_terminations,
      total_hires-total_terminations as net_change,
      (total_terminations/total_hires) * 100 as percentage_change
   from (
        SELECT gender ,
	    COUNT(*) as total_hires,
        sum(case 
              WHEN termdate IS NOT NULL and termdate <= curdate() THEN 1
              END ) as total_terminations
       from `human resources`
       group by gender) as sub_query 
group by gender;


-- Termination and Gender Breakdown by Age wise

select age,
      total_hires,
      total_terminations,
      total_hires-total_terminations as net_change,
      (total_terminations/total_hires) * 100 as percentage_change
   from (
        SELECT age,
	    COUNT(*) as total_hires,
        sum(case 
              WHEN termdate IS NOT NULL and termdate <= curdate() THEN 1
              END ) as total_terminations
       from `human resources`
       group by age) as sub_query 
group by age;


-- Termination and Gender Breakdown by department wise

select department,
      total_hires,
      total_terminations,
      total_hires-total_terminations as net_change,
      (total_terminations/total_hires) * 100 as percentage_change
   from (
        SELECT department,
	    COUNT(*) as total_hires,
        sum(case 
              WHEN termdate IS NOT NULL and termdate <= curdate() THEN 1
              END ) as total_terminations
       from `human resources`
       group by department) as sub_query 
group by department;



      














             
                



