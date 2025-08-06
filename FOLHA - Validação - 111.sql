-- VALIDAÇÃO 111
-- Verifica ferias concomitantes do mesmo funcionario

select a.i_funcionarios,
       a.dt_gozo_ini ,
       a.dt_gozo_fin
  from bethadba.ferias a 
  join bethadba.ferias b
    on a.i_entidades = b.i_entidades
   and a.i_funcionarios = b.i_funcionarios 
 where (a.dt_gozo_ini between b.dt_gozo_ini and b.dt_gozo_fin or a.dt_gozo_fin between b.dt_gozo_ini and b.dt_gozo_fin)
   and (a.dt_gozo_ini <> b.dt_gozo_ini or a.dt_gozo_fin <> b.dt_gozo_fin);


-- CORREÇÃO
-- Atualiza as datas de gozo das férias para evitar sobreposição, ajustando a data inicial ou final conforme necessário

update bethadba.ferias a
   set a.dt_gozo_ini = case when a.dt_gozo_ini between b.dt_gozo_ini and b.dt_gozo_fin then
                            DATEADD(day, 1, b.dt_gozo_fin)
                       else
                            a.dt_gozo_ini
                       end,
       a.dt_gozo_fin = case when a.dt_gozo_fin between b.dt_gozo_ini and b.dt_gozo_fin then
                            DATEADD(day, -1, b.dt_gozo_ini)
                       else
                            a.dt_gozo_fin 
                       end
  from bethadba.ferias b
 where a.i_funcionarios = b.i_funcionarios 
   and (a.dt_gozo_ini between b.dt_gozo_ini and b.dt_gozo_fin or a.dt_gozo_fin between b.dt_gozo_ini and b.dt_gozo_fin)
   and (a.dt_gozo_ini <> b.dt_gozo_ini or a.dt_gozo_fin <> b.dt_gozo_fin);