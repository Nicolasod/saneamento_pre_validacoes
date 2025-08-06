-- VALIDAÇÃO 80
-- Campo observação do motivo do cancelamento de férias com mais de 50 caracteres

select periodos_ferias.i_entidades entidade, 
       periodos_ferias.i_funcionarios func, 
       periodos_ferias.i_periodos periodo, 
       periodos_ferias.dt_periodo dt_per,
       periodos_ferias.observacao
  from bethadba.periodos_ferias 
 where periodos_ferias.tipo = 5
   and length(observacao) > 50;


-- CORREÇÃO
-- Atualiza o campo observação do motivo do cancelamento de férias para nulo (considerando que o campo observação é do tipo texto longo e não deve ter mais de 50 caracteres)

update bethadba.periodos_ferias
   set observacao = null
 where length(observacao) > 50;