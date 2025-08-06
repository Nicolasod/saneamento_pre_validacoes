-- VALIDAÇÃO 123
-- Configuração Rais com tipo de inscrição inválida

select i_entidades,
       i_parametros_rel
  from bethadba.parametros_rel
 where i_parametros_rel = 2
   and (tipo_insc is null or tipo_insc = 'C');


-- CORREÇÃO
-- Atualiza o tipo de inscrição para 'F' (Pessoa Física) na configuração do RAIS

update bethadba.parametros_rel
   set tipo_insc = 'F'
 where i_parametros_rel = 2
   and (tipo_insc is null or tipo_insc = 'C');