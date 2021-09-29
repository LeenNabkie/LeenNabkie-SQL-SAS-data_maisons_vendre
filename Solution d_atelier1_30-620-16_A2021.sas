
*******************************************************************************************************************************;
*******************************************************************************************************************************;

*                                       Atelier 1                                                                              *;

*******************************************************************************************************************************;
*****************************************************************************************************;



*****************************************************************************************************;
*                                       Question 2													 ;
*****************************************************************************************************;

proc sql;
create table data_sub_jard0 as 
select numero_id,prix, date_poste, code_postal
from data_maisons_vendre
where  jardin=0;
quit;

*****************************************************************************************************;
*                                       Question 2													 ;
*****************************************************************************************************;
proc sql;
create table data_jard0_h1m_4b1_60_85 as 
select *
from data_sub_jard0
where (substr(code_postal,1,3)="H1M" or substr(code_postal,4,3)="4B1") 
and prix>=600000 and  prix<=850000 /* ou bien and prix between 60000 and 850000*/
order by prix;
quit;

*****************************************************************************************************;
*                                       Question 3													 ;
*****************************************************************************************************;
proc sql;
create table data_maisons_vendre_3P as 
select *,
case when 
(substr(numero_id,1,2) in ("tr","du") and prix<500000) or 
(substr(numero_id,1,2)="ma" and jardin=1 and substr(code_postal,1,3) in ("H2E","H3R","H3E") and prix<=450000) or 
(substr(numero_id,1,2)="ma" and prix <300000 and substr(code_postal,1,3) not in ("H3X","H2Z") and jardin=1)
then "OUI"
when 
(prix>650000) or 
(substr(code_postal,1,3)  in ("H1Y","H1P"))
then "NON"
else "NA" end as satisfaction

from data_maisons_vendre
where nbr_pieces>=3;
quit;

*****************************************************************************************************;
*                                       Question 4													 ;
*****************************************************************************************************;
proc sql;
create table Maison as
select 
		a.*,
		substr(a.code_postal,1,3) as FSA,
		b.prix as Prix_vendus,
		b.date_vendu
from 
		data_maisons_vendre as a
inner join
		data_maisons_vendus as b
on a.numero_id=b.numero_id;
quit;

*****************************************************************************************************;
*                                       Question 5													 ;
*****************************************************************************************************;
proc sql;
 select 
 		fSA,
		min(prix) as prix_minimal_vendre,
		AVG(prix) as prix_moyen_vendre,
		max(prix) as prix_maximal_vendre
from maison
where jardin=0
group by 
		fSA 
having 
		prix_moyen_vendre<600000;
quit;

*****************************************************************************************************;
*                                       Question 6													 ;
*****************************************************************************************************;
PROC SQL;
select 
		FSA,
		Max(prix_vendus) as Prix_vendus_Maximal
from
	maison
group by 
	FSA
having
	Prix_vendus_Maximal >= all (
								select Max(prix_vendus) as Prix_vendus_Maximal
								from maison
								group by FSA);
QUIT;


*****************************************************************************************************;
*                                       Question 7												 ;
*****************************************************************************************************;

PROC SQL number; 

select  
    FSA, 
    Max(prix_vendus) as Prix_vendus_Maximal 

from maison 

group by  FSA 

having Prix_vendus_Maximal >= all ( 
								select mean(prix_vendus) as Prix_vendus_moyenne 
								from maison); 

QUIT; 



*****************************************************************************************************;
*                                       Question 8												 ;
*****************************************************************************************************;

proc sql number; 

SELECT mois_vendu,count(numero_id) as vente_par_mois 
from (SELECT *,month(date_vendu)as mois_vendu 
      from maison) 
group by mois_vendu ; 

quit; 

