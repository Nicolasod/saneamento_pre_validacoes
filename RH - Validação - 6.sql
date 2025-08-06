-- VALIDAÇÃO 6
-- Periodo Aquisitivo Licenca premio - A quantidade de dias de direito deve ser informada

select i_entidades,
       i_funcionarios,
       i_licencas_premio
  from bethadba.licencas_premio  
 where num_dias_licenca is null
    or num_dias_licenca < 0
 order by i_entidades, i_funcionarios, i_licencas_premio asc;


-- CORREÇÃO
-- A quantidade de dias de direito deve ser informada

update bethadba.licencas_premio
   set num_dias_licenca = 0
 where num_dias_licenca is null
    or num_dias_licenca < 0;