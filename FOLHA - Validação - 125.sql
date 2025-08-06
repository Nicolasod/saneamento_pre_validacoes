-- VALIDAÇÃO 125
-- Configuração Rais sem responsável

select i_entidades,
       i_parametros_rel
  from bethadba.parametros_rel
 where i_parametros_rel = 2
   and nome_resp is null;


-- CORREÇÃO
-- Atualiza o responsável para a configuração Rais caso não tenha responsável cadastrado

update bethadba.parametros_rel
   set nome_resp = 'RAIS'
 where i_parametros_rel = 2
   and nome_resp is null;