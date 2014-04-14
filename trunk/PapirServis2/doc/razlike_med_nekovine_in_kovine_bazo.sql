select 'KUPCI' 
union all
select  kovine.kupci.sif_kupca
from kovine.kupci inner join nekovine.kupci on (kovine.kupci.sif_kupca = nekovine.kupci.sif_kupca)
union all
select '' 
union all
select 'STRANKE' 
union all
select  kovine.stranke.sif_str
from kovine.stranke inner join nekovine.stranke on (kovine.stranke.sif_str = nekovine.stranke.sif_str)
union all
select '' 
union all
select 'STRANKE' 
union all
select  kovine.skup.skupina
from kovine.skup inner join nekovine.skup on (kovine.skup.skupina = nekovine.skup.skupina)
union all
select '' 
union all
select 'ENOTE' 
union all
select  kovine.enote.sif_enote
from kovine.enote inner join nekovine.enote on (kovine.enote.sif_enote = nekovine.enote.sif_enote)
union all
select '' 
union all
select 'MATERIALI' 
union all
select distinct kovine.materiali.koda
from kovine.materiali inner join nekovine.materiali on (kovine.materiali.koda = nekovine.materiali.koda)
union all
select '' 
union all
select 'STRANKE' 
union all
select distinct kovine.okolje.koda
from kovine.okolje inner join nekovine.okolje on (kovine.okolje.koda = nekovine.okolje.koda)
union all
select '' 
union all
select 'OSNOVNA' 
union all
select distinct kovine.osnovna.sif_os
from kovine.osnovna inner join nekovine.osnovna on (kovine.osnovna.sif_os = nekovine.osnovna.sif_os)
union all
select '' 
union all
select 'CENA STRANKE' 
union all
select distinct kovine.cenastr.sif_kupca
from kovine.cenastr inner join nekovine.cenastr on (kovine.cenastr.sif_kupca = nekovine.cenastr.sif_kupca and kovine.cenastr.material_koda = nekovine.cenastr.material_koda);