-- VALIDAÇÃO 183
-- Concessão com tag manual como S porém com lançamento de ferias

select pf.i_entidades,
       pf.i_funcionarios,
       pf.i_periodos,
       pf.manual,
       pf.i_ferias
  from bethadba.periodos_ferias pf
 where pf.tipo <> 1
   and pf.manual = 'S'
   and pf.i_ferias is not null;


-- CORREÇÃO
-- Atualizar a coluna manual para 'N' onde o tipo é diferente de 1 e i_ferias não é nulo

update bethadba.periodos_ferias pf
   set pf.manual = 'N'
 where pf.tipo <> 1
   and pf.manual = 'S'
   and pf.i_ferias is not null;