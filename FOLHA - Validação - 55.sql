-- VALIDAÇÃO 55
-- Busca os atos com data inicial nulo

select i_atos, 
       dt_vigorar 
  from bethadba.atos 
 where dt_inicial is null;


-- CORREÇÃO
-- Atualiza a data inicial do ato para ser igual à data de vigorar se a data inicial for nula

update bethadba.atos 
   set dt_inicial = dt_vigorar 
 where dt_inicial is null;