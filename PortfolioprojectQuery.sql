----select *
----from CovidDeaths$
----order by 3,4

----select *
----from CovidVaccinations$  
----order by 3,4

----select location, date, total_cases, new_cases, total_deaths, population
----from CovidDeaths$
----order by 1,2

---- Looking at Total Cases vs Total Deaths
----percent of chance of death if infected

----select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
----from CovidDeaths$
----where location like '%states%'
----order by 1,2


----LOOKING AT TOTAL CASES VS POPULATION
----SHOWS PERCENT OF POPULATION GOT INFECTED.
--select location, date,population, total_cases , (total_cases/population)*100 as Infection_Percentage
--from CovidDeaths$
----where location like '%states%'
--order by 1,2

----LOOKING AT COUNTRIES WITH HIGHEST INFECTION RATE 

--select location,population, MAX(total_cases) as HighestInfection , MAX((total_cases/population))*100 as Infection_Percentage
--from CovidDeaths$
--group by population,location
--order by Infection_Percentage desc

--SHOWING COUNTRIES WITH HIGHEST DEATH COUNTS

--select location, MAX(CAST(total_deaths as int)) AS TotalDeathCount
--FROM CovidDeaths$
--Where continent is not null
--GROUP BY location
--ORDER BY TotalDeathCount DESC

--SHOWING DEATH COUNT WITH CONTINENTS
-- select continent, MAX(CAST(total_deaths as int)) AS TotalDeathCount
--FROM CovidDeaths$
--Where continent is not null
--GROUP BY continent
--ORDER BY TotalDeathCount DESC

--GLOBAL CASE AS PER DATE

--SELECT SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, (SUM(cast(new_deaths as int))/ SUM(new_cases))*100 as DeathPercentage
--FROM CovidDeaths$
--where continent is not null
----group by date
--order by 1,2


--JOINING BOTH TABLES
SELECT * 
FROM CovidDeaths$ dea
JOIN CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date


-- LOOKING AT TOTAL POPULATION VS VACCINATIONS

--select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
--SUM(CONVERT(INT, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as DailyPeopleVaccinated
--FROM PortfolioProject..CovidDeaths$ dea
--JOIN PortfolioProject..CovidVaccinations$ vac
--	on dea.location = vac.location
--	and dea.date = vac.date
--	where dea.continent is not null
--order by 2,3

-- USE CTE

--With PopVsVac (continent , location ,date, population, new_vaccinations, DailyPeopleVaccinated)
--as 
--(
--select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
--SUM(CONVERT(INT, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as DailyPeopleVaccinated
--FROM PortfolioProject..CovidDeaths$ dea
--JOIN PortfolioProject..CovidVaccinations$ vac
--	on dea.location = vac.location
--	and dea.date = vac.date
--	where dea.continent is not null
----order by 2,3
--)

--select *, (DailyPeopleVaccinated/population)*100 
--from PopVsVac



----TEMP TABLE
--DROP TABLE if exists #PercentPopulationVaccinated
--Create Table #PercentPopulationVaccinated
--(
--Continent nvarchar(255),
--Location nvarchar(255),
--date datetime,
--Population numeric,
--new_vaccinations numeric,
--DailyPeopleVaccinated numeric
--)

--INSERT into #PercentPopulationVaccinated
--select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
--SUM(CONVERT(INT, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as DailyPeopleVaccinated
--FROM PortfolioProject..CovidDeaths$ dea
--JOIN PortfolioProject..CovidVaccinations$ vac
--	on dea.location = vac.location
--	and dea.date = vac.date
--	--where dea.continent is not null
----order by 2,3

--select *, (DailyPeopleVaccinated/population)*100 
--From #PercentPopulationVaccinated


-- CREATING VIEW TP STORE DATA FOR VISUALIZATION

Create View percentagePopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(INT, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as DailyPeopleVaccinated
FROM PortfolioProject..CovidDeaths$ dea
JOIN PortfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
--order by 2,3

Select * 
From percentagePopulationVaccinated