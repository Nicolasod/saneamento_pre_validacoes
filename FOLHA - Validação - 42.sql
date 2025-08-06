-- VALIDAÇÃO 42
-- Verifica o término de vigência maior que 2099 na tabela bethadba.bases_calc_outras_empresas

select i_pessoas
  from bethadba.bases_calc_outras_empresas
 where dt_vigencia_fin > '2099-01-01';


-- CORREÇÃO
-- Atualiza a data de término de vigência para 2099-01-01 onde a data de término de vigência é maior que 2099-01-01

update bethadba.bases_calc_outras_empresas
   set dt_vigencia_fin = '2099-01-01'
 where i_pessoas in (select i_pessoas
                       from bethadba.bases_calc_outras_empresas
                      where dt_vigencia_fin > '2099-01-01')
   and dt_vigencia_fin >'2099-01-01';