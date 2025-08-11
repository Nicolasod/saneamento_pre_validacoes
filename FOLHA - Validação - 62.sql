-- VALIDAÇÃO 62
-- Cargos sem configuração de férias

select i_entidades,
	     i_cargos,
	     (select nome
	   	    from bethadba.cargos
	   	   where cargos.i_entidades = hist_cargos.i_entidades
 	   	     and cargos.i_cargos = hist_cargos.i_cargos) as nome
  from bethadba.hist_cargos
 where i_cargos in (select i_cargos
 	  				          from bethadba.cargos_compl
                     where cargos_compl.i_entidades = hist_cargos.i_entidades
                       and cargos_compl.i_config_ferias is null)
   and exists(select 1
   			 	      from bethadba.periodos
               where periodos.i_entidades = hist_cargos.i_entidades
                 and periodos.i_funcionarios = hist_cargos.i_funcionarios);


-- CORREÇÃO
-- Atualiza os cargos que não possuem configuração de férias

update bethadba.cargos_compl 
   set i_config_ferias = 1
 where i_config_ferias is null;