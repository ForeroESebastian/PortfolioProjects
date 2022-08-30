-- https://ourworldindata.org/covid-deaths 

--SELECT * from Projects..CovidData
--order by 3,4


--SELECT * from Projects..CovidVaccinations
--order by 3,4


-- Select Data that we will be using 


SELECT Location, date, total_cases, new_cases, total_deaths, population
from projects..CovidDeaths
where continent is not null 
order by 1,2

-- Total Cases vs Total Deaths 
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
from projects..CovidData
Where location = 'United States' and continent is not null 
order by 1,2 

-- Total Cases vs Population 
-- Can one person have multiple cases?
Select location, date, population, total_cases, population, (total_cases/population)*100 as death_percentage
from projects..CovidData
Where location = 'United States' and continent is not null 
order by 1,2 

-- What country has the highest infection rate?
Select location, population, max(total_cases) as max_infection_count, max((total_cases/population))*100 as population_infection_rate
from Projects..CovidData
where continent is not null
group by location, population
order by population_infection_rate desc

-- What countries have the highest death count per population?
Select location, max(cast(total_deaths as int)) as total_death_count
from Projects..CovidData
Where continent is not null
group by location
order by total_death_count desc


-- What continents have the highest death count per population? 
select continent, max(cast(total_deaths as int)) as total_death_count
from Projects..CovidData
Where continent is not null
group by continent
order by total_death_count desc

-- GLOBAL  
select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_death_count, sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percentage 
from Projects..CovidData
where continent is not null 
group by date 
order by 1, 2 

-- Global count of total cases, death total, and death percentage. 
select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_death_count, sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percentage 
from Projects..CovidData
where continent is not null  
order by 1, 2


-- Vaccination Rate / Practicing join query 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as rolling_vaccination_count
from projects..CovidDeaths dea 
join projects..CovidVaccinations vac 
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

