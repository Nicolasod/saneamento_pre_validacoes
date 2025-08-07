-- VALIDAÇÃO 180
-- Cargos com classificação comissionado ou não classificado com configuração de ferias

select c.i_entidades,
       c.nome,
       c.i_tipos_cargos,
       cc.i_config_ferias,
       tc.classif 
  from bethadba.cargos as c
  join bethadba.tipos_cargos as tc
    on c.i_tipos_cargos = tc.i_tipos_cargos
  join bethadba.cargos_compl as cc
    on c.i_entidades = cc.i_entidades
   and c.i_cargos = cc.i_cargos
 where tc.classif in (0, 2)
   and cc.i_config_ferias is not null;


-- CORREÇÃO
-- Remove a configuração de férias dos cargos com classificação comissionado ou não classificado

update bethadba.cargos_compl cc
   set i_config_ferias = null
  from bethadba.cargos c
  join bethadba.tipos_cargos tc
    on c.i_tipos_cargos = tc.i_tipos_cargos
 where c.i_entidades = cc.i_entidades
   and c.i_cargos = cc.i_cargos
   and tc.classif in (0, 2)
   and cc.i_config_ferias is not null;