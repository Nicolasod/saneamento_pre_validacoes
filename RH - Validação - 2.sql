-- VALIDAÇÃO 2
-- Cadastro de distância - O total de KM não pode estar nulo

select i_distancias,
	     total_km
  from bethadba.distancias
 where total_km is null;


-- CORREÇÃO
-- Atualizando o total de KM para 999 onde está nulo

update bethadba.distancias
   set total_km = 999
 where total_km is null;