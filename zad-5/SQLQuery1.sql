/* 1 */

IF OBJECT_ID('test_pracownicy.dbo.dziennik', 'U') IS NOT NULL 
  DROP TABLE test_pracownicy.dbo.dziennik;
GO

create table test_pracownicy.dbo.dziennik (
tabela varchar(15),
data DATE,
l_wierszy int,
komunikat varchar(300))
GO

/* 2 */

begin
	declare @premia MONEY = 300;
	update test_pracownicy.dbo.pracownicy
	set placa = placa + @premia
	where exists(select 1 from test_pracownicy.dbo.pracownicy p2 where p2.kierownik = test_pracownicy.dbo.pracownicy.nr_akt)

	insert into test_pracownicy..dziennik (tabela, data, l_wierszy, komunikat) values 
	('pracownicy', GETDATE(), @@ROWCOUNT, 'Wprowadzono dodatek funkcyjny w wysokoœci ' + cast(@premia as varchar))
end
go

/* 3 */

declare @rok int = 1989;
declare @liczba int;
begin
	select @liczba =  count(*) from test_pracownicy..pracownicy p where year(p.data_zatr) = @rok
	insert into test_pracownicy..dziennik (tabela, data, l_wierszy, komunikat) values 
	('pracownicy', GETDATE(), @liczba, 'Zatrudniono ' + cast(@liczba as varchar) + ' pracowników w roku ' + cast(@rok as varchar))
end
go

/* 4 */

declare @id int = 8902;
declare @dlugosc int;
begin
	select @dlugosc = datediff(year, p.data_zatr, getdate()) from test_pracownicy..pracownicy p where p.nr_akt = @id
	if @dlugosc >= 15
		begin
			insert into test_pracownicy..dziennik (tabela, data, l_wierszy, komunikat) values 
			('pracownicy', GETDATE(), 1, 'Pracownik ' + cast(@id as varchar) + ' jest zatrudniony dluzej niz 15 lat')
		end
	else
		begin
			insert into test_pracownicy..dziennik (tabela, data, l_wierszy, komunikat) values 
			('pracownicy', GETDATE(), 1, 'Pracownik ' + cast(@id as varchar) + ' jest zatrudniony krócej niz 15 lat')
		end

end
go

/* 5 */
DROP PROCEDURE IF EXISTS PIERWSZA;
GO
CREATE PROCEDURE PIERWSZA
@first varchar(50)
AS
print('Wartosc parametru wynosila: ' + @first)
RETURN
GO

Begin
	exec PIERWSZA 'XD'
END
GO

/* 6 */
DROP PROCEDURE IF EXISTS DRUGA;
GO
CREATE PROCEDURE DRUGA
@first varchar(50) = null,
@second varchar(100) = 'DRUGA',
@third int = 1
AS
	declare @zmiennaznakowa varchar(100) = 'DRUGA'
RETURN @second
GO

/* 7 */

DROP PROCEDURE IF EXISTS TRZECIA;
GO
CREATE PROCEDURE TRZECIA
@id int = 1,
@procent int = 10
as
begin
	if @id = 0
	begin
		update test_pracownicy..pracownicy
		set placa = placa * (((@procent) / 100.0) + 1 )
	end
	else
	begin
		update test_pracownicy..pracownicy
		set placa = placa * (((@procent) / 100.0) + 1 )
		where id_dzialu  = @id
	end
	begin 
		insert into test_pracownicy..dziennik (tabela, data, l_wierszy, komunikat) values 
		('pracownicy', GETDATE(), @@ROWCOUNT, 'PODWYZSZONO PLACE O ' + cast(@procent as varchar) + ' PROCENT')
	end
end
GO