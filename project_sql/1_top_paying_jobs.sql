--Query 1 for project
--top 10 paying jobs for data analyst roles, remote
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name as company_name 
from 
    job_postings_fact 
left join company_dim on job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_title_short = 'Data Analyst' AND 
    job_location = 'Anywhere' AND
    salary_year_avg is not NULL
order by salary_year_avg DESC
limit 10

--Query 2 of Project
