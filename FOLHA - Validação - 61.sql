-- VALIDAÇÃO 61
-- Busca os dependentes sem motivo de término

select i_pessoas ,
       i_dependentes,
       dt_ini_depende
  from bethadba.dependentes d  
 where mot_fin_depende is null
   and dt_fin_depende is not null;


-- CORREÇÃO
-- Atualiza o motivo de término dos dependentes que não possuem motivo de término para 0 (sem motivo de término)

update bethadba.dependentes
   set mot_fin_depende = 0
 where mot_fin_depende is null
   and dt_fin_depende is not null;