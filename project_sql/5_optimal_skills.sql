--optimall skills to learn for high demand and high salary
with skills_demand as ( --CTE one
        Select 
        skills_dim.skill_id,
        skills_dim.skills,
        count(skills_job_dim.job_id) as demand_count
    from job_postings_fact
    inner join skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id 
    inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
    where job_title_short = 'Data Analyst' and 
        job_work_from_home = true and 
        salary_year_avg is not NULL
    group by skills_dim.skill_id, skills_dim.skills
    
    ),  average_salary as (--CTE two; but when yo combine multiple CTEs then we have the 'With' only one time at the beginning of first CTE and then put comma and next CTE (without 'WITH')
    Select 
        skills_job_dim.skill_id,
        skills,
        round(AVG(salary_year_avg), 0) as AVG_Salary
    from job_postings_fact
    inner join skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id 
    inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
    where job_title_short = 'Data Analyst' and job_work_from_home = true 
    and salary_year_avg is not NULL
    group by skills_job_dim.skill_id,skills_dim.skills
    
    )

Select
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary 
From 
    skills_demand
inner join average_salary on skills_demand.skill_id = average_salary.skill_id -- this is where you combine the 2 CTE specified above
where demand_count > 10
order by demand_count DESC, avg_salary DESC
limit 25


--same as above, but more concise
Select
    skills_dim.skill_id,
    skills_dim.skills,
    count(skills_job_dim.job_id) as demand_count,
    round(avg(job_postings_fact.salary_year_avg),0) as avg_salary
from 
    job_postings_fact
inner join skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
where
    job_title_short = 'Data Analyst'
    and salary_year_avg is not NULL
    and job_work_from_home = TRUE
Group by 
    skills_dim.skill_id
having 
    count(skills_job_dim.job_id) > 10
Order by
    avg_salary desc,
    demand_count desc
Limit 25       