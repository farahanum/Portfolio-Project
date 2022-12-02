Select * 
from PortfolioProject..CovidVaccination$

Select * 
from PortfolioProject..Sheet1$
where continent is not null

Select Location,date,total_cases,new_cases,total_deaths,population 
from PortfolioProject..sheet1$
order by location,date

--looking at total cases vs total death
Select Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..sheet1$
where location like '%states%'
order by location,date

-- looking at total cases vs population
Select Location,date,population,total_cases,(total_cases/population)* 100 as PercentPopulationInfected
from PortfolioProject..sheet1$
--where location like '%states%'
order by location,date

--looking at countries with highest infection rate compared to population
Select Location,population,MAX(total_cases)as HighestInfectionCount,MAX((total_cases/population))* 100 as PercentPopulationInfected
from PortfolioProject..sheet1$
--where location like '%states%'
group by location,population
order by PercentPopulationInfected Desc

--Showing countries with highest death count per population
Select Location,MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..sheet1$
--where location like '%states%'
where continent is not null
group by location
order by TotalDeathCount Desc

--Global number
Select SUM(new_cases)as Total_cases, SUM(CAST(new_deaths as int)) as Total_death, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..Sheet1$


--looking at total population vs vaccination

Select death.continent,death.location, death.date , death.population ,vac.new_vaccinations,
SUM( cast (vac.new_vaccinations as bigint))over (partition by death.location order by death.location,death.date rows unbounded preceding)as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject..sheet1$ death
join PortfolioProject..CovidVaccination$ vac
 on death.location= vac.location
 and death.date= vac.date
 where death.continent is not null
 order by 2,3



-- use CTE

with PopvsVac (continent,location,date,population,new_vaccinations, RollingPeopleVaccinated)
as
(
Select death.continent,death.location, death.date , death.population ,vac.new_vaccinations,
SUM( cast (vac.new_vaccinations as bigint))over (partition by death.location order by death.location,death.date rows unbounded preceding)as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject..sheet1$ death
join PortfolioProject..CovidVaccination$ vac
 on death.location= vac.location
 and death.date= vac.date
 where death.continent is not null
 --order by 2,3
 )
 Select *,(RollingPeopleVaccinated/population)*100
 from PopvsVac


 --TEMP TABLE

DROP table if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
Select death.continent,death.location, death.date , death.population ,vac.new_vaccinations,
SUM( cast (vac.new_vaccinations as bigint))over (partition by death.location order by death.location,death.date rows unbounded preceding)as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject..sheet1$ death
join PortfolioProject..CovidVaccination$ vac
 on death.location= vac.location
 and death.date= vac.date
 --where death.continent is not null
 --order by 2,3

 Select *,(RollingPeopleVaccinated/population)*100
 from #PercentPopulationVaccinated

 --Creating views to store data for later visualization
Create View PercentPopulationVaccinated as
Select death.continent,death.location, death.date , death.population ,vac.new_vaccinations,
SUM( cast (vac.new_vaccinations as bigint))over (partition by death.location order by death.location,death.date rows unbounded preceding)as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject..sheet1$ death
join PortfolioProject..CovidVaccination$ vac
 on death.location= vac.location
 and death.date= vac.date
 where death.continent is not null
 --order by 2,3

 Select *
 from PercentPopulationVaccinated


Create View GlobalNumber as
Select SUM(new_cases)as Total_cases, SUM(CAST(new_deaths as int)) as Total_death, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..Sheet1$

