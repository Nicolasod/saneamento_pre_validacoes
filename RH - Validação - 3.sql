-- VALIDAÇÃO 3
-- Licença prêmio no cadastro de matrícula - Não pode ser incluída uma configuração com data anterior à data de admissão da matrícula

select licencas_premio_per.i_entidades,
       licencas_premio_per.i_funcionarios,
       funcionarios.dt_admissao,
       licencas_premio_per.dt_inicial,
       licencas_premio_per.dt_final
  from bethadba.licencas_premio
 inner join bethadba.licencas_premio_per
    on licencas_premio.i_entidades = licencas_premio_per.i_entidades
   and licencas_premio.i_licencas_premio = licencas_premio_per.i_licencas_premio
   and licencas_premio.i_funcionarios  = licencas_premio_per.i_funcionarios
 inner join bethadba.funcionarios 
    on licencas_premio.i_entidades = funcionarios.i_entidades
   and licencas_premio.i_funcionarios  = funcionarios.i_funcionarios
 where funcionarios.dt_admissao > licencas_premio_per.dt_inicial;


-- CORREÇÃO
-- A correção deve ser feita no cadastro de matrícula, onde não deve ser possível incluir uma licença prêmio com data inicial anterior à data de admissão do funcionário.

update bethadba.licencas_premio_per
   set dt_inicial = funcionarios.dt_admissao
  from bethadba.funcionarios
 where licencas_premio_per.i_entidades = funcionarios.i_entidades
   and licencas_premio_per.i_funcionarios = funcionarios.i_funcionarios
   and licencas_premio_per.dt_inicial < funcionarios.dt_admissao;