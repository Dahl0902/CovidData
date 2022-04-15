-- Tableau Visualization Link 
-- https://public.tableau.com/app/profile/brennan5088/viz/Covid_Data_16469436719600/Dashboard1

SELECT *
FROM coviddeaths cd
JOIN covidvaccinations cv
ON cd.location = cv.location AND cd.date = cv.date;

--Vaccination percentage vs Death percentage
SELECT cd.location, cd.population, MAX(cd.total_deaths) AS total_deaths, (MAX(cd.total_deaths)/cd.population)*100 AS death_percentage,
	MAX(cv.people_fully_vaccinated) as people_fully_vaccinated, (MAX(cv.people_fully_vaccinated)/cd.population)*100 AS percent_vaccinated
FROM coviddeaths cd
JOIN covidvaccinations cv
ON cd.location = cv.location AND cd.date = cv.date
WHERE cd.continent IS NOT NULL AND  people_fully_vaccinated IS NOT NULL AND total_deaths IS NOT NULL
GROUP BY cd.location, cd.population
ORDER BY percent_vaccinated DESC;

--United States performance
SELECT cd.location, cd.population, MAX(cd.total_deaths) AS total_deaths, (MAX(cd.total_deaths)/cd.population)*100 AS death_percentage,
	MAX(cv.people_fully_vaccinated) as people_fully_vaccinated, (MAX(cv.people_fully_vaccinated)/cd.population)*100 AS percent_vaccinated
FROM coviddeaths cd
JOIN covidvaccinations cv
ON cd.location = cv.location AND cd.date = cv.date
WHERE cd.location LIKE 'United States'
GROUP BY cd.location, cd.population
ORDER BY percent_vaccinated DESC;

--Death Rate vs Vaccinations in the United States
WITH CTE AS (
SELECT cd.location, cd.date, cd.population, cd.new_deaths, cd.total_deaths, (cd.new_deaths/cd.population)*100 AS new_deaths_percentage, cv.people_fully_vaccinated
FROM coviddeaths cd
JOIN covidvaccinations cv
ON cd.location = cv.location AND cd.date = cv.date
WHERE cd.date >= '12/14/2020'
)
SELECT *, (total_deaths/population)*100 AS death_percentage, (people_fully_vaccinated/population)*100 AS percent_vaccinated
FROM CTE
WHERE people_fully_vaccinated IS NOT NULL AND location LIKE 'United States'
GROUP BY location, date, new_deaths, people_fully_vaccinated, population, total_deaths, people_fully_vaccinated, new_deaths_percentage
ORDER BY new_deaths
LIMIT 50;


