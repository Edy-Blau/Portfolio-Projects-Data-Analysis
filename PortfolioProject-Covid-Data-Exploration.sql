--Project: Covid Exploratory Analysis
--Source: Data Analysis Bootcamp FCC (AlexTheAnalyst)
--Modified/Edited by: EdyBlau
--Date: 05/23/2024

--Select *
--From PortfolioProject..CovidVaccinations

--Select *
--From PortfolioProject..CovidVaccinations

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths

--Total cases vs Total deaths in Mexico
--Shows the likelihood of dying if infected with Covid
Select Location, date, total_cases, total_deaths, cast(total_deaths as float)/nullif(cast(total_cases as float),0)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where Location = 'Mexico'

--Total cases vs population in Mexico
--Shows what percentage of population got Covid
Select Location, date, total_cases, population, cast(total_deaths as float)/(population)*100 as InfectionPercentage
From PortfolioProject..CovidDeaths
Where Location = 'Mexico'

--Countries with the highest Infection Rate compared to Population
Select Location, Population, Max(total_cases) as HighestInfectionCount, Max(cast(total_cases as float)/(population)*100) as HighestInfectionPercentage
From PortfolioProject..CovidDeaths
Group by Location, Population
Order by HighestInfectionPercentage desc

--Countries with the Highest Death Count
Select Location, Max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent <> ''
Group by Location
Order by TotalDeathCount desc

--Continents with the Highest Death Count
Select
	Case
		When Continent in ('North America', 'South America') then 'America'
		else Continent
	End as continent_group,
	Max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent <> ''
Group by 
	Case
		When Continent in ('North America', 'South America') then 'America'
		else Continent
	End
Order by TotalDeathCount desc

--Global numbers
Select date, sum(cast(new_cases as float)) as total_cases, sum(cast(new_deaths as float)) as total_deaths,
	sum(cast(new_deaths as float))/nullif(sum(cast(new_cases as float)),0)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent <> '' and cast(new_cases as float) > 0
Group by date
Order by date

--Joining the two tables
Select *
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location and dea.date = vac.date
where dea.continent <> ''

--Population vs Vaccination: Global
Select dea.location, dea.date, dea.population, vac.new_vaccinations,
		sum(convert(bigint, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
		from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location and dea.date = vac.date
where dea.continent <> '' and vac.new_vaccinations <> 0
group by dea.location, dea.date, dea.population, vac.new_vaccinations
order by 1,2

--Population vs Vaccination: Mexico
Select dea.location, dea.date, dea.population, vac.new_vaccinations,
		sum(convert(bigint, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
		from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location and dea.date = vac.date
where dea.location = 'Mexico' and vac.new_vaccinations <> 0
group by dea.location, dea.date, dea.population, vac.new_vaccinations
order by 1,2


--Using a CTE: Population vs Vaccination: Global
With PopVsVac (Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.location, dea.date, dea.population, vac.new_vaccinations,
		sum(convert(bigint, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
		from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location and dea.date = vac.date
where dea.continent <> '' and vac.new_vaccinations <> 0
group by dea.location, dea.date, dea.population, vac.new_vaccinations
)

Select *
From PopVsVac


--Using a Temp Table: Population vs Vaccination: Global
Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Location nvarchar(255),
Date datetime,
Population bigint,
New_vaccinations bigint,
RollingPeopleVaccinated bigint
)

Insert into #PercentPopulationVaccinated
Select dea.location, dea.date, dea.population, vac.new_vaccinations,
		sum(convert(bigint, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
		from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location and dea.date = vac.date
where dea.continent <> '' and vac.new_vaccinations <> 0
group by dea.location, dea.date, dea.population, vac.new_vaccinations

Select *
From #PercentPopulationVaccinated

--Create View to store data for later visualization
Create View PercentPopulationVaccinated as
Select dea.location, dea.date, dea.population, vac.new_vaccinations,
		sum(convert(bigint, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
		from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location and dea.date = vac.date
where dea.continent <> '' and vac.new_vaccinations <> 0
group by dea.location, dea.date, dea.population, vac.new_vaccinations

Select *
From PercentPopulationVaccinated

