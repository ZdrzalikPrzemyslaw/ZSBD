/* Przemys³aw Zdrzalik 224466 */

/* 1 */
Select * from  narciarze.dbo.zawodnicy;
Select * from  narciarze.dbo.uczestnictwa_w_zawodach;
select * from  narciarze.dbo.zawody;
select * from  narciarze.dbo.skocznie;
select * from  narciarze.dbo.kraje;
select * from  narciarze.dbo.trenerzy;
GO

/* 2 */
select * from narciarze.dbo.kraje k
where k.id_kraju not in(
Select distinct id_kraju from narciarze.dbo.zawodnicy);
GO

/* 3 */
select k.kraj, count(*) as liczba from narciarze.dbo.zawodnicy z, narciarze.dbo.kraje k 
where k.id_kraju = z.id_kraju 
group by k.kraj;
GO

/* 4 */
Select zawodnicy.nazwisko from narciarze.dbo.zawodnicy zawodnicy
where zawodnicy.id_skoczka not in (select z.id_skoczka from narciarze.dbo.uczestnictwa_w_zawodach z)
GO

/* 5 */
select z.nazwisko, COUNT(*) ile from narciarze.dbo.zawodnicy z, narciarze.dbo.uczestnictwa_w_zawodach u
where (z.id_skoczka = u.id_skoczka) 
group by z.nazwisko
GO

/* 6 */
select z.nazwisko, s.nazwa from narciarze.dbo.zawodnicy z, narciarze.dbo.skocznie s, narciarze.dbo.uczestnictwa_w_zawodach u, narciarze.dbo.zawody zawody
where (z.id_skoczka = u.id_skoczka) and (u.id_zawodow = zawody.id_zawodow) and (zawody.id_skoczni = s.id_skoczni)
group by z.nazwisko, s.nazwa
GO

/* 7 */
select z.nazwisko, datediff(year, z.data_ur, getdate()) as wiek from narciarze.dbo.zawodnicy z
order by wiek desc;
GO

/* 8 */
select z.nazwisko, min(DATEDIFF(year, z.data_ur, zawody.DATA))  as wiek 
from narciarze.dbo.zawodnicy z, narciarze.dbo.uczestnictwa_w_zawodach u, narciarze.dbo.zawody zawody
where (z.id_skoczka = u.id_skoczka) and (u.id_zawodow = zawody.id_zawodow) 
group by z.nazwisko
order by wiek desc;
GO

/* 9 */
select s.nazwa, (s.sedz - s.k) distance from narciarze.dbo.skocznie s
order by distance desc
GO

/* 10 */
select  top 1 s.nazwa, (s.sedz - s.k) as distance from narciarze.dbo.skocznie s, narciarze.dbo.zawody z
where (z.id_skoczni = s.id_skoczni)
order by distance desc
GO

/* 11 */
select distinct k.kraj from narciarze.dbo.kraje k, narciarze.dbo.zawody z, narciarze.dbo.skocznie s
where (s.id_kraju = k.id_kraju) and (s.id_skoczni = z.id_skoczni)
GO

/* 12 */
select z.nazwisko, k.kraj, count(*) c 
from narciarze.dbo.zawodnicy z, narciarze.dbo.kraje k, narciarze.dbo.uczestnictwa_w_zawodach u, narciarze.dbo.zawody zawody, narciarze.dbo.skocznie s
where (z.id_skoczka = u.id_skoczka) and (z.id_kraju = k.id_kraju) and (u.id_zawodow = zawody.id_zawodow) and (s.id_kraju = z.id_kraju) and (s.id_skoczni = zawody.id_skoczni)
group by z.nazwisko, k.kraj
order by z.nazwisko
GO

/* 13 */
INSERT INTO narciarze.dbo.trenerzy(imie_t, nazwisko_t, data_ur_t, id_kraju) VALUES ('Corby', 'Fisher', '1975-07-20', 7);
GO

/* 14 */
alter table narciarze.dbo.zawodnicy 
add trener int default null;
GO

/* 15 */
 update narciarze.dbo.zawodnicy
 set narciarze.dbo.zawodnicy.trener = (select top 1 t.id_trenera from narciarze.dbo.trenerzy t where (zawodnicy.id_kraju = t.id_kraju) order by newid())
 GO
 /*
 select z.nazwisko, z.trener, t.nazwisko_t ,k1.kraj, k2.kraj from narciarze.dbo.zawodnicy z, narciarze.dbo.trenerzy t, narciarze.dbo.kraje k1, narciarze.dbo.kraje k2
 where (z.id_kraju = k1.id_kraju) and (z.trener = t.id_trenera) and (t.id_kraju = k2.id_kraju) group by k1.kraj, k2.kraj, t.nazwisko_t, z.trener, z.nazwisko */
 
/* 16 */
alter table narciarze.dbo.zawodnicy
add constraint fk_trener FOREIGN KEY (trener) references narciarze.dbo.trenerzy(id_trenera)
GO

/* 17 */
update narciarze.dbo.trenerzy 
set narciarze.dbo.trenerzy.data_ur_t = (select top 1 DATEADD(YEAR, -5, z.data_ur) wiek from narciarze.dbo.zawodnicy z 
	where (z.trener = id_trenera)
	order by wiek desc)
	where data_ur_t is null;
GO