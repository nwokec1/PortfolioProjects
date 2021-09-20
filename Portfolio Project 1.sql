--Joins both Tables and selects the entire Table

select *
from PortfolioProject..DeathNumbers1 one
join PortfolioProject..DeathNumbers2 two
	on one.Entity = two.Entity
	and one.Year = two.Year


--Takes total dietary deaths from both tables by country and year

select one.Entity as "Country", one.Year, sum(one.Diet_low_in_fruits + one.Diet_low_in_vegetables + two.Diet_high_in_sodium + two.Diet_low_in_nuts_and_seeds + two.Diet_low_in_whole_grains) as "Dietary Deaths"
from PortfolioProject..DeathNumbers1 one
join PortfolioProject..DeathNumbers2 two
	on one.Entity = two.Entity
	and one.Year = two.Year
	and one.Code = two.Code
group by one.Entity, one.Year


--Shows percentage for Types of Air Pollution Deaths in Countries in the year 2017

select one.Entity as "Country", one.year, sum(two.Air_pollution)/sum(two.Air_pollution + two.Outdoor_air_pollution)*100 as "Indoor Air Pollution Percentage", sum(two.Outdoor_air_pollution)/sum(two.Air_pollution + two.Outdoor_air_pollution)*100 as "Outdoor Air Pollution Percentage",  sum(two.Air_pollution + two.Outdoor_air_pollution) as "Air Pollution Total" 
from PortfolioProject..DeathNumbers1 one
join PortfolioProject..DeathNumbers2 two
	on one.Entity = two.Entity
	and one.Year = two.Year
	and one.Code = two.Code
where one.year = 2017
group by one.Entity, one.Year

--This Query Selects Unsafe Sex Totals for all years by each year's unsafe sex number count by using Partition by method

select  Entity as "Country", year, Unsafe_sex, sum(Unsafe_sex) over (partition by Entity) as "Unsafe Sex Total per Country"
from PortfolioProject..DeathNumbers1


--Used CTE to display Dietary problems in United states and the percentages

with dietissues (country, Year, high_sodium, bmi, high_glucose, blood_pressure)
as 
(
select one.Entity, one. year, two.Diet_high_in_sodium, two.High_body_mass_index, two.High_fasting_plasma_glucose, two.High_systolic_blood_pressure
from PortfolioProject..DeathNumbers1 one
join PortfolioProject..DeathNumbers2 two
	on one.Entity = two.Entity
	and one.Year = two.Year
	and one.Code = two.Code
)
select country as "Country", year as "Year", high_sodium/(high_sodium + bmi + high_glucose + blood_pressure)*100 as"High Sodium Percentage", bmi/(high_sodium + bmi + high_glucose + blood_pressure)*100 as "BMI Death Percentage", high_glucose/(high_sodium + bmi + high_glucose + blood_pressure)*100 as "High Glucose Percentage", blood_pressure/(high_sodium + bmi + high_glucose + blood_pressure)*100 as "Blood Pressure Percentage",(high_sodium + bmi + high_glucose + blood_pressure) as "Total Dietary Death Number"
from dietissues
where country = 'United States'


--Creates a temporary table using existing data from original data

drop table if exists #EnvironmentalIssues
create table #EnvironmentalIssues
(
country nvarchar(255),
year nvarchar(255),
unsafe_water_source numeric,
unsafe_sanitation numeric,
air_pollution numeric,
outdoor_air_pollution numeric
)
insert into #EnvironmentalIssues
select one.Entity, one.Year, one.Unsafe_water_source, one.Unsafe_sanitation, two.Air_pollution, two.Outdoor_air_pollution
from PortfolioProject..DeathNumbers1 one
join PortfolioProject..DeathNumbers2 two
	on one.Entity = two.Entity 
	and one.year = two.year

select *
from #EnvironmentalIssues


--Creates a view

create view NigerianEnviromentalIssues as
select one.Entity, one.Year, one.Unsafe_water_source, one.Unsafe_sanitation, two.Air_pollution, two.Outdoor_air_pollution, (one.Unsafe_water_source + one.Unsafe_sanitation + two.Air_pollution + two.Outdoor_air_pollution) as "Total Deaths"
from PortfolioProject..DeathNumbers1 one
join PortfolioProject..DeathNumbers2 two
	on one.Entity = two.Entity 
	and one.year = two.year
where one.Entity = 'Nigeria'


--Using case to eliminate Nulls and replace them with zero to add the cholesterol number to sodium to bring the total

with dietissues2 (Country, Year, High_cholesterol, High_sodium)
as
(
select one.Entity, one.year, case when two.High_total_cholesterol is null then 0 else two.High_total_cholesterol end as "High Cholesterol", two.Diet_high_in_sodium
from PortfolioProject..DeathNumbers1 one
join PortfolioProject..DeathNumbers2 two
	on one.Entity = two.Entity
	and one.year = two.year
)
select Year, sum(High_cholesterol) as High_Cholesterol,sum(High_sodium) as High_Sodium, sum(High_cholesterol + High_sodium) as Total
from dietissues2
group by Year
order by Total desc

--Alcohol and Drug use Deaths for tableu Visualization in the US for years 2008 - 2017

with aduse (Country, Year, Alcohol_Deaths, Drug_Deaths, Total)
as
(
select one.Entity, one.year, one.Alcohol_use, one.Drug_use, (one.Alcohol_use + one.Drug_use)
from PortfolioProject..DeathNumbers1 one
join PortfolioProject..DeathNumbers2 two
	on one.Entity = two.Entity
	and one.Year = two.Year
where (one.Entity = 'United States') and (one.year >= 2008)
)
select Year,Alcohol_Deaths,Drug_Deaths,cast((Alcohol_Deaths-Drug_Deaths)/Drug_Deaths*100 as int) as "%Difference_A_vs_D", Total
from aduse

--Chart for number of Deaths in Countries with unsafe water, sanitation and handwashing facilities for the year 2017

select Entity as Country,  (Unsafe_sanitation + Unsafe_sanitation + No_handwashing_facility) as "Unsanitary_Death_Totals"
from PortfolioProject..DeathNumbers1
where (Year = 2017) and Entity not in ('World','Caribbean','Central Asia','Central Europe','Central Europe, Eastern Europe, and Central Asia','Central Latin America','Central Sub-Saharan Africa','Latin America and Caribbean','Low SDI','Low-middle SDI','Middle SDI','Micronesia (country)','North Africa and Middle East','South Asia','Southeast Asia','Southeast Asia, East Asia, and Oceania','Southern Latin America','Southern Sub-Saharan Africa','Sub-Saharan Africa','Western Europe','Western Sub-Saharan Africa')

--World Second hand smoke deaths in the last 5 years.

select entity as Country, year, Secondhand_smoke
from PortfolioProject..DeathNumbers1


--United States Dietary Deaths for ten years

select year, Diet_low_in_fruits,Diet_low_in_vegetables, Low_physical_activity, (Diet_low_in_fruits + Diet_low_in_vegetables + Low_physical_activity) as Total
from PortfolioProject..DeathNumbers1
where year >= 2008 and Entity = 'United States'