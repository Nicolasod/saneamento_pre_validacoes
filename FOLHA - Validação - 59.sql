-- VALIDAÇÃO 59
-- Busca os históricos de funcionários com mais do que uma previdência informada

select i_funcionarios,
       i_entidades,
       dt_alteracoes,
       length(REPLACE(prev_federal || prev_estadual || fundo_ass || fundo_prev, 'N', '')) as quantidade
  from bethadba.hist_funcionarios
 where quantidade > 1;


-- CORREÇÃO
-- Altera a previdência federal para 'Sim' e as demais para 'Não' quando o histórico da matrícula possuí mais de uma previdência marcada

update bethadba.hist_funcionarios
   set prev_federal = 'S',
       prev_estadual = 'N',
       fundo_ass = 'N',
       fundo_prev = 'N'
 where length(REPLACE(prev_federal || prev_estadual || fundo_ass || fundo_prev, 'N', '')) > 1;