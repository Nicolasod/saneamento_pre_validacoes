-- VALIDAÇÃO 103
-- Verifica o pensionista com data menor que rescisão da matricula de origem com pensão por morte

select beneficiarios.i_funcionarios
  from bethadba.beneficiarios,
       bethadba.rescisoes,
       bethadba.funcionarios
 where beneficiarios.i_entidades = rescisoes.i_entidades 
   and beneficiarios.i_instituidor = rescisoes.i_funcionarios
   and beneficiarios.i_funcionarios = funcionarios.i_funcionarios 
   and beneficiarios.i_entidades = funcionarios.i_entidades
   and funcionarios.tipo_pens = 1
   and rescisoes.trab_dia_resc = 'S'
   and funcionarios.dt_admissao <= rescisoes.dt_rescisao;


-- CORREÇÃO
-- Atualiza a data de admissão do funcionário para o dia seguinte da rescisão
-- Isso garante que a data de admissão não seja anterior à data de rescisão

update bethadba.funcionarios
   set funcionarios.dt_admissao = dateadd(day, 1, rescisoes.dt_rescisao)
  from bethadba.beneficiarios , bethadba.rescisoes , bethadba.funcionarios 
 where beneficiarios.i_entidades = rescisoes.i_entidades
   and beneficiarios.i_instituidor = rescisoes.i_funcionarios
   and beneficiarios.i_funcionarios = funcionarios.i_funcionarios
   and beneficiarios.i_entidades = funcionarios.i_entidades 
   and funcionarios.dt_admissao<=  rescisoes.dt_rescisao;