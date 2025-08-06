-- VALIDAÇÃO 140
-- Periodo aquisitivo de ferias concomitantes

select a.i_entidades,
       a.i_funcionarios,
       a.i_periodos,
       a.dt_aquis_ini as dataInicioA,
       a.dt_aquis_fin as dataFimA,
       b.dt_aquis_ini as dataInicioB,
       b.dt_aquis_fin as dataFimB,
       canceladoA = if exists (select 1
                                 from bethadba.periodos_ferias pf 
                                where a.i_entidades = pf.i_entidades
                                  and a.i_funcionarios = pf.i_funcionarios
                                  and a.i_periodos = pf.i_periodos
                                  and pf.tipo in (5,7)) then 'true' else 'false' endif,
       canceladoB = if exists (select 1
                                 from bethadba.periodos_ferias pf 
                                where b.i_entidades = pf.i_entidades
                                  and b.i_funcionarios = pf.i_funcionarios
                                  and b.i_periodos = pf.i_periodos
                                  and pf.tipo in (5,7)) then 'true' else 'false' endif,     
       diferencaPeriodo = b.i_periodos - a.i_periodos,
       diferenca = DATEDIFF(day, a.dt_aquis_fin , b.dt_aquis_ini) 
  from bethadba.periodos a 
  join bethadba.periodos b
    on a.i_entidades = b.i_entidades
   and a.i_funcionarios = b.i_funcionarios
 where a.i_periodos < b.i_periodos
   and diferencaPeriodo = 1
   and diferenca <> 1 
   and (canceladoA = 'false' and canceladoB = 'false')
 order by a.i_entidades, a.i_funcionarios, a.i_periodos, a.dt_aquis_ini;


-- CORREÇÃO
-- Ajuste da data de fim do periodo aquisitivo de ferias para o dia anterior ao inicio do proximo periodo aquisitivo

begin
  declare w_entidade integer;
  declare w_funcionario integer;
  declare w_periodo integer;
  declare w_new_data_aquis_fim timestamp;

  llloop: for ll as cursor1 dynamic scroll cursor for
	select a.i_entidades,
    	   a.i_funcionarios,
	       a.i_periodos,
    	   a.dt_aquis_ini as dataInicioA,
	       a.dt_aquis_fin as dataFimA,
    	   b.dt_aquis_ini as dataInicioB,
	       b.dt_aquis_fin as dataFimB,
    	   canceladoA = if exists (select 1
        	                         from bethadba.periodos_ferias as pf
            	                    where a.i_entidades = pf.i_entidades
                	                  and a.i_funcionarios = pf.i_funcionarios
                    	              and a.i_periodos = pf.i_periodos
                        	          and pf.tipo in (5,7)) then 'true' else 'false' endif,
	       canceladoB = if exists (select 1
    	                             from bethadba.periodos_ferias as pf
        	                        where b.i_entidades = pf.i_entidades
            	                      and b.i_funcionarios = pf.i_funcionarios
                	                  and b.i_periodos = pf.i_periodos
                    	              and pf.tipo in (5,7)) then 'true' else 'false' endif,
	       diferencaPeriodo = b.i_periodos - a.i_periodos,
    	   diferenca = DATEDIFF(day, a.dt_aquis_fin , b.dt_aquis_ini)
	  from bethadba.periodos as a,
	  	   bethadba.periodos as b
	 where a.i_periodos < b.i_periodos
	   and a.i_entidades = b.i_entidades
	   and a.i_funcionarios = b.i_funcionarios
	   and diferencaPeriodo = 1
	   and diferenca <> 1 
	   and (canceladoA = 'false' and canceladoB = 'false')
	 order by a.i_entidades, a.i_funcionarios, a.i_periodos, a.dt_aquis_ini
  
  do
  
	  set w_entidade = i_entidades;
    set w_funcionario = i_funcionarios;
    set w_periodo = i_periodos;
    set w_new_data_aquis_fim = DATEADD(DAY, -1, dataInicioB);

    update bethadba.periodos as p
       set p.dt_aquis_fin = w_new_data_aquis_fim
     where p.i_entidades = w_entidade
       and p.i_funcionarios = w_funcionario
       and p.i_periodos = w_periodo
  end for;
end;