
-- Covid Death Data
Select *
From CovidDataExploration..CovidDeaths
Order by 3,4

-- Covid Vaccination Data
Select *
From CovidDataExploration..CovidVaccinations
Order by 3,4


-- Quick look at data
Select location, date, total_cases, new_cases, total_deaths, population
From CovidDataExploration..CovidDeaths
Order by 1,2

-- Alter data types to floats for mathematical operation
Alter table CovidDeaths alter column total_cases float
Alter table CovidDeaths alter column total_deaths float


-- Query Tables that will be used for Data Visualization in Tableau Project
-- 1 - Summary of Cases and Deaths
Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as 'death_percentage'
From CovidDataExploration..CovidDeaths
Where continent is not null
Order By 1,2

-- 2 - Total Death by Continent
Select location, SUM(new_deaths) as 'total_death_count'
From CovidDataExploration..CovidDeaths
Where continent is null and location not in ('World', 'European Union', 'International')
Group By location
Order By total_death_count desc

-- 3 - Percent Population Infected by Country
Select location, population, MAX(total_cases) as 'max_people_infected', MAX(total_cases/population)*100 as 'percent_population_infected'
From CovidDataExploration..CovidDeaths
Group By location, population
Order By percent_population_infected desc

-- 4 - Percent Population Infected by Country with Date
Select location, population, date, MAX(total_cases) as 'max_people_infected', MAX(total_cases/population)*100 as 'percent_population_infected'
From CovidDataExploration..CovidDeaths
Group By location, population, date
Order By percent_population_infected desc

-- 5 - Deaths with Hospitalized and ICU Patients
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as 'percent_death_per_case', icu_patients, hosp_patients
From CovidDataExploration..CovidDeaths
Where location like '%states%'
Order by 1,2

-- 6 - Cases and Deaths with Vaccinations
Select dea.location, dea.date, new_cases, total_cases, total_deaths, vac.new_vaccinations, vac.people_fully_vaccinated
From CovidDataExploration..CovidDeaths dea
join CovidDataExploration..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.location like '%states%'
Order by 1,2


-- Looking at Total Population vs Vaccinations

-- Joining deaths and vaccinations by location and date.
-- Uses CTE PopvsVac
With PopvsVac (continent, location, date, population, new_vaccinations, TotalPeopleVaxxed)
As 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(Cast(vac.new_vaccinations as int)) Over (Partition by dea.location Order by dea.location, dea.date)
	As TotalPeopleVaxxed
From CovidDataExploration..CovidDeaths dea
Join CovidDataExploration..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3
)
Select *, (TotalPeopleVaxxed/population)*100
From PopvsVac


-- Uses TEMP table PercentPopulationVaxxed
DROP Table if exists #PercentPopulationVaxxed
Create Table #PercentPopulationVaxxed
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
TotalPeopleVaxxed numeric
)

Insert into #PercentPopulationVaxxed
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(Cast(vac.new_vaccinations as int)) Over (Partition by dea.location Order by dea.location, dea.date)
	As TotalPeopleVaxxed
From CovidDataExploration..CovidDeaths dea
Join CovidDataExploration..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3
Select *, (TotalPeopleVaxxed/population)*100
From #PercentPopulationVaxxed



-- CREATE VIEW to store data for later visualizations
Create  View PercentPopulationVaxxed as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(Cast(vac.new_vaccinations as int)) Over (Partition by dea.location Order by dea.location, dea.date)
	As TotalPeopleVaxxed
From CovidDataExploration..CovidDeaths dea
Join CovidDataExploration..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null

Select *
From PercentPopulationVaxxed