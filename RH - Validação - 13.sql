-- VALIDAÇÃO 13
-- Cursos concomitantes - Existem cursos concomitantes para a mesma pessoa

select pessoa = cp.i_pessoas,
       cursoPessoa = cp.i_cursos,
       dataInicial = cp.dt_inicial,
       dataFinal = cp.dt_final
  from bethadba.cursos_pessoas as cp
 where cp.participacao = 3
   and exists(select first 1
                from bethadba.cursos_pessoas as cp2
               where pessoa = cp2.i_pessoas
                 and cursoPessoa = cp2.i_cursos
                 and (cp2.dt_inicial between dataInicial and dataFinal
                  or cp2.dt_final between dataInicial and dataFinal));


-- CORREÇÃO
-- Verificar se os cursos são realmente concomitantes. Caso positivo, alterar a data final do curso de data inicial menor para um dia anterior a data incial do curso que possuir data inicial maior.

-- Exemplo de correção:
update bethadba.cursos_pessoas
   set dt_final = dateadd(day, -1, dt_inicial)
 where participacao = 3
   and exists(select first 1
                from bethadba.cursos_pessoas as cp2
               where i_pessoas = cp2.i_pessoas
                 and i_cursos = cp2.i_cursos
                 and (cp2.dt_inicial between dt_inicial and dt_final
                  or cp2.dt_final between dt_inicial and dt_final));