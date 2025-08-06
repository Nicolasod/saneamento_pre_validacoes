-- VALIDAÇÃO 7
-- Periodo Aquisitivo Licenca premio - A data inicial ou final não pode estar nula

select i_entidades,
       i_funcionarios,
       i_licencas_premio,
       i_licencas_premio_per 
  from bethadba.licencas_premio_per as lpp
 where (dt_inicial is null or dt_final is null)
   and i_averbacoes is null
   and status = 'S'
   and observacao not like '%averb%'
 order by i_entidades, i_funcionarios, i_licencas_premio, i_licencas_premio_per asc;


-- CORREÇÃO
-- Atualiza as datas inicial e final para a data atual onde estiverem nulas e não houver averbação, status for 'S' e observação não contiver 'averb'

update bethadba.licencas_premio_per as lpp
   set dt_inicial = current_date,
       dt_final = current_date
 where (dt_inicial is null or dt_final is null)
   and i_averbacoes is null
   and status = 'S'
   and observacao not like '%averb%';