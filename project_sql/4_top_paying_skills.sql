Select 
    skills,
    round(AVG(salary_year_avg), 0) as AVG_Salary
from job_postings_fact
inner join skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id 
inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
where job_title_short = 'Data Analyst' and job_work_from_home = true 
and salary_year_avg is not NULL
group by skills
order by AVG_Salary desc
limit 25 