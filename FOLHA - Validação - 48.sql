-- VALIDAÇÃO 48
-- Data de admissão da matricula maior que a data de inicio da matricula na lotação fisica

select f.dt_admissao,
       lm.i_funcionarios,
       lm.dt_inicial,
       lm.i_entidades,
       lm.i_locais_trab,
       lm.dt_final 
  from bethadba.funcionarios as f
 inner join bethadba.locais_mov as lm
    on (f.i_funcionarios = lm.i_funcionarios
   and f.i_entidades = lm.i_entidades)
 where f.dt_admissao > lm.dt_inicial;


-- CORREÇÃO
-- Atualiza a data inicial da lotação física para a data de admissão do funcionário onde a data de admissão é maior que a data inicial da lotação física

update bethadba.locais_mov
   set lm.dt_inicial = f.dt_admissao
  from bethadba.locais_mov as lm
 inner join bethadba.funcionarios as f
    on (lm.i_funcionarios = f.i_funcionarios
   and f.i_entidades = lm.i_entidades)
 where f.dt_admissao > lm.dt_inicial;