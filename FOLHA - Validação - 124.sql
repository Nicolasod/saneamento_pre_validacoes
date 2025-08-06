-- VALIDAÇÃO 124
-- Configuração Rais sem controle de ponto

select i_entidades,
       i_parametros_rel
  from bethadba.parametros_rel
 where i_parametros_rel = 2
   and mes_base is null;


-- CORREÇÃO
-- Atualiza o mês base para outubro de 2023 para o parâmetro de controle de ponto sem controle de ponto que não possui mês base definido.

update bethadba.parametros_rel
   set mes_base = '2023-10-01'
 where i_parametros_rel = 2
   and mes_base is null;