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


///prenos



insert into kovine.kupci
select *
from nekovine.kupci 
where nekovine.kupci.sif_kupca not in (select sif_kupca from kovine.kupci);


insert into kovine.stranke (sif_str,	naziv,	naslov,	posta,	kraj,	telefon,	telefax,	kont_os,	del_cas,	sif_os,	kol_os,	pon,	tor,	sre,	cet,	pet,	sob,	ned,	opomba,	sif_kupca,	cena,	najem,	cena_naj,	veljavnost,	x_koord,	y_koord,	radij,	vtez,	obracun_km,	stev_km_norm,	stev_ur_norm,	zacetek,	uporabnik,	arso_odp_loc_id)
select sif_str,	naziv,	naslov,	posta,	kraj,	telefon,	telefax,	kont_os,	del_cas,	sif_os,	kol_os,	pon,	tor,	sre,	cet,	pet,	sob,	ned,	opomba,	sif_kupca,	cena,	najem,	cena_naj,	veljavnost,	x_koord,	y_koord,	radij,	vtez,	obracun_km,	stev_km_norm,	stev_ur_norm,	zacetek,	uporabnik,	arso_odp_loc_id
from nekovine.stranke 
where nekovine.stranke.sif_str not in (select sif_str from kovine.stranke);

insert into kovine.skup
select *
from nekovine.skup 
where nekovine.skup.skupina not in (select skupina from kovine.skup);


insert into kovine.enote
select *
from nekovine.enote 
where nekovine.enote.sif_enote not in (select sif_enote from kovine.enote);

insert into kovine.materiali (koda,material,pc_nizka,str_dv,sit_sort,sit_zaup,sit_smet,ravnanje1,ravnanje2,ravnanje3,ravnanje4,ravnanje5,ravnanje6,ravnanje7,ravnanje8,ravnanje9,prevoz1,	prevoz2,prevoz3,	prevoz4,	veljavnost,	zacetek,	uporabnik,	arso_odp_locpr_id)
select koda,material,pc_nizka,str_dv,sit_sort,sit_zaup,sit_smet,ravnanje1,ravnanje2,ravnanje3,ravnanje4,ravnanje5,ravnanje6,ravnanje7,ravnanje8,ravnanje9,prevoz1,	prevoz2,prevoz3,	prevoz4,	veljavnost,	zacetek,	uporabnik,	arso_odp_locpr_id
from nekovine.materiali 
where nekovine.materiali.koda not in (select koda from kovine.materiali);


insert into kovine.okolje
select *
from nekovine.okolje 
where nekovine.okolje.koda not in (select koda from kovine.okolje);


insert into kovine.material_okolje (material_koda, okolje_koda)
select material_koda, okolje_koda
from nekovine.material_okolje 
where nekovine.material_okolje.material_koda not in (select material_koda from kovine.material_okolje);



insert into kovine.osnovna
select *
from nekovine.osnovna 
where nekovine.osnovna.sif_os not in (select sif_os from kovine.osnovna);


insert into kovine.cenastr (sif_kupca, material_koda, cena, veljavnost, zacetek, uporabnik)
select sif_kupca, material_koda, cena, veljavnost, zacetek, uporabnik
from nekovine.cenastr 
where nekovine.cenastr.sif_kupca not in (select sif_kupca from kovine.cenastr);



insert into kovine.uporabniki
select *
from nekovine.uporabniki 
where nekovine.uporabniki.sif_upor not in (select sif_upor from kovine.uporabniki);
