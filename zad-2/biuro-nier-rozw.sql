/* 1 */
DECLARE @SQL AS VarChar(MAX)
SET @SQL = ''

SELECT @SQL = @SQL + 'SELECT * FROM ' + TABLE_SCHEMA + '.[' + TABLE_NAME + ']' + CHAR(13)
FROM INFORMATION_SCHEMA.TABLES

EXEC (@SQL)
GO

/* 2 */

select n.nieruchomoscnr, 
(select count(*) from biuro.dbo.wizyty w where w.nieruchomoscNr = n.nieruchomoscnr) ile_wizyt,
(select count(*) from biuro.dbo.wynajecia w where w.nieruchomoscNr = n.nieruchomoscnr) ile_wynajmów from biuro.dbo.nieruchomosci n;

GO
/* 3 */

select n.nieruchomoscnr,
convert(varchar(10), round((cast(n.czynsz * 100 as float) / cast((Select TOP 1 w.czynsz from biuro.dbo.wynajecia w where w.nieruchomoscNr = n.nieruchomoscnr order By w.od_kiedy asc) as float)) - 100, 2)) + '%' as division
from biuro.dbo.nieruchomosci n 
GO
/* 4 */

select n.nieruchomoscnr, sum(w.czynsz * (DATEDIFF(month, w.od_kiedy, w.do_kiedy) + 1 )) as ile from biuro.dbo.nieruchomosci n, biuro.dbo.wynajecia w
where w.nieruchomoscNr = n.nieruchomoscnr
group by n.nieruchomoscnr
GO
/* 5 */

select n.biuroNr, cast(sum(w.czynsz * (DATEDIFF(month, w.od_kiedy, w.do_kiedy) + 1 )) as float) * 0.3 ile from  biuro.dbo.wynajecia w, biuro.dbo.nieruchomosci n
where (n.nieruchomoscnr = w.nieruchomoscNr) group by n.biuroNr
GO
/* 6 */

/* a */

select n.miasto, count(n.miasto) ilosc_wynajem from biuro.dbo.nieruchomosci n, biuro.dbo.wynajecia w
where (n.nieruchomoscnr = w.nieruchomoscNr)
group by n.miasto 
order by ilosc_wynajem desc
GO
/* b */
select n.miasto, sum((DATEDIFF(DAY, w.od_kiedy, w.do_kiedy))) ilosc_dni from biuro.dbo.nieruchomosci n, biuro.dbo.wynajecia w
where (n.nieruchomoscnr = w.nieruchomoscNr)
group by n.miasto 
order by ilosc_dni desc
GO
/* 7 */

select distinct wiz.klientnr, wiz.nieruchomoscnr from biuro.dbo.wynajecia w, biuro.dbo.wizyty wiz
where (w.klientnr = wiz.klientnr)  and (w.nieruchomoscNr = wiz.nieruchomoscnr)
GO
/* 8 */

select  wiz.klientnr, count(wiz.nieruchomoscnr) from biuro.dbo.wizyty wiz where
datediff(day, wiz.data_wizyty, (select min(w2.od_kiedy) from biuro.dbo.wynajecia w2 where (wiz.klientnr = w2.klientnr))) > 0
group by wiz.klientnr

GO
/* drugie 8*/

select distinct k.klientnr from biuro.dbo.klienci k, biuro.dbo.wynajecia w
where (k.klientnr = w.klientnr) and (w.czynsz > k.max_czynsz)
GO
/* 9 */

select distinct b.biuroNr from biuro.dbo.biura b, biuro.dbo.nieruchomosci n
where b.biuroNr not in (select n2.biuroNr from biuro.dbo.nieruchomosci n2)
GO
/* 11 */

/* a */

select count(case when p.plec = 'k' then 1 end) kobiety, count(case when p.plec = 'm' then 1 end) mezczyzni from biuro.dbo.personel p
GO

/* b */

select b.biuroNr, count(case when p.plec = 'k' then 1 end) kobiety, count(case when p.plec = 'm' then 1 end) mezczyzni from biuro.dbo.personel p, biuro.dbo.biura b
where b.biuroNr = p.biuroNr
group by b.biuroNr
GO

/* c */

select b.miasto, count(case when p.plec = 'k' then 1 end) kobiety, count(case when p.plec = 'm' then 1 end) mezczyzni from biuro.dbo.personel p, biuro.dbo.biura b
where b.biuroNr = p.biuroNr
group by b.miasto
GO

/* d */

select p.stanowisko, count(case when p.plec = 'k' then 1 end) kobiety, count(case when p.plec = 'm' then 1 end) mezczyzni from biuro.dbo.personel p
group by p.stanowisko
GO