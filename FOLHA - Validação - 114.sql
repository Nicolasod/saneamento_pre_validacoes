-- VALIDAÇÃO 114
-- Verifica as faltas concomitantes com as ferias do funcionario

select a.i_funcionarios,
       a.dt_inicial
  from bethadba.faltas a 
  join bethadba.ferias b
    on a.i_entidades = b.i_entidades
   and a.i_funcionarios = b.i_funcionarios
 where a.dt_inicial between b.dt_gozo_ini and b.dt_gozo_fin;


-- CORREÇÃO
-- Atualiza a data inicial da falta para o dia seguinte ao término das férias para os funcionários que possuem faltas concomitantes com férias

delete bethadba.faltas as a
  from bethadba.ferias as b
 where a.i_entidades = b.i_entidades
   and a.i_funcionarios = b.i_funcionarios
   and a.dt_inicial between b.dt_gozo_ini and b.dt_gozo_fin;