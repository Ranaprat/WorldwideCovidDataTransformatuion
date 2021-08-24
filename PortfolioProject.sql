select * from PortfolioProject.dbo.CovidDeaths

--select count(*) from PortfolioProject.dbo.CovidDeaths

--select count(*), location from PortfolioProject.dbo.CovidDeaths group by location;
select * from PortfolioProject.dbo.CovidDeaths  order by 3,4
--select * from PortfolioProject.dbo.CovidVactinations  order by 3,4

select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject.dbo.CovidDeaths order by 1,2

--Looking for total cases vs total deaths

select sum(total_cases) as total,location 
from PortfolioProject.dbo.CovidDeaths group by location


--shows likelihood dying if you contract covid in your country 
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage 
from PortfolioProject.dbo.CovidDeaths where location like '%india%' order by 1,2

--Looking total cases vs population

select location,date,total_cases,population, (total_cases/population)*100 as InfetctedPopulation
from PortfolioProject.dbo.CovidDeaths --where location like '%india%' 
order by 1,2

--What country have the highest infection rate compare to population

select location,population,Max(total_cases) as cases , Max((total_cases/population)*100) as PercentInfetctedPopulation
from PortfolioProject.dbo.CovidDeaths --where location like '%india%' 
group by location,population
order by PercentInfetctedPopulation desc

--check in India, have the highest infection rate compare to population
select location,Max(total_cases) as cases , Max((total_cases/population)*100) as PercentInfetctedPopulation
from PortfolioProject.dbo.CovidDeaths 
group by location
having location='india'

--showing countries with highest death count per population
select location,Max(cast(total_deaths as int)) as deaths
From PortfolioProject.dbo.CovidDeaths
where continent is not  null
group by location
order by deaths desc



--showing continent with highest death counts

select continent,Max(cast(total_deaths as int)) as deaths
From PortfolioProject.dbo.CovidDeaths
where continent is not null
group by continent
order by deaths desc

--Global wise numbers

select sum(new_cases) as totalcase, sum(cast(new_deaths as int)) as totaldeaths,
sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
From PortfolioProject.dbo.CovidDeaths
where continent is not null
order by 1,2


select * from PortfolioProject.dbo.CovidVactinations  order by 1,2

select * from PortfolioProject.dbo.CovidDeaths

--Lets Join this two tables:
--total vactination vs total population
select * from PortfolioProject.dbo.CovidDeaths dea join PortfolioProject.dbo.CovidVactinations vac
on dea.location=vac.location and dea.date=vac.date

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations from PortfolioProject.dbo.CovidDeaths dea join PortfolioProject.dbo.CovidVactinations vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
and dea.date=vac.date order by 1,2,3

--Total vaccination location wise

select  dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations 
from PortfolioProject.dbo.CovidDeaths dea join PortfolioProject.dbo.CovidVactinations vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
and dea.date=vac.date order by 1,2,3



select  dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RolllingPeopleVaccinated
--(RolllingPeopleVaccinated/poulation)*100// this is as error and that is why we are creatting CTE
from PortfolioProject.dbo.CovidDeaths dea join PortfolioProject.dbo.CovidVactinations vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
and dea.date=vac.date order by 1,2,3

--by using CTE, it will add extra column which is created by alias and allow you to calculate the same.

with PopVsVac ( continent,location,date,population,new_vaccinations,RolllingPeopleVaccinated)
as
(select  dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RolllingPeopleVaccinated
--(RolllingPeopleVaccinated/poulation)*100// this is as error and that is why we are creatting CTE
from PortfolioProject.dbo.CovidDeaths dea join PortfolioProject.dbo.CovidVactinations vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
and dea.date=vac.date )
select *,(RolllingPeopleVaccinated/population)*100 from PopVsVac


--By using temp table
create table PercentPopulationVacinated
(continent nvarchar(255),location nvarchar(255),date datetime,population numeric,new_vaccinations numeric,RolllingPeopleVaccinated numeric)

insert into PercentPopulationVacinated
select  dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RolllingPeopleVaccinated
--(RolllingPeopleVaccinated/poulation)*100// this is as error and that is why we are creatting CTE
from PortfolioProject.dbo.CovidDeaths dea join PortfolioProject.dbo.CovidVactinations vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
and dea.date=vac.date 

select * from PercentPopulationVacinated

select max(RolllingPeopleVaccinated),location from PercentPopulationVacinated group by location

--Creating view to store data for later visualization

create view PercentagePopulationVacinated as select  dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RolllingPeopleVaccinated
--(RolllingPeopleVaccinated/poulation)*100// this is as error and that is why we are creatting CTE
from PortfolioProject.dbo.CovidDeaths dea join PortfolioProject.dbo.CovidVactinations vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null

select * from dbo.PercentagePopulationVacinated




















--
































on 















