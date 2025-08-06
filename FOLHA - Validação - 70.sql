-- VALIDAÇÃO 70
-- retorna os funcionários que possuem férias com data de fim do gozo igual ou após a data da rescisão.

select ferias.i_entidades,
       ferias.i_funcionarios,
       ferias.dt_gozo_fin, 
       rescisoes.dt_rescisao
  from bethadba.ferias, 
       bethadba.rescisoes
 where ferias.i_entidades = rescisoes.i_entidades
   and ferias.i_funcionarios = rescisoes.i_funcionarios
   and ferias.dt_gozo_fin >= rescisoes.dt_rescisao
   and rescisoes.dt_canc_resc is null;


-- CORREÇÃO
-- Atualiza a data de fim do gozo das férias para um dia antes da data de rescisão para os funcionários que possuem férias com data de fim do gozo igual ou após a data da rescisão.

update bethadba.ferias, bethadba.rescisoes
   set ferias.dt_gozo_fin = (rescisoes.dt_rescisao - 1)
 where ferias.i_entidades = rescisoes.i_entidades
   and ferias.i_funcionarios = rescisoes.i_funcionarios
   and ferias.dt_gozo_fin >= rescisoes.dt_rescisao
   and rescisoes.dt_canc_resc is null;