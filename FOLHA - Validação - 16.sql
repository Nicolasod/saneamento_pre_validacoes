-- VALIDAÇÃO 16
-- Verifica os atos com número nulos

select i_atos
  from bethadba.atos 
 where num_ato is null
    or num_ato = '';


-- CORREÇÃO
-- Atualiza os atos com número nulo para o i_atos como número do ato

update bethadba.atos 
   set num_ato = i_atos 
 where num_ato is null
    or num_ato = '';