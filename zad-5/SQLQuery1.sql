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

