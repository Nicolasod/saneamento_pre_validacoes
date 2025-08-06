-- VALIDAÇÃO 129
-- A data a vigorar do ato não pode ser maior que a movimentação

select atos_func.i_funcionarios,
       atos.i_atos, atos_func.dt_movimento, dt_vigorar 
  from bethadba.atos_func
  left join bethadba.atos
    on atos_func.i_atos = atos.i_atos
 where atos.dt_vigorar > atos_func.dt_movimento;


-- CORREÇÃO
-- Atualiza a data a vigorar do ato para que não seja maior que a movimentação do ato.

update bethadba.atos_func as af
 inner join bethadba.atos as a
    on af.i_atos = a.i_atos
   set a.dt_vigorar = af.dt_movimento
 where a.dt_vigorar > af.dt_movimento;