-- Testing tables
Select * from PortfolioProject..CovidDeaths
order by 3,4 --> order by column 3 and 4

Select * from PortfolioProject..CovidVaccinations
order by 3,4

-- basic calculations
Select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2


-- Total cases vs Total Deaths in India 
Select location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
from PortfolioProject..CovidDeaths
where location like 'India'
order by 1,2


-- Total cases vs Total Population in India 
Select location, date, total_cases,population, (total_cases/population)*100 as Affected_People_Percentage
from PortfolioProject..CovidDeaths
where location like 'India'
order by 1,2


--Countries with Highest Infection Rate compared to Population
Select location, population, max(total_cases) as Highest_Infected, max((total_cases/population)*100) as Affected_People_Percentage
from PortfolioProject..CovidDeaths
--where location like 'India'
group by location, population
order by Affected_People_Percentage desc


-- Showing Countries with the highest death count per population
Select location, Max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc

-- Showing Continent with the highest death count per population
Select location, Max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is null
group by location
order by TotalDeathCount desc

-- Global Numbers
Select date, Sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percentage
from PortfolioProject..CovidDeaths
where continent is not null
group by date
order by 1,2


-- Joins 

--Shows Percentage of Population that has recieved at least one Covid Vaccine
select d.continent, d.location, d.date, d.population, v.new_vaccinations,
sum(cast(v.new_vaccinations as int)) over (partition by d.location Order by d.location, d.Date) as People_vactinated
from PortfolioProject..CovidDeaths as d
join PortfolioProject..CovidVaccinations as v
	on d.location = v.location
	and d.date = v.date
where d.continent is not null
order by 2,3

--CTE
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)*100 as RollingPeopleVaccinated_Percentage
From PopvsVac



-- Temp table
Drop table if exists #PercentPopulationvacctinationed
create table #PercentPopulationvacctinationed
( continent nvarchar(255),
	location nvarchar(255),
	date datetime,
	population numeric,
	New_vacctionations numeric,
	RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationvacctinationed
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

Select *, (RollingPeopleVaccinated/Population)*100 as RollingPeopleVaccinated_Percentage
From #PercentPopulationvacctinationed

