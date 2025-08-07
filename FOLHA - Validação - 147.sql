-- VALIDAÇÃO 147
-- Calculo mensal sem movimentações

select dc.i_entidades,
       dc.i_funcionarios,
       dc.i_competencias,
       dc.i_processamentos,
       dc.i_tipos_proc,
       dc.dt_pagto,
       temRescisao = if exists (select 1 
                                  from bethadba.movimentos as m
                                 where m.i_entidades = dc.i_entidades
                                   and m.i_funcionarios = dc.i_funcionarios
                                   and m.i_tipos_proc = dc.i_tipos_proc
                                   and m.i_processamentos = dc.i_processamentos
                                   and m.i_competencias = dc.i_competencias
                                   and m.mov_resc = 'S') then 'S' else 'N' endif
  from bethadba.dados_calc as dc
 where dc.i_tipos_proc in (11, 41, 42)
   and dc.dt_fechamento is not null
   and temRescisao = 'N'
   and not exists (select 1
                     from bethadba.movimentos as m 
                    where m.i_funcionarios = dc.i_funcionarios
                      and m.i_entidades = dc.i_entidades
                      and m.i_tipos_proc = dc.i_tipos_proc
                      and m.i_processamentos = dc.i_processamentos
                      and m.i_competencias = dc.i_competencias
                      and m.mov_resc = 'N');


-- CORREÇÃO
-- Verificar se o funcionário realmente não possui movimentações no período.
-- Caso positivo, excluir o registro da tabela dados_calc.

delete 
  from bethadba.dados_calc
 where i_tipos_proc in (11, 41, 42)
   and dt_fechamento is not null
   and not exists (select 1
                     from bethadba.movimentos as m 
                    where m.i_funcionarios = bethadba.dados_calc.i_funcionarios
                      and m.i_entidades = bethadba.dados_calc.i_entidades
                      and m.i_tipos_proc = bethadba.dados_calc.i_tipos_proc
                      and m.i_processamentos = bethadba.dados_calc.i_processamentos
                      and m.i_competencias = bethadba.dados_calc.i_competencias);