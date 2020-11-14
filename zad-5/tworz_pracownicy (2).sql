
if exists(select 1 from master.dbo.sysdatabases where name = 'test_pracownicy') drop database test_pracownicy
GO
CREATE DATABASE test_pracownicy
GO
CREATE TABLE test_pracownicy.dbo.dzialy (
id_dzialu	int, 
nazwa	VARCHAR(15), 
siedziba VARCHAR(15),
CONSTRAINT dzialy_primary_key PRIMARY KEY (id_dzialu)
);
GO
CREATE TABLE test_pracownicy.dbo.taryfikator (
kategoria	int, 
od int, 
do int
 );
GO
CREATE TABLE test_pracownicy.dbo.stanowiska (
stanowisko	VARCHAR(18),
placa_min money, 
placa_max	money, 
CONSTRAINT stan_primary_key PRIMARY KEY (stanowisko)
);
GO
CREATE TABLE test_pracownicy.dbo.pracownicy (
nr_akt int, 
nazwisko	VARCHAR(20), 
stanowisko VARCHAR(18),
kierownik int CONSTRAINT prac_self_key REFERENCES pracownicy (nr_akt), 
data_zatr	DATETIME, 
data_zwol	DATETIME, 
placa MONEY, 
dod_funkcyjny MONEY, 
prowizja MONEY, 
id_dzialu	INT,
CONSTRAINT prac_primary_key PRIMARY KEY (nr_akt), 
CONSTRAINT prac_foreign_key FOREIGN KEY (id_dzialu) REFERENCES dzialy (id_dzialu)
);
GO
CREATE TABLE test_pracownicy.dbo.prac_archiw (
nr_akt INT, 
nazwisko VARCHAR(20), 
stanowisko VARCHAR(18),
kierownik INT, 
data_zatr DATETIME, 
data_zwol DATETIME, 
placa MONEY, 
dod_funkcyjny MONEY DEFAULT 0, 
prowizja MONEY DEFAULT 0, 
id_dzialu	INT
 );
GO