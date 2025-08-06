-- VALIDAÇÃO 4
-- Função Gratificada - Não pode ser incluída uma configuração com data anterior à data de admissão da matrícula

select funcoes_func.i_entidades,
       funcoes_func.i_funcionarios,
       dt_admissao,
       dt_inicial,
       dt_final
  from bethadba.funcoes_func
  left join bethadba.funcionarios 
    on funcoes_func.i_funcionarios = funcionarios.i_funcionarios
   and funcoes_func.i_entidades = funcionarios.i_entidades
 where dt_inicial < dt_admissao
    or dt_final < dt_admissao;


-- CORREÇÃO
-- Atualizar as datas de início e fim para que não sejam anteriores à data de admissão

update bethadba.funcoes_func
   set dt_inicial = dt_admissao,
       dt_final = dt_admissao
 where dt_inicial < dt_admissao
    or dt_final < dt_admissao;