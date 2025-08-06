-- VALIDAÇÃO 15
-- Verifica os logradouros sem cidades

select i_ruas,
       nome
  from bethadba.ruas 
 where i_cidades is null;


-- CORREÇÃO
-- Atualiza os logradouros sem cidades para a cidade padrão (i_entidades = 1)
  
update bethadba.ruas
   set i_cidades = (select max(i_cidades)
                      from bethadba.entidades
                     where i_entidades = 1)
 where i_cidades is null;