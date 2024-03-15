SELECT *
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3,4

--SELECT *
--FROM PortfolioProject..CovidVaccinations
--ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as Deathsper
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
AND location LIKE '%Morocco'
ORDER BY 1,2


SELECT location, date, total_cases, population, (total_cases/population) * 100 as percentonfection
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
AND  location LIKE '%Morocco'
ORDER BY 1,2


SELECT location, population, MAX(total_cases) as HigherInfection, MAX(total_cases/population) * 100 AS percentonfection
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY percentonfection DESC


SELECT location,MAX(cast(total_deaths as int)) AS totalDeath
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY totalDeath DESC


SELECT location, MAX(cast(total_deaths as int)) AS totalDeath
FROM PortfolioProject..CovidDeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY totalDeath DESC




SELECT sum(new_cases) AS TotalCases, SUM(CAST(new_deaths AS INT)) AS TotalDeathes,  SUM(CAST(new_deaths AS INT))/sum(new_cases) * 100 as Deathsper
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2



SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(Int,vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.Location, dea.date) AS RollingpeopleVac
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3

With PeopvsVac (continent, location, date, population, new_vaccinations, RollingpeopleVac)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(Int,vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.Location, dea.date) AS RollingpeopleVac
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
)
SELECT * , (RollingpeopleVac/population) * 100
FROM PeopvsVac