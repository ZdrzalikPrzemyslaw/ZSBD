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
	NR_ODD int primary key,
	NAZWA_ODD varchar(30))
go

insert into testowa..oddzialy (NR_ODD, NAZWA_ODD) values (1, 'oddzial pierwszy')
go
insert into testowa..oddzialy (NR_ODD, NAZWA_ODD) values (2, 'oddzial drugi')
go
insert into testowa..oddzialy (NR_ODD, NAZWA_ODD) values (3, 'oddzial trzeci')
go
insert into testowa..oddzialy (NR_ODD, NAZWA_ODD) values (4, 'oddzial czwarty')
go
insert into testowa..oddzialy (NR_ODD, NAZWA_ODD) values (5, 'oddzial piaty')
go

/* 7 */


declare @id int = 1
begin
	declare @name varchar(30) = (select NAZWA_ODD from testowa..oddzialy where @id = NR_ODD)
	print 'nazwa oddzialu to ' + @name
end
go

/* 8 */

declare kursor cursor for (select * from testowa..oddzialy)
declare @id int, @name varchar(30)
open kursor
fetch next from kursor into @id, @name
while @@FETCH_STATUS = 0
	begin
		print 'NUMER ODDZIALU TO: ' + cast(@id as varchar) + ', NAZWA ODDZIALU TO: ' + @name
		fetch next from kursor into @id, @name
	end
close kursor
deallocate kursor
go

/* 9 */

declare kursor cursor for (select nr_odd from testowa..oddzialy where NR_ODD > 2) for update
declare @count int = 0
declare @id int
open kursor
fetch next from kursor into @id
while @@FETCH_STATUS = 0
	begin
		delete from testowa..oddzialy where current of kursor
		set @count = @count + 1
		fetch next from kursor into @id
	end
if @count > 0
	print 'LICZBA USUNIETYCH REKORDOW: ' + cast(@count as varchar)
close kursor
deallocate kursor
go


/* 10 */

declare kursor cursor for (select nr_odd from testowa..oddzialy where NR_ODD = 3) for update
declare @id int
open kursor
fetch next from kursor into @id
begin
if @@FETCH_STATUS = 0
	begin
		update testowa..oddzialy
		set NAZWA_ODD = 'nowa nazwa XD'
		where current of kursor
		fetch next from kursor into @id
	end
else
	begin 
		insert into testowa..oddzialy (NR_ODD ,NAZWA_ODD) values (3, 'oddzial trzeci inny')
	end
end
close kursor
deallocate kursor

select * from testowa..oddzialy
go