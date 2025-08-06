-- VALIDAÇÃO 126
-- Configuração Rais com contato nulo

select i_entidades,
       i_parametros_rel
  from bethadba.parametros_rel
 where i_parametros_rel = 2
   and tipo_insc = 'J'
   and contato is null;


-- CORREÇÃO
-- Atualiza o contato para espaço em branco onde é nulo

update bethadba.parametros_rel
   set contato = 'CONTATO RAIS'
 where i_parametros_rel = 2
   and tipo_insc = 'J'
   and contato is null;