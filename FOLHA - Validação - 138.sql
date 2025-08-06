-- VALIDAÇÃO 138
-- Calculo base outras empresas

select i_pessoas,
       dt_vigencia_ini,
       dt_vigencia_fin
  from bethadba.bases_calc_outras_empresas 
 where dt_vigencia_fin >= date(dateadd(year,100,GETDATE()));


-- CORREÇÃO
-- Atualiza a data de vigência final para 100 anos a partir da data atual para os registros que possuem data de vigência final maior ou igual a 100 anos a partir da data atual.
-- Isso garante que os registros estejam dentro de um intervalo de vigência válido.

update bethadba.bases_calc_outras_empresas
   set dt_vigencia_fin = date(dateadd(year,100,GETDATE()))
 where dt_vigencia_fin >= date(dateadd(year,100,GETDATE()));