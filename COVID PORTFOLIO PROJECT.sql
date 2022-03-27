SELECT *
FROM [Portafolio Project]..CovidDeaths

ORDER BY 3,4

--SELECT *
--FROM [Portafolio Project]..CovidVaccinations
--ORDER BY 3,4

-- Select data that is gonna be useful

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM [Portafolio Project]..CovidDeaths
ORDER BY 1,2

--Looking at total cases vs total deaths
-- shows the likelihood of dying if you contract covid in your country
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM [Portafolio Project]..CovidDeaths
WHERE location LIKE '%States%'
ORDER BY 1,2

--Looking at total cases vs population
--Shows what % of population got covid
SELECT location, date, total_cases, population, (total_cases/population)*100 AS PopInfectedPercentage
FROM [Portafolio Project]..CovidDeaths
WHERE location LIKE '%States%'
ORDER BY 1,2

--Looking at countries with highest infection rate compared to population

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PopInfectedPercentage
FROM [Portafolio Project]..CovidDeaths
GROUP BY population,location

ORDER BY 4 DESC

--Lets break things down by continent

SELECT location, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM [Portafolio Project]..CovidDeaths
WHERE continent is NULL
GROUP BY location
ORDER BY 2 DESC

--Showing the countries with the highest death count per population

SELECT location, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM [Portafolio Project]..CovidDeaths
WHERE continent is NOT NULL
GROUP BY location
ORDER BY 2 DESC

-- showing the continents with the highest death count

SELECT continent, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM [Portafolio Project]..CovidDeaths
WHERE continent is NOT NULL
GROUP BY continent
ORDER BY 2 DESC


-- GLOBAL NUMEBERS

SELECT date, SUM(new_cases) AS TotalCases, SUM(CAST(new_deaths AS INT)) AS TotalDeaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS DeathPercentage
FROM [Portafolio Project]..CovidDeaths
--WHERE location LIKE '%States%'
GROUP BY date
HAVING SUM(new_cases) != 0
ORDER BY 1,2


SELECT SUM(new_cases) AS TotalCases, SUM(CAST(new_deaths AS INT)) AS TotalDeaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS DeathPercentage
FROM [Portafolio Project]..CovidDeaths
--WHERE location LIKE '%States%'
--GROUP BY date
HAVING SUM(new_cases) != 0
ORDER BY 1,2



--Looking at total population vs total vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM [Portafolio Project]..CovidDeaths dea
JOIN [Portafolio Project]..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3

--COUNT PER DAY VACCINATIONS

SELECT dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations, 
SUM(CONVERT(float, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
FROM [Portafolio Project]..CovidDeaths dea
JOIN [Portafolio Project]..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3


--USE CTE

WITH PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations, 
SUM(CONVERT(float, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
FROM [Portafolio Project]..CovidDeaths dea
JOIN [Portafolio Project]..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
)
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac


--Temp Table
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date Datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations, 
SUM(CONVERT(float, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
FROM [Portafolio Project]..CovidDeaths dea
JOIN [Portafolio Project]..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated


--creating view to store data for later visualisations


USE [Portafolio Project]

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations, 
SUM(CONVERT(float, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
FROM [Portafolio Project]..CovidDeaths dea
JOIN [Portafolio Project]..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

SELECT *
FROM PercentPopulationVaccinated

--2nd view
CREATE VIEW TotalDeathCountPerContinent AS
SELECT continent, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM [Portafolio Project]..CovidDeaths
WHERE continent is NOT NULL
GROUP BY continent
--ORDER BY 2 DESC

SELECT *
FROM TotalDeathCountPerContinent

--3rd view

CREATE VIEW PercentageOfPopulationInfected AS
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PopInfectedPercentage
FROM [Portafolio Project]..CovidDeaths
GROUP BY population,location
--ORDER BY 4

