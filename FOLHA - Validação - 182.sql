-- VALIDAÇÃO 182
-- Data final da vigência de bases anteriores de outras empresas equivocada. (Causa Travamento do Arqjob)

select i_pessoas,
       i_empresas,
       dt_vigencia_ini,
       dt_vigencia_fin
  from bethadba.bases_calc_outras_empresas 
 where dt_vigencia_fin > '2100-01-01';


-- CORREÇÃO
-- Atualiza a data final da vigência para 2100-01-01 onde estiver maior que essa data e não for nula

update bethadba.bases_calc_outras_empresas
   set dt_vigencia_fin = '2099-12-31'
 where dt_vigencia_fin > '2100-01-01';