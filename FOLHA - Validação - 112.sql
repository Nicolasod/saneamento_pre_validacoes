-- VALIDAÇÃO 112
-- Verifica os afastamentos concomitantes com ferias do funcionário

select a.i_funcionarios,
       a.dt_afastamento,
       a.dt_ultimo_dia,
       b.dt_gozo_ini,
       b.dt_gozo_fin
  from bethadba.afastamentos a 
  join bethadba.ferias b
    on a.i_funcionarios = b.i_funcionarios 
 where a.dt_afastamento between b.dt_gozo_ini and b.dt_gozo_fin;


-- CORREÇÃO
-- Atualiza a data inicial do afastamento para o dia seguinte ao término das férias para os funcionários que possuem afastamentos concomitantes com férias
                
update bethadba.afastamentos as a
   set a.dt_afastamento = DATEADD(dd, 1, b.dt_gozo_fin)
  from bethadba.ferias as b
 where a.dt_afastamento between b.dt_gozo_ini and b.dt_gozo_fin
   and a.i_funcionarios = b.i_funcionarios
   and not exists (select 1
			               from bethadba.afastamentos as a2
      		          where a2.i_funcionarios = a.i_funcionarios
			                and a2.dt_afastamento = DATEADD(dd, 1, b.dt_gozo_fin));