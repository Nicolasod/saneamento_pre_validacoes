-- VALIDAÇÃO 110
-- Verifica afastamentos concomitantes do mesmo funcionario

select a.i_entidades,
       a.i_funcionarios,
       a.dt_afastamento,
       isnull(a.dt_ultimo_dia, a.dt_afastamento) as dt_ultimo_dia,
       temRescisao = (select 1
       					        from bethadba.tipos_afast ta
       				         where ta.i_tipos_afast = a.i_tipos_afast
       				           and ta.classif = 8),
       trabalhouUltimoDia = if temRescisao is not null then
                              (select r.trab_dia_resc
                                 from bethadba.rescisoes r
                          		   join bethadba.motivos_resc mr
                                   on r.i_motivos_resc = mr.i_motivos_resc
                                 join bethadba.tipos_afast ta2
                                   on mr.i_tipos_afast = ta2.i_tipos_afast
                                where r.i_entidades = a.i_entidades
                                  and r.i_funcionarios = a.i_funcionarios
                                  and ta2.classif in (8,9))
                            else
                              'N'
                            endif
  from bethadba.afastamentos a
  join bethadba.afastamentos b
    on a.i_entidades = b.i_entidades
   and a.i_funcionarios = b.i_funcionarios
 where (a.dt_afastamento between b.dt_afastamento and b.dt_ultimo_dia or a.dt_ultimo_dia between b.dt_afastamento and b.dt_ultimo_dia)
   and (a.dt_afastamento <> b.dt_afastamento or a.dt_ultimo_dia <> b.dt_ultimo_dia)
   and temRescisao is null
   and (trabalhouUltimoDia is null or trabalhouUltimoDia = 'N');


-- CORREÇÃO
-- Atualiza a data do último dia do afastamento para funcionários que possuem afastamentos concomitantes

update bethadba.afastamentos a
  join bethadba.afastamentos b
    on a.i_entidades = b.i_entidades
   and a.i_funcionarios = b.i_funcionarios
   and (a.dt_afastamento between b.dt_afastamento and b.dt_ultimo_dia or a.dt_ultimo_dia between b.dt_afastamento and b.dt_ultimo_dia)
   and (a.dt_afastamento <> b.dt_afastamento or a.dt_ultimo_dia <> b.dt_ultimo_dia)
   set a.dt_ultimo_dia = dateadd(dd, -1, b.dt_afastamento)
 where a.i_entidades = b.i_entidades
   and a.i_funcionarios = b.i_funcionarios
   and (a.dt_afastamento between b.dt_afastamento and b.dt_ultimo_dia or a.dt_ultimo_dia between b.dt_afastamento and b.dt_ultimo_dia)
   and (a.dt_afastamento <> b.dt_afastamento or a.dt_ultimo_dia <> b.dt_ultimo_dia);