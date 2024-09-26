#EXPLORATORY DATA ANALYSIS
#use parks_and_recreatis


#FINDING OUT WHICH INDUSTRY HAD MAX LAYOFSS
select sum(total_laid_off),industry
from layoffs_staging2
group by industry
order by max(total_laid_off) desc;

#FINDING LAID_OFF NUMBER COMPANY WISE
select max(total_laid_off) as max_number,company
from layoffs_staging2
group by company
order by max_number desc;

#FINDING TOTAL NUMBER OF LAID_OFF EMPLOYEES THROUGH COMPANIES

select sum(total_laid_off) as total_number,company
from layoffs_staging2
group by company
order by total_number  desc;

#PERCENTAGE LAIDOFF IN EACH COMPANY
select sum(percentage_laid_off) as total_percentage,company
from layoffs_staging2
group by company
order by total_percentage desc;

#FINDING LAIDOFF NUMBER IN COUNTRIES
select sum(total_laid_off) as total_numbers,country
from layoffs_staging2
group by country
order by total_numbers desc;

#FINDING LAIDOF NUMBER THROUGH YEARS
select sum(total_laid_off) as total,YEAR(`date`)
from layoffs_staging2
group by YEAR(`date`)
order by total desc;

#GROUPING LAYOFFS THROUGH STAGES
select sum(total_laid_off) as total,stage
from layoffs_staging2
group by stage
order by total desc;

#LAYOFFS ACROSS MONTHS AND TOTAL
with rolling_sum as
(
select substr(`date`,1,7) as `month`,sum(total_laid_off) as total_off
from layoffs_staging2
where substr(`date`,1,7) is not null 
group by `month`
order by 1 asc
)
select `month`,sum(total_off) over(order by `month`)
from rolling_sum;

#LAYOFFS ACROSS COMPANIES IN YEARS
select company,YEAR(`date`),sum(total_laid_off) as totals_out
from layoffs_staging2
group by company,`date`
order by totals_out desc;


#LAYOFFS ACROSS INDUSTRY AND COMPANY IN YEARS
select company,industry,YEAR(`date`),sum(total_laid_off) as totals
from layoffs_staging2
group by company,industry,year(`date`)
order by totals desc;


#LAYOFF PERCENTAGE THROUGH YEARS ACROSS INDUSTRIES
select sum(percentage_laid_off)as sumpercentage,year(`date`),industry
from layoffs_staging2
group by industry,year(`date`)
order by sumpercentage desc;

#LAYOFFS THROUGH YEAR AT EACH COMPANY
with company_lay_year(company,years,total_laid_off) as
(
select company,year(`date`),sum(total_laid_off)
from layoffs_staging2
group by company,year(`date`)
),company_rank as
(select *,dense_rank() over (partition by years order by total_laid_off desc) as ranking
from company_lay_year
where years is not null)
select * from company_rank
where ranking<5