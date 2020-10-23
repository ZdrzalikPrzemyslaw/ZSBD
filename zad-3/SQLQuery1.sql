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