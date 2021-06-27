Select * 
from [Portfolio Project]..CovidDeaths
--where continent is not Null 
order by 3,4

--Select * 
--from [Portfolio Project]..CovidVaccinations
--order by 3,4

----Data Selection
Select location,date, total_cases, new_cases, total_deaths,population
from [Portfolio Project]..CovidDeaths
where continent is not Null 
order by 1,2

----Looking at total cases vs total deaths
Select location,date, total_cases,  total_deaths, (total_deaths/total_cases) *100 as DeathPercentage
 from [Portfolio Project]..CovidDeaths
-- where continent is not Null 
Where location like '%india%'
order by 1,2

----Looking at total cases vs populations
Select location,date, total_cases,  population, (total_cases/population) *100 as CasesPercentage
 from [Portfolio Project]..CovidDeaths
 where continent is not Null 
--Where location like '%india%'
order by 1,2


---Maximum CovidCases Compared to Populations
Select location,population, Max(total_cases) as MaxCases,   MAx(total_cases/population) *100 as MaxPercentageofpeopleaffected
 from [Portfolio Project]..CovidDeaths
 where continent is not Null 
 --Where location like '%india%'
 Group by location, population

order by 4 desc 

---Country with Highest Death Count per population
Select location,max(cast(total_deaths as int)) as totaldeathcount
 from [Portfolio Project]..CovidDeaths
 where continent is not Null 
 --Where location like '%india%'
 Group by location

order by 2 desc 

----------By Continents by max deaths

Select location,max(cast(total_deaths as int)) as totaldeathcount
 from [Portfolio Project]..CovidDeaths
 where continent is  Null 
 --Where location like '%india%'
 Group by location
 order by 2 desc 

 Select continent,max(cast(total_deaths as int)) as totaldeathcount
 from [Portfolio Project]..CovidDeaths
 where continent is not Null 
 --Where location like '%india%'
 Group by continent
 order by 2 desc

 
 --Global Numbers

 Select date, sum(new_cases) as TotalNewCases ,sum(cast(new_deaths as int)) as TotalDeaths, (sum(cast(new_deaths as int))/Sum(new_cases))*100 as DailyPercentDeaths
 from [Portfolio Project]..CovidDeaths
 where continent is not Null 
--Where location like '%india%'
group by date
order by 1,2 

 Select  sum(new_cases) as TotalNewCases ,sum(cast(new_deaths as int)) as TotalDeaths, (sum(cast(new_deaths as int))/Sum(new_cases))*100 as DailyPercentDeaths
 from [Portfolio Project]..CovidDeaths
 where continent is not Null 
--Where location like '%india%'
--group by date
order by 1,2 

----Total population vs vaccination
Select dea.continent,dea.location,dea.date,dea.population,vacc.new_vaccinations,
Sum(cast(vacc.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date ) as RollingPeopleVaccinated
from [Portfolio Project]..CovidVaccinations vacc
join [Portfolio Project]..CovidDeaths dea
on dea.location =vacc.location
and dea.date=vacc.date
where dea.continent is not null 
order by 2,3

----Using CTE

With PopsVacc (Continent, Location, Date, Population,NewVaccinations,  RollingPeopleVaccinated)
as 
(
Select dea.continent,dea.location,dea.date,dea.population,vacc.new_vaccinations,
Sum(cast(vacc.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date ) as RollingPeopleVaccinated
from [Portfolio Project]..CovidVaccinations vacc
join [Portfolio Project]..CovidDeaths dea
on dea.location =vacc.location
and dea.date=vacc.date
where dea.continent is not null 
--order by 2,3
)
Select * ,  (RollingPeopleVaccinated/Population)*100
from PopsVacc


--temp table

Drop table if exists #PercentagePopVaccinated
Create Table #PercentagePopVaccinated
(continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentagePopVaccinated
Select dea.continent,dea.location,dea.date,dea.population,vacc.new_vaccinations,
Sum(cast(vacc.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date ) as RollingPeopleVaccinated
from [Portfolio Project]..CovidVaccinations vacc
join [Portfolio Project]..CovidDeaths dea
on dea.location =vacc.location
and dea.date=vacc.date
where dea.continent is not null 
order by 2,3

Select * ,  (RollingPeopleVaccinated/Population)*100
from #PercentagePopVaccinated


---Creating View

Create View PercentagePopVaccinated as 
Select dea.continent,dea.location,dea.date,dea.population,vacc.new_vaccinations,
Sum(cast(vacc.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date ) as RollingPeopleVaccinated
from [Portfolio Project]..CovidVaccinations vacc
join [Portfolio Project]..CovidDeaths dea
on dea.location =vacc.location
and dea.date=vacc.date
where dea.continent is not null 
--order by 2,3

Select * 
From PercentagePopVaccinated


--------------------------------------------------------------
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


