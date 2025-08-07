-- VALIDAÇÃO 193
-- É necessario preencher o campo desenoração de folha.

select hpp.i_entidades,
       hpp.i_competencias,
       t.i_entidade_conv,
       t.i_tabelas,
       t.i_cpt_ini_conv,
       hpp.desoneracao_folha
  from bethadba.hist_parametros_previd as hpp,
       bethadba.conv_cloud_tabelas_encargos as t
 where t.i_entidades = hpp.i_entidades
   and t.i_cpt_ini_conv >= '2024-01'
   and hpp.desoneracao_folha is null
   and hpp.i_competencias = (select max(hpp2.i_competencias) 
                               from bethadba.hist_parametros_previd as hpp2 
                              where hpp2.i_entidades = hpp.i_entidades 
                                and hpp2.i_competencias <= t.i_cpt_ini_conv);


-- CORREÇÃO
-- Preenchendo o campo desoneração de folha com o valor 2

update bethadba.hist_parametros_previd as hpp
   set hpp.desoneracao_folha = 2
  from bethadba.conv_cloud_tabelas_encargos as t
 where t.i_entidades = hpp.i_entidades
   and t.i_cpt_ini_conv >= '2024-01'
   and hpp.desoneracao_folha is null
   and hpp.i_competencias = (select max(hpp2.i_competencias)
                               from bethadba.hist_parametros_previd as hpp2
                              where hpp2.i_entidades = hpp.i_entidades
                                and hpp2.i_competencias <= t.i_cpt_ini_conv);