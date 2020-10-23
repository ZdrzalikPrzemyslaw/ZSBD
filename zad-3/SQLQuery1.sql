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
