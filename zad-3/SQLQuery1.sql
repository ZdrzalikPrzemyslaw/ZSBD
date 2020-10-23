declare @x int, @s varchar(10)

set @x=10
set @s='napis'

print @x+2
print @s

GO

declare @imieP varchar(20), @nazwiskoP varchar(20)
select @imieP=imie, @nazwiskoP=nazwisko from biblioteka.dbo.pracownicy where id=7
print @imieP+' '+@nazwiskoP

GO

--- z którego wiersza zostan¹ przepisane dane? ---

declare @imieP varchar(20), @nazwiskoP varchar(20)
select @imieP=imie, @nazwiskoP=nazwisko from biblioteka.dbo.pracownicy
print @imieP+' '+@nazwiskoP

GO
/* z ostatniego */

---- co zostanie zwrócone? ----

----1. 

declare @imieP varchar(20), @nazwiskoP varchar(20)
set @imieP='Teofil'
set @nazwiskoP='Szczerbaty'
select @imieP=imie, @nazwiskoP=nazwisko from biblioteka.dbo.pracownicy where id=1
print @imieP+' '+@nazwiskoP
GO

/* Dane pracownika o id 1 */

----2

declare @imieP varchar(20), @nazwiskoP varchar(20)
set @imieP='Teofil'
set @nazwiskoP = 'Szczerbaty'
select @imieP=imie, @nazwiskoP=nazwisko from biblioteka.dbo.pracownicy where id=20
print @imieP+' '+@nazwiskoP
GO

/* dane zapisane w zmiennych poniewa¿ nie isniteje pracownik o id = 20 */

-- WAITFOR
create table biblioteka..liczby (licz1 int, czas datetime default getdate());
go
declare @x int
set @x=2
insert into biblioteka..liczby(licz1) values (@x);
waitfor delay '00:00:10'
insert into biblioteka..liczby(licz1) values (@x+2);
select * from biblioteka..liczby;
GO

--IF..ELSE
if EXISTS(select * from biblioteka..wypozyczenia) print('By³y wypo¿yczenia') else print ('Nie by³o wypo¿yczeñ')
GO

-- WHILE
declare @y int
set @y=0
while (@y<10)
begin
	print @y
	if(@y = 5) break
	set @y = @y + 1
end
Go

-- CASE
select tytul as tytulK, cena as cenaK, [cena jest]=CASE
	when cena<20.20 then 'Niska'
	when cena between 20.00 and 40.00 then 'Przystepna'
	when cena>40 then 'Wysoka'
	else 'Nieznana'
	end
from biblioteka..ksiazki
GO

-- NULLIF
-- przydatne, kiedy trzeba pomin¹æ jak¹œ wartoœæ w funkcjach agreguj¹cych
-- proszê stworzyæ w³asny
-- przyk³ad

/*
select
count(*) as [Liczba pracowników],
avg(nullif(zarobki, 0)) as [Œrednia p³aca],
min(nullif(zarobki, 0)) as [P³aca minimalna]
from test..pracownicy
*/

SELECT 
	avg(nullif(year(getdate()) - year(t.data_ur_T), 0)) AS [sredni wiek trenera],
	avg(nullif(year(getdate()) - year(z.data_ur), 0)) AS [sredni wiek zawodników]
FROM narciarze.dbo.trenerzy t, narciarze.dbo.zawodnicy z
GO

-- ISNULL
-- pozwala na nadawanie wartoœci domyœlnych tam, gdzie jest NULL
-- proszê stworzyæ w³asny przyk³ad

/*
select title, pub_id, isnull(price, (select MIN(price) from pubs..titles)) from pubs..titles
*/

select isnull(t.imie_t, 'Zepsuty Trener') imie, t.nazwisko_t, isnull(t.data_ur_t, '02-04-2005') data_ur_t  from narciarze.dbo.trenerzy t
GO

-- Komunikaty o b³êdzie --
RAISERROR (21000,10,1)
PRINT @@error
GO

RAISERROR (21000, 10,1) WITH SETERROR
PRINT @@error
GO

RAISERROR (21000, 11,1)
PRINT @@error
GO

RAISERROR ('Ala ma kota',11,1)
PRINT @@error
GO

DECLARE @d1 DATETIME, @d2 DATETIME
SET @d1 = '20091020'
SET @d2 = '20091025'

SELECT dateadd(HOUR, 112, @d1)
SELECT dateadd(DAY, 112, @d1)

SELECT datediff(MINUTE, @d1, @d2)
SELECT datediff(DAY, @d1, @d2)

SELECT datename(MONTH, @d1)
SELECT datepart(MONTH, @d1)

SELECT CAST(day(@d1) AS VARCHAR)
           + '-' + cast(month(@d1) AS VARCHAR)
           + '-' + cast(year(@d1) AS VARCHAR)
GO

select COL_LENGTH('biblioteka..pracownicy', 'imie')

select DATALENGTH(2+3.4)

select db_id('master')

select db_name(1)

select user_id()

select user_name()

select host_id()

select HOST_NAME()

use biblioteka;

select object_id('Pracownicy')

select object_name(object_id('Pracownicy'))

GO

-- 1. --
IF exists(SELECT 1
          FROM master.dbo.sysdatabases
          WHERE name = 'test_cwiczenia')
    DROP DATABASE test_cwiczenia
GO

CREATE DATABASE test_cwiczenia
GO

CREATE TABLE test_cwiczenia..liczby (
    liczba INT
)
GO

DECLARE @i INT
SET @i = 1
WHILE @i < 100
    BEGIN
        INSERT test_cwiczenia..liczby VALUES (@i)
        SET @i = @i + 1
    END

SELECT *
FROM test_cwiczenia..liczby;

GO

-- 2. --

use test_cwiczenia
go

if exists(select 1 from sys.objects where TYPE = 'P' and name = 'proc_liczby')
drop procedure proc_liczby
GO

create procedure proc_liczby @max int = 10
as 
begin
	select liczba from test_cwiczenia..liczby
	where liczba <=@max
end
go

exec test_cwiczenia..proc_liczby 3
exec test_cwiczenia..proc_liczby
go

--- Proszê zmodyfikowaæ przyk³ady - dostosowaæ do w³asnych baz !!! ---

use test_cwiczenia

GO
-- 1 -- 

if exists(select 1 from sys.objects where name = 'fn_srednia')
drop function fn_srednia
GO


create function fn_srednia(@rodzaj varchar(25)) returns float
begin
	return (select avg(w.czynsz) from biuro.dbo.wynajecia w where w.forma_platnosci=@rodzaj)
end
GO

select dbo.fn_srednia('gotówka')

GO

-- 2 --

if exists(select 1 from sys.objects where name = 'funkcja')
	drop function funkcja
GO

create function funkcja (@max int) returns table
return (select * from biuro.dbo.wynajecia where czynsz <= @max)
Go

select * from funkcja(400)
GO