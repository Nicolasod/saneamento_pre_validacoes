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
 where dc.i_tipos_proc in (11,41,42)
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

insert into bethadba.movimentos (
    i_entidades,
    i_tipos_proc,
    i_competencias,
    i_processamentos,
    i_funcionarios,
    i_eventos,
    vlr_inf,
    vlr_calc,
    tipo_pd,
    compoe_liq,
    classif_evento,
    mov_resc
)
select
    dc.i_entidades,
    dc.i_tipos_proc,
    dc.i_competencias,
    dc.i_processamentos,
    dc.i_funcionarios,
    1,         -- i_eventos
    0,         -- vlr_inf
    0,         -- vlr_calc
    'P',       -- tipo_pd
    'S',       -- compoe_liq
    0,         -- classif_evento
    'N'        -- mov_resc
from bethadba.dados_calc as dc
where dc.i_tipos_proc in (11,41,42)
  and dc.dt_fechamento is not null
  and not exists (
      select 1
        from bethadba.movimentos as m
       where m.i_funcionarios = dc.i_funcionarios
         and m.i_entidades = dc.i_entidades
         and m.i_tipos_proc = dc.i_tipos_proc
         and m.i_processamentos = dc.i_processamentos
         and m.i_competencias = dc.i_competencias
         and m.mov_resc = 'N'
  )
  and not exists (
      select 1
        from bethadba.movimentos as m
       where m.i_funcionarios = dc.i_funcionarios
         and m.i_entidades = dc.i_entidades
         and m.i_tipos_proc = dc.i_tipos_proc
         and m.i_processamentos = dc.i_processamentos
         and m.i_competencias = dc.i_competencias
         and m.mov_resc = 'S'
  );