--Tableau Coding
Select Sum(new_cases) as Total_Cases ,Sum(cast(new_deaths as int)) as Total_Death,Sum(cast(new_deaths as int))/Sum(New_Cases)*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths
where continent is not null

---------
--2

Select location, Sum(cast(new_deaths as int)) as Total_Death
from [Portfolio Project]..CovidDeaths

where continent is null
and location not in ('World', 'European Union', 'International')
group by location
order by 1,2


------
--3

Select location, population,Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
from [Portfolio Project]..CovidDeaths
Group by location, population
order by 4 desc

--4

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From [Portfolio Project]..CovidDeaths

Group by Location, Population, date
order by PercentPopulationInfected desc
