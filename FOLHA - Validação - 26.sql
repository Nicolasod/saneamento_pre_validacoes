-- VALIDAÇÃO 26
-- Verifica se existe variáveis lançadas com data inicial ou final maior que a data de rescisão

select left(tab.data_afastamento,8) || '01' as nova_data_final,
	     tab.dt_inicial,
	     tab.data_afastamento,
	     tab.dt_final,
	     *
  from (select a.i_entidades,
  			       a.i_funcionarios,
  			       coalesce(ta.classif, 1) as classif,
  			       max(a.dt_afastamento) as data_afastamento,
  			       f.conselheiro_tutelar,
  			       v.i_eventos,
  			       v.i_processamentos,
  			       v.i_tipos_proc,
  			       v.dt_inicial,
  			       v.dt_final 
          from bethadba.afastamentos a
          join bethadba.tipos_afast ta
            on (ta.i_tipos_afast = a.i_tipos_afast)
          join bethadba.funcionarios f
            on (f.i_entidades = a.i_entidades
           and f.i_funcionarios = a.i_funcionarios)
          left join bethadba.variaveis v
            on (v.i_entidades = a.i_entidades
           and v.i_funcionarios = a.i_funcionarios)
         where ta.classif in (8)
           and a.dt_afastamento  <= today()
           and isnull(a.dt_ultimo_dia,today()) >= today()
           and v.i_eventos is not null
           and f.conselheiro_tutelar = 'N'
         group by a.i_entidades, a.i_funcionarios, ta.classif, f.conselheiro_tutelar, v.i_eventos, v.i_processamentos, v.i_tipos_proc , v.dt_inicial , v.dt_final 
         order by a.i_entidades, a.i_funcionarios,  v.dt_inicial , v.dt_final ) as tab
 where tab.dt_inicial > tab.data_afastamento
    or tab.dt_final > tab.data_afastamento;


-- CORREÇÃO
-- Atualiza as variáveis com data inicial ou final maior que a data de rescisão, definindo a data final como o primeiro dia do mês da data de afastamento

begin 
    declare w_i_funcionarios integer;
    declare w_dt_inicial date;
    declare w_dt_afastamento date;
    declare w_conta integer;
    declare w_evento integer;

set w_conta = 0;
	llloop: for ll as meuloop1 dynamic scroll cursor for
		select *, 
           left(aux.data_afastamento,8) || '01' as nova_data_final
      from (select a.i_entidades,
        		  	   a.i_funcionarios,
        			     coalesce(ta.classif,1) as classif,
        			     max(a.dt_afastamento) as data_afastamento,
        			     f.conselheiro_tutelar,
        			     v.i_eventos,
        			     v.i_processamentos,
        			     v.i_tipos_proc,
        			     v.dt_inicial,
        			     v.dt_final 
            	from bethadba.afastamentos a
            	join bethadba.tipos_afast ta
            	  on (ta.i_tipos_afast = a.i_tipos_afast)
            	join bethadba.funcionarios f
                on (f.i_entidades = a.i_entidades
            	 and f.i_funcionarios = a.i_funcionarios)
            	left join bethadba.variaveis v
            	  on (v.i_entidades = a.i_entidades
            	 and v.i_funcionarios = a.i_funcionarios)
             where ta.classif in (8)
               and a.dt_afastamento  <= today()
               and isnull(a.dt_ultimo_dia,today()) >= today()
               and v.i_eventos is not null
               and f.conselheiro_tutelar = 'N'
             group by a.i_entidades, a.i_funcionarios, ta.classif, f.conselheiro_tutelar, v.i_eventos, v.i_processamentos, v.i_tipos_proc , v.dt_inicial , v.dt_final 
             order by a.i_entidades, a.i_funcionarios,  v.dt_inicial , v.dt_final )aux
     where aux.dt_inicial > aux.data_afastamento
        or aux.dt_final > aux.data_afastamento
  do
		set w_conta = w_conta +1;
		set w_dt_inicial = dt_inicial;
		set w_dt_afastamento = data_afastamento;
		set w_i_funcionarios = i_funcionarios;
		set w_evento = i_eventos;

		update bethadba.variaveis a 
		   set a.dt_final = convert(varchar,(year(data_afastamento)||'-'||month(data_afastamento)||'-'||'01'),120) 
		 where a.dt_inicial = w_dt_inicial
		   and a.i_funcionarios = w_i_funcionarios
		   and a.i_eventos = w_evento;

		delete from bethadba.variaveis
		 where dt_inicial = w_dt_inicial
		   and i_funcionarios = w_i_funcionarios
		   and i_eventos = w_evento;

	end for;
end;