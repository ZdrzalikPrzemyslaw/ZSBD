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

CREATE PROCEDURE PIERWSZA
AS
sql_statement
GO;