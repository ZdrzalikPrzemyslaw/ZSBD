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
select * from test_pracownicy..dziennik
