-- VALIDAÇÃO 50
-- Verifica a data inicial no afastamento se é maior que a data final

select i_entidades, 
       i_funcionarios, 
       i_ferias,
       dt_gozo_ini,
       dt_gozo_fin 
  from bethadba.ferias 
 where dt_gozo_ini > dt_gozo_fin;


-- CORREÇÃO
-- Atualiza a data final do gozo de férias para ser igual à data inicial mais o saldo de dias se a data inicial for maior que a data final

update bethadba.ferias
   set dt_gozo_fin = dateadd(day, saldo_dias, dt_gozo_ini)
 where dt_gozo_ini > dt_gozo_fin;