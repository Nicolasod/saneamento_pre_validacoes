-- VALIDAÇÃO 165
-- Folhas de rescisão com processamentos incorretos

select dc.i_entidades,
       dc.i_funcionarios, 
       dc.i_tipos_proc, 
       dc.i_competencias, 
       m.mov_resc 
  from bethadba.dados_calc as dc
  join bethadba.movimentos m
    on dc.i_entidades = m.i_entidades
   and dc.i_funcionarios = m.i_funcionarios
   and dc.i_tipos_proc = m.i_tipos_proc
   and dc.i_processamentos = m.i_processamentos
   and dc.i_competencias = m.i_competencias
 where dc.i_tipos_proc not in (11, 42)
   and m.mov_resc = 'S';

-- CORREÇÃO
-- Atualiza os tipos de processo para 11 (Rescisão) onde necessário

update bethadba.dados_calc
  join bethadba.movimentos m
    on dc.i_entidades = m.i_entidades
   and dc.i_funcionarios = m.i_funcionarios
   and dc.i_tipos_proc = m.i_tipos_proc
   and dc.i_processamentos = m.i_processamentos
   and dc.i_competencias = m.i_competencias
   set i_tipos_proc = 11
 where dc.i_tipos_proc not in (11, 42)
   and m.mov_resc = 'S';