SELECT *
FROM project..CovidDeaths
where continent is not NULL
ORDER BY 3,4

--SELECT *
--FROM project..CovidVaccinations
--ORDER BY 3,4


-- Select Data that we are going to be using 

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM project..CovidDeaths
where continent is not NULL
ORDER BY 1,2

-- Looking at total cases vs total deaths 
-- show likehood of deaths if you contract covid in your country

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM project..CovidDeaths
WHERE location like '%states%'
and continent is not NULL
ORDER BY 1,2

--Looking at Total cases vs population
-- showing the percentage of population got covid

SELECT location, date, population, total_cases, (total_cases/population)*100 AS DeathPercentage
FROM project..CovidDeaths
WHERE location like '%states%'
and continent is not NULL
ORDER BY 1,2

-- Looking at countries with highest infection rate compared to population


SELECT location, population, MAX(total_cases)as HighestInfectionCount, MAX((total_cases/population))*100 AS PercentagePopulationInfected 
FROM project..CovidDeaths
--WHERE location like '%states%'
GROUP BY location, population
ORDER BY PercentagePopulationInfected desc

-- Showing Countries with highest death count per population

SELECT location,  MAX(cast(total_deaths as int))as TotalDeathCount
FROM project..CovidDeaths
--WHERE location like '%states%'
where continent is not NULL
GROUP BY location
ORDER BY TotalDeathCount desc

--LET'S BREAK THING DOWN BY CONTINENT

-- Showing continents with highest death count per population

SELECT continent,  MAX(cast(total_deaths as int))as TotalDeathCount
FROM project..CovidDeaths
--WHERE location like '%states%'
where continent is not NULL
GROUP BY continent
ORDER BY TotalDeathCount desc

--GLOBEL NUMBERS 

SELECT SUM(new_cases)AS total_cases, SUM(CAST(new_deaths as int)) AS total_deaths, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM project..CovidDeaths
--WHERE location like '%states%'
where continent is not NULL
--GROUP BY date
ORDER BY 1,2

-- Looking at Total Population vs Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location,
 dea.date) as RollingPeopleVaccinated
FROM project..CovidDeaths dea
JOIN project..CovidVaccinations vac
    on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not NULL
ORDER BY 2,3

--USE CTE

With PopvsVac (continent, location, date, population,new_vaccination, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location,
 dea.date) as RollingPeopleVaccinated
FROM project..CovidDeaths dea
JOIN project..CovidVaccinations vac
    on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not NULL
--ORDER BY 2,3
)
SELECT*, (RollingPeopleVaccinated/population) *100
FROM PopvsVac




-- TEMP TABLE 


DROP TABLE if exists #PercentPopulationvaccinated
Create Table #PercentPopulationvaccinated
(
Continent nvarchar(255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccination numeric,
RollingPeopleVaccinated numeric 
)
INSERT INTO #PercentPopulationvaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location,
 dea.date) as RollingPeopleVaccinated
FROM project..CovidDeaths dea
JOIN project..CovidVaccinations vac
    on dea.location=vac.location
	and dea.date=vac.date
--where dea.continent is not NULL
--ORDER BY 2,3
SELECT*, (RollingPeopleVaccinated/population) *100
FROM #PercentPopulationvaccinated


--Creating View to store data for later visulatization

Create View PercentPopulationvaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location,
 dea.date) as RollingPeopleVaccinated
FROM project..CovidDeaths dea
JOIN project..CovidVaccinations vac
    on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not NULL
--ORDER BY 2,3

SELECT *
FROM PercentPopulationvaccinated

