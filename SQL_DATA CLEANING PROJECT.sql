#STANDARDIZING DATA
#use parks_and_recreation

#Getting info
select * from layoffs_staging2
where industry like 'crypto%';

#changing 2 cryptocurrency value to crypto
update layoffs_staging2
set industry='Crypto'
where industry like 'Crypro%';

#CHECKING Location column
select distinct location
from layoffs_staging2
order by 1;

#Correcting issue
update layoffs_staging2
set location='Dusseldorf'
where location like 'DÃ¼sseldorf';

#Correcting issue 2
update layoffs_staging2
set location='Malmo'
where location like 'MalmÃ¶';


#Checking Country column
select distinct country
from layoffs_staging2
order by 1;

#Rectifying issue
update layoffs_staging2
set country='United States'
where country like 'United states.';

#checking other columns
select * from layoffs_staging2;

#date column in text -changing its data type  to date
select `date`,
STR_TO_DATE(`date`,'%m/%d/%Y')
from layoffs_staging2; 


#UPDATING THE DATE COLUMN
update layoffs_staging2
set `date`= str_to_date(`date`,'%m/%d/%Y');

#Looking at null values
select * from layoffs_staging2
where industry is null or industry like '';
#Looking if Company with industry null values is repeating or not
select * from layoffs_staging 
where company='Bally`s Interactive';

#FILLING THE NULL VALUE,AS THE COMPANY HAS VALUE IN ANOTHER ROW
update layoffs_staging2 t1
join layoffs_staging t2 on
t1.company=t2.company and t1.location = t2.location
set t1.industry=t2.industry
where (t1.industry is null or t1.industry='') and (t2.industry is not null and t2.industry!='');

#LOOKING FOR OTHER NULL VALUES

select company,industry,percentage_laid_off from layoffs_staging2
where total_laid_off is null and percentage_laid_off is null;

#DELETING ROWS  WITH NULL VALUES AS IT DOESNT ADD ANY VALUE OR INFO
delete from layoffs_staging2
where  total_laid_off is null and percentage_laid_off is null;
