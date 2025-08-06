-- VALIDAÇÃO 49
-- Verifica o motivo nos afastamentos se contém no máximo 150 caracteres

select length(observacao) as tamanho_observacao, 
       i_entidades, 
       i_funcionarios, 
       dt_afastamento 
  from bethadba.afastamentos 
 where length(observacao) > 150;


-- CORREÇÃO
-- Atualiza a observação do afastamento para conter no máximo 150 caracteres

update bethadba.afastamentos
   set observacao = SUBSTR(observacao, 1, 150)
 where length(observacao) > 150;