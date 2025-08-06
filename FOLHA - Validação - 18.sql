-- VALIDAÇÃO 18
-- Verifica os CBO's nulos nos cargos

select i_entidades,
       i_cargos,
       i_cbo,
       i_tipos_cargos,
       nome
  from bethadba.cargos
 where i_cbo is null;


-- CORREÇÃO
-- Atualiza os CBO's nulos para um valor padrão (exemplo: 312320) para evitar problemas de integridade referencial

update bethadba.cargos
   set i_cbo = 312320 
 where i_cargos = 9999;