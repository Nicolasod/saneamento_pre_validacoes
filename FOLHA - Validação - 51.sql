-- VALIDAÇÃO 51
-- Verifica as rescisões de aposentadoria com motivo nulo

select i_entidades,
       i_funcionarios,
       i_rescisoes 
  from bethadba.rescisoes 
 where i_motivos_resc = 7
   and i_motivos_apos is null;

-- CORREÇÃO
-- Atualiza o motivo de aposentadoria para 1 (aposentadoria por tempo de serviço) onde o motivo de rescisão é 7 (aposentadoria) e o motivo de aposentadoria é nulo
-- Isso garante que todas as rescisões de aposentadoria tenham um motivo definido

update bethadba.rescisoes 
   set i_motivos_apos = 1
 where i_motivos_resc = 7
   and i_motivos_apos is null;