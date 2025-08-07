-- VALIDAÇÃO 175
-- Lançamentos manuais com registros de ferias

select pf.i_entidades,
       pf.i_funcionarios,
       pf.i_periodos,
       pf.i_periodos_ferias,
       pf.i_ferias,
       pf.manual
  from bethadba.periodos_ferias as pf
  join bethadba.ferias as f
    on pf.i_entidades = f.i_entidades
   and pf.i_funcionarios = f.i_funcionarios
   and pf.i_periodos = f.i_periodos
   and pf.i_ferias = f.i_ferias
 where pf.manual = 'S'
   and pf.i_ferias is not null
   and pf.tipo <> 1;


-- CORREÇÃO
-- Atualiza lançamentos manuais para não manual

update periodos_ferias as pf
   set pf.manual = 'N'
  from bethadba.ferias as f
 where pf.i_entidades = f.i_entidades
   and pf.i_funcionarios = f.i_funcionarios
   and pf.i_periodos = f.i_periodos
   and pf.i_ferias = f.i_ferias
   and pf.manual = 'S'
   and pf.i_ferias is not null
   and pf.tipo <> 1;