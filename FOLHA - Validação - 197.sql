-- VALIDAÇÃO 197
-- Lacuna entre períodos aquisitivos de férias

select periodos.i_entidades as Entidade, 
       periodos.i_funcionarios as Funcionario, 
       periodos.i_periodos as Periodo, 
       periodos.dt_aquis_ini as DataInicioPeriodo, 
       periodos.dt_aquis_fin as DataFimPeriodo,
       if datacancelado is not null then datacancelado else periodos.dt_aquis_fin endif as DataFimPeriodoCloud,
       (select dt_periodo
          from bethadba.periodos_ferias pf
         where pf.i_entidades = periodos.i_entidades
           and pf.i_funcionarios = periodos.i_funcionarios
           and pf.i_periodos = periodos.i_periodos
           and pf.tipo = 5) as DataCancelado
  from bethadba.periodos,
       bethadba.funcionarios
 where periodos.i_entidades = funcionarios.i_entidades
   and periodos.i_funcionarios = funcionarios.i_funcionarios
   and not exists (select 1
   					         from bethadba.rescisoes
                    where rescisoes.i_entidades = funcionarios.i_entidades
                      and rescisoes.i_funcionarios = funcionarios.i_funcionarios)
   and exists(select 1
                from bethadba.periodos p
               where p.i_entidades = funcionarios.i_entidades
                 and p.i_funcionarios = funcionarios.i_funcionarios
                 and p.dt_aquis_fin < periodos.dt_aquis_ini)
   and not exists(select p1.i_entidades,
                         p1.i_funcionarios,
                         p1.i_periodos,
                         p1.dt_aquis_ini as DataInicioPeriodo2,
                         if datacancelado1 is not null then datacancelado1 else p1.dt_aquis_fin endif as DataFimPeriodo2,
                         (select dt_periodo
                            from bethadba.periodos_ferias pf
                           where pf.i_entidades = p1.i_entidades
                             and pf.i_funcionarios = p1.i_funcionarios
                             and pf.i_periodos = p1.i_periodos
                             and pf.tipo = 5) as datacancelado1
		                from bethadba.periodos p1,
		                     bethadba.funcionarios f1
		               where p1.i_entidades = f1.i_entidades
                     and p1.i_funcionarios = f1.i_funcionarios
			               and p1.i_entidades = periodos.i_entidades
            			   and p1.i_funcionarios = periodos.i_funcionarios
                     and datafimperiodo2 = dateadd(day, -1, periodos.dt_aquis_ini))
 order by periodos.i_entidades, periodos.i_funcionarios, periodos.i_periodos;


-- CORREÇÃO
-- Atualizar a data de fim do período aquisitivo de férias para o dia anterior ao início do próximo período aquisitivo de férias

update bethadba.periodos
   set dt_aquis_fin = dateadd(day, -1, p.dt_aquis_ini)
  from bethadba.funcionarios f
 where periodos.i_entidades = f.i_entidades
   and periodos.i_funcionarios = f.i_funcionarios
   and not exists (select 1
                    from bethadba.rescisoes r
                   where r.i_entidades = f.i_entidades
                     and r.i_funcionarios = f.i_funcionarios)
   and exists(select 1
                from bethadba.periodos p
               where p.i_entidades = f.i_entidades
                 and p.i_funcionarios = f.i_funcionarios
                 and p.dt_aquis_fin < periodos.dt_aquis_ini)
   and not exists(select p1.i_entidades,
                         p1.i_funcionarios,
                         p1.i_periodos,
                         p1.dt_aquis_ini as DataInicioPeriodo2,
                         if datacancelado1 is not null then datacancelado1 else p1.dt_aquis_fin endif as DataFimPeriodo2,
                         (select dt_periodo
                            from bethadba.periodos_ferias pf
                           where pf.i_entidades = p1.i_entidades
                             and pf.i_funcionarios = p1.i_funcionarios
                             and pf.i_periodos = p1.i_periodos
                             and pf.tipo = 5) as datacancelado1
                    from bethadba.periodos p1,
                         bethadba.funcionarios f1
                   where p1.i_entidades = f1.i_entidades
                     and p1.i_funcionarios = f1.i_funcionarios
                     and p1.i_entidades = periodos.i_entidades
            			   and p1.i_funcionarios = periodos.i_funcionarios
                     and datafimperiodo2 = dateadd(day, -1, periodos.dt_aquis_ini));