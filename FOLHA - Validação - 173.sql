-- VALIDAÇÃO 173
-- Verifica se existem afastamentos de demissão com data de retorno preenchida.

select a.i_entidades,
       a.i_funcionarios,
       a.dt_afastamento,
       a.dt_ultimo_dia
  from bethadba.afastamentos a
  join bethadba.tipos_afast ta
    on a.i_tipos_afast = ta.i_tipos_afast
 where ta.classif = 8 
   and a.dt_ultimo_dia is not null
   and exists (select first 1
                 from bethadba.rescisoes r
                 join bethadba.motivos_resc mr
                   on r.i_motivos_resc = mr.i_motivos_resc
                 join bethadba.tipos_afast ta2
                   on mr.i_tipos_afast = ta2.i_tipos_afast
                where r.i_entidades = a.i_entidades
                  and r.i_funcionarios = a.i_funcionarios 
                  and r.dt_canc_resc is null            
                  and r.i_motivos_apos is null
                  and r.dt_rescisao = a.dt_afastamento
                  and ta2.classif = 8)
 order by i_entidades, i_funcionarios asc;
        
        
-- CORREÇÃO
-- Atualiza os registros da tabela afastamentos deixando nulo a coluna dt_ultimo_dia

update bethadba.afastamentos
   set dt_ultimo_dia = null
 where dt_ultimo_dia is not null
   and i_tipos_afast in (select a.i_tipos_afast
                           from bethadba.afastamentos a
                           join bethadba.tipos_afast ta
                             on a.i_tipos_afast = ta.i_tipos_afast
                          where ta.classif = 8
                            and a.dt_ultimo_dia is not null
                            and exists (select first 1
                                          from bethadba.rescisoes r
                                          join bethadba.motivos_resc mr
                                            on r.i_motivos_resc = mr.i_motivos_resc
                                          join bethadba.tipos_afast ta2
                                            on mr.i_tipos_afast = ta2.i_tipos_afast
                                         where r.i_entidades = a.i_entidades
                                           and r.i_funcionarios = a.i_funcionarios
                                           and r.dt_canc_resc is null
                                           and r.i_motivos_apos is null
                                           and r.dt_rescisao = a.dt_afastamento
                                           and ta2.classif = 8));