/*
 -- VALIDA��O 127
 * Configura��o Rais sem controle de ponto
 */

select rc.campo from bethadba.rais_campos rc
where exists (select 1 from bethadba.rais_eventos re where re.campo = rc.campo)
and rc.cnpj is null

/*
 -- CORRE��O
 */

update bethadba.bethadba.rais_campos
set CNPJ = 0
where CNPJ is null 
   
