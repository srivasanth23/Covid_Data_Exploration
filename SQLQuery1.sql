Select * from PortfolioProject..CovidDeaths
order by 3,4 --> order by column 3 and 4

--Select * from PortfolioProject..CovidVaccinations
--order by 3,4

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

-- Showing contintents with the highest death count per population

Select location, Max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc
