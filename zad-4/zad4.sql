/* 1 */
BEGIN
	print 'Czesc, to ja'
END
GO

/* 2 */
BEGIN
	DECLARE @integer int;
	SET @integer = 10
	print 'zmienna = ' + CAST(@integer as VARCHAR)
END
GO

/* 3 */
BEGIN
	DECLARE @integer int;
	SET @integer = 10
	if @integer < 10
		print 'zmienna mniejsza od 10'
	else 
		print 'zmienna wieksza lub równa 10'
END
GO

/* 4 */
BEGIN
	declare @i int = 1;

	while @i < 5
	BEGIN
		print 'zmienna ma wartosc ' + cast(@i as varchar)
		SET @i = @i + 1;
	end
end
go

/* 5 */

BEGIN
	declare @i int = 3;

	while @i <= 7
	BEGIN
		if @i = 3
			print 'poczatek ' + cast(@i as varchar)
		else if @i = 5
			print 'srodek ' + cast(@i as varchar)
		else if @i = 7
			print 'koniec ' + cast(@i as varchar)
		else 
			print @i
		SET @i = @i + 1;
	end
end
go

/* 6 */

if exists(select 1 from master.dbo.sysdatabases where name = 'testowa') drop database testowa
go
create database testowa
go
create table testowa..oddzialy (
	NR_ODD int primary key identity(1,1),
	NAZWA_ODD varchar(30))
go

insert into testowa..oddzialy (NAZWA_ODD) values ('oddzial pierwszy')
go
insert into testowa..oddzialy (NAZWA_ODD) values ('oddzial drugi')
go
insert into testowa..oddzialy (NAZWA_ODD) values ('oddzial trzeci')
go

/* 7 */


declare @id int = 1
begin
	declare @name varchar(30) = (select NAZWA_ODD from testowa..oddzialy where @id = NR_ODD)
	print 'nazwa oddzialu to ' + @name
end

/* 8 */