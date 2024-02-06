select *
from PortfolioProject..CovidDeaths
order by 3,4

--select *
--from PortfolioProject..CovidVaccinations
--order by 3,4

--selct Data that we are going to be using
select Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

--Loooking at Toal cases vs Total Deaths

select Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like'%states%'
where continent is not null
order by 1,2

select Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like'%Asia%'
where continent is not null
order by 1,2

--Looking at Total cases vs Population

sc

--Looking at Countries with highest infection rate compared to Population

select Location, Population, Max(total_cases) as HighestInfectionCount, Max((total_cases/Population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
--where location like'%states%'
where continent is not null
Group by Location, Population
order by PercentPopulationInfected desc

--Showing Countries with Highest Death Count per Population

select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like'%states%'
where continent is not null
Group by Location
order by TotalDeathCount desc

--LET'S BREAK THINGS DOWN BY CONTINENT
select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like'%states%'
where continent is not  null
Group by continent
order by TotalDeathCount desc


--showing the continent with highest death count per population

select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like'%states%'
where continent is not  null
Group by continent
order by TotalDeathCount desc

--GLOBAL NUMBERS

select date, SUM(new_cases)as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
--where location like'%states%'
where continent is not null
Group by date
order by 1,2

select  SUM(new_cases)as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
--where location like'%states%'
where continent is not null
--Group by date
order by 1,2

--Looking at Total Population vs Vaccinations

select dea.continent,dea.location, dea.date, dea.population,vac.new_vaccinations,
 SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location) AS RollingPeopleVaccinated
 --,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join  PortfolioProject..CovidVaccinations vac
     on dea.location= vac.location
     and dea.date = vac.date
where dea.continent is not null
order by 2,3


--USE CTE

with popvsVac (Continent, Location, Date,Population, New_vaccinations,RollingPeopleVaccinated)
as
(
select dea.continent,dea.location, dea.date, dea.population,vac.new_vaccinations,
 SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location) AS RollingPeopleVaccinated
 --,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join  PortfolioProject..CovidVaccinations vac
     on dea.location= vac.location
     and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select * ,(RollingPeopleVaccinated/population)*100
from popvsVac

--TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
create Table #PercentPopulationVaccinated
 (
 Continent nvarchar (255),
 Location nvarchar(255),
 Date datetime,
 Population numeric,
 RollingPeopleVaccinated numeric
 )
Insert into #PercentPopulationVaccinated


select dea.continent,dea.location, dea.date, dea.population,vac.new_vaccinations,
 SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location) AS RollingPeopleVaccinated
 --,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join  PortfolioProject..CovidVaccinations vac
     on dea.location= vac.location
     and dea.date = vac.date
--where dea.continent is not null
--order by 2,3
select * ,(RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated

--CREATING VIEW TO STORE DATA FOR LATER VISUALIZATIONS

Create View PercentPopulationVaccinated as
select dea.continent,dea.location, dea.date, dea.population,vac.new_vaccinations,
 SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location) AS RollingPeopleVaccinated
 --,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join  PortfolioProject..CovidVaccinations vac
     on dea.location= vac.location
     and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *
From PercentPopulationVaccinated