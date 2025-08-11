-- VALIDAÇÃO 26
-- Verifica se existe variáveis lançadas com data inicial ou final maior que a data de rescisão

select left(tab.data_afastamento, 8) || '01' as nova_data_final,
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
         where ta.classif = 8
           and a.dt_afastamento <= today()
           and isnull(a.dt_ultimo_dia, today()) >= today()
           and v.i_eventos is not null
           and f.conselheiro_tutelar = 'N'
         group by a.i_entidades, a.i_funcionarios, ta.classif, f.conselheiro_tutelar, v.i_eventos, v.i_processamentos, v.i_tipos_proc , v.dt_inicial , v.dt_final 
         order by a.i_entidades, a.i_funcionarios,  v.dt_inicial , v.dt_final ) as tab
 where tab.dt_inicial > tab.data_afastamento
    or tab.dt_final > tab.data_afastamento;


-- CORREÇÃO
-- Atualiza as variáveis com data inicial ou final maior que a data de rescisão, definindo a data incial ou final como o primeiro dia do mês da data de rescisão

update bethadba.variaveis v
   set v.dt_inicial = left(tab.data_afastamento, 8) || '01',
       v.dt_final = left(tab.data_afastamento, 8) || '01'
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
         where ta.classif = 8
           and a.dt_afastamento <= today()
           and isnull(a.dt_ultimo_dia,today()) >= today()
           and v.i_eventos is not null
           and f.conselheiro_tutelar = 'N'
         group by a.i_entidades, a.i_funcionarios, ta.classif, f.conselheiro_tutelar, v.i_eventos, v.i_processamentos, v.i_tipos_proc , v.dt_inicial , v.dt_final 
         order by a.i_entidades, a.i_funcionarios,  v.dt_inicial , v.dt_final ) as tab
 where tab.dt_inicial > tab.data_afastamento
    or tab.dt_final > tab.data_afastamento;