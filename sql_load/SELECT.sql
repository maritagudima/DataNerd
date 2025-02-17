SELECT 
    count (job_id) as Number_of_Jobs,
    case
        when job_location = 'Anywhere' then 'Remote'
        when job_location = 'New York, NY' then 'Local'
        else 'Onsite'
    end as location_category
from job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
group BY location_category; 

Select
        CASE
        when salary_year_avg > 400000 then 'High'
        when salary_year_avg < 100000 then 'Low'
        else 'Standard'
        end as Salary_Bucket,
    Count (job_id) as Number_jobs
from job_postings_fact
WHERE
  job_title_short = 'Data Analyst'  
Group by Salary_bucket

--wants me to include salary_year_avg in the group by if i want to order it from high to low 
--but then it shows all the bobs on individual line and not on aggregated line 
--based on salary bucket, whyyyy????

--ORDER BY
    --salary_year_avg DESC

select 
    company_id,
    name as company_name
from 
    company_dim
where company_id in ( --subquery starts here
    select
        company_id 
    from 
        job_postings_fact 
    where
        job_no_degree_mention = true
    order by 
        company_id
)  --subqyery ends here  

with job_company_count as ( -- CTE starts here, always defined with WITH
    select 
        company_id,
        count(*) as Total_jobs
    from 
        job_postings_fact
    group by 
        company_id
) -- CTE ends here

select 
    company_dim.name as Company_Name,
    job_company_count.Total_jobs
from company_dim
left join job_company_count on job_company_count.company_id = company_dim.company_id
order by Total_jobs DESC;




--Practice problem 7
--top 5 skills for remote jobs for data analyst

with remote_jobs_skills as ( --CTE starts here
select 
    
    skill_id,
    count (*) as Skill_Count
from 
   skills_job_dim as skills_to_job
inner join job_postings_fact as job_postings on job_postings.job_id = skills_to_job.job_id
where
job_postings.job_work_from_home = true and job_postings.job_title_short = 'Data Analyst'
group by 
skill_id) --CTE ends here

select 
    skills.skill_id,
    skills as skill_name,
    skill_count
from remote_jobs_skills

inner join skills_dim as skills on skills.skill_id = remote_jobs_skills.skill_id 
order by skill_count DESC
limit 5;


--Practice Problem 2 Subquery



/*
with company_size as (
    select 
    case
    when count(job_ID) < 10 then 'Small'
    when count(job_id) > 50 then 'Large'
    else 'Medium'
    end as company_size ,
    company_id
    from job_postings_fact
    group by job_postings_fact.company_id

)
*/

select
name as company_name,
--count (job_id) as Job_Number,
company_size
from
company_dim

where company_size in (select 
    case
    when count(job_ID) < 10 then 'Small'
    when count(job_id) > 50 then 'Large'
    else 'Medium'
    end as company_size ,
    company_id
    from job_postings_fact
    group by job_postings_fact.company_id
)
/*where company_name in ( 
    select
company_dim.name
from
company_dim
inner join company_dim on company_dim.company_id = job_postings_fact.company_id
)*/
group BY
company_name
--inner join company_dim on company_dim.company_id = job_postings_fact.company_id
limit 100 

--attempt 2

/*select 
    company_id,
    name as company_name
    
from 
    company_dim
where company_id in ( --subquery starts here
    select
        job_postings_fact.company_id,
        count(job_id) as Number_Jobs
    from 
        job_postings_fact 
    inner join company_dim on company_dim.company_id = job_postings_fact.company_id
    group by job_postings_fact.company_id
    order by 
        job_postings_fact.company_id
) 
*/

--this works , kind of, i think, but is it what was required how was required?
--practice problem 2 on subquery and CTEﬁ
with company_size as (
    select 
    case
    when count(job_ID) < 10 then 'Small'
    when count(job_id) > 50 then 'Large'
    else 'Medium'
    end as company_size ,
    company_id
    from job_postings_fact
    group by job_postings_fact.company_id
)
select
company_size.company_id,
company_dim.name,
company_size,
count (job_id) as Number_of_jobs

from company_size 

inner join job_postings_fact on job_postings_fact.company_id = company_size.company_id
inner join company_dim on company_dim.company_id = job_postings_fact.company_id
group by company_size.company_id, company_size.company_size, company_dim.name
order by number_of_jobs;


--UNIONS

Select
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs

UNION

Select
    job_title_short,
    company_id,
    job_location
FROM
    february_jobs
UNION

Select
    job_title_short,
    company_id,
    job_location
FROM
    march_jobs


--Practice problem 8 (video 2.54h)  
Select 
    quarter1_job_postings.job_title_short,
    quarter1_job_postings.job_location,
    quarter1_job_postings.job_via,
    quarter1_job_postings.job_posted_date :: date,
    quarter1_job_postings.salary_year_avg
from (
    select *
    from january_jobs
    union all
    select *
    from february_jobs
    union all
    select *
    from march_jobs
) as quarter1_job_postings
where
    quarter1_job_postings.salary_year_avg > 70000 and
    quarter1_job_postings.job_title_short = 'Data Analyst'
order by quarter1_job_postings.salary_year_avg DESC
