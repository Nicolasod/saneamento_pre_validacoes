-- VALIDAÇÃO 122
-- Configuração Rais sem controle de ponto

select i_entidades,
       i_parametros_rel
  from bethadba.parametros_rel
 where sistema_ponto is null
   and i_parametros_rel = 2;


-- CORREÇÃO
-- Configuração Rais sem controle de ponto

update bethadba.parametros_rel
   set sistema_ponto = 0
 where sistema_ponto is null
   and i_parametros_rel = 2;