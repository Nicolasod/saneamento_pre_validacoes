-- VALIDAÇÃO 9
-- Configuração adicional da matricula - A data inicial da configuração não pode ser anterior a data de admissão

select af.i_entidades,
       af.i_funcionarios,
       af.i_adicionais,
       af.dt_inicial,
       f.dt_admissao
  from bethadba.adic_funcs as af
  join bethadba.funcionarios as f
    on af.i_entidades = f.i_entidades
   and af.i_funcionarios = f.i_funcionarios
 where af.dt_inicial < f.dt_admissao;


-- CORREÇÃO
-- Atualiza a data inicial da configuração adicional da matrícula para a data de admissão do funcionário

update bethadba.adic_funcs as af
  join bethadba.funcionarios as f
    on af.i_entidades = f.i_entidades
   and af.i_funcionarios = f.i_funcionarios
   set af.dt_inicial = f.dt_admissao
 where af.dt_inicial < f.dt_admissao;