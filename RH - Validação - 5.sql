-- VALIDAÇÃO 5
-- Periodo Aquisitivo Licenca premio - A data inicial não pode ser superior a data final

select i_entidades,
       i_funcionarios,
       i_licencas_premio,
       i_licencas_premio_per,
       dt_inicial,
       dt_final 
  from bethadba.licencas_premio_per as lpp
 where dt_inicial > dt_final
 order by i_entidades, i_funcionarios, i_licencas_premio, i_licencas_premio_per, dt_inicial, dt_final asc;


-- CORREÇÃO
-- Periodo Aquisitivo Licenca premio - A data inicial não pode ser superior a data final

update bethadba.licencas_premio_per as lpp
   set dt_inicial = dt_final
 where dt_inicial > dt_final;