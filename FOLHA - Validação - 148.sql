-- VALIDAÇÃO 148
-- Calculo de ferias sem registros

select dc.i_entidades,
       dc.i_funcionarios,
       dc.i_competencias,
       dc.i_processamentos,
       dc.i_tipos_proc,
       dc.dt_pagto
  from bethadba.dados_calc as dc
 where dc.i_tipos_proc = 80
   and dc.dt_fechamento is not null
   and not exists (select 1 
                     from bethadba.ferias_proc as fp
                     left join bethadba.ferias as f
                       on (fp.i_entidades = f.i_entidades
                      and fp.i_funcionarios = f.i_funcionarios
                      and fp.i_ferias = f.i_ferias)
                    where dc.i_entidades = fp.i_entidades
                      and dc.i_funcionarios = fp.i_funcionarios
                      and dc.i_tipos_proc = fp.i_tipos_proc
                      and dc.i_processamentos = fp.i_processamentos
                      and dc.i_competencias = fp.i_competencias);


-- CORREÇÃO
-- Deletar os registros da tabela dados_calc referente ao calculo de ferias sem registros na tabela ferias_proc e ferias

delete from bethadba.dados_calc
 where i_tipos_proc = 80
   and dt_fechamento is not null
   and not exists (select 1 
                     from bethadba.ferias_proc as fp
                     left join bethadba.ferias as f
                       on (fp.i_entidades = f.i_entidades
                      and fp.i_funcionarios = f.i_funcionarios
                      and fp.i_ferias = f.i_ferias)
                    where bethadba.dados_calc.i_entidades = fp.i_entidades
                      and bethadba.dados_calc.i_funcionarios = fp.i_funcionarios
                      and bethadba.dados_calc.i_tipos_proc = fp.i_tipos_proc
                      and bethadba.dados_calc.i_processamentos = fp.i_processamentos
                      and bethadba.dados_calc.i_competencias = fp.i_competencias);