-- VALIDAÇÃO 152
-- Instituidor sem afastamento

select f.i_entidades, 
       f.i_funcionarios,
       b.i_entidades_inst,
       b.i_instituidor,
       f.tipo_pens
  from bethadba.funcionarios f 
  join bethadba.beneficiarios b
    on f.i_entidades = b.i_entidades
   and f.i_funcionarios = b.i_funcionarios 
 where f.tipo_func = 'B' 
   and f.tipo_pens in (1, 2)
   and exists (select 1
                 from bethadba.rescisoes r 
                 join bethadba.motivos_apos ma
                   on r.i_motivos_apos = ma.i_motivos_apos 
                 join bethadba.tipos_afast ta
                   on ma.i_tipos_afast = ta.i_tipos_afast
                where r.i_entidades = b.i_entidades_inst
                  and r.i_funcionarios = b.i_instituidor
                  and r.i_motivos_apos is not null
                  and r.dt_canc_resc is null
                  and ta.classif = 9)
   and not exists (select 1
                     from bethadba.afastamentos a
                     join bethadba.tipos_afast ta2
                       on a.i_tipos_afast = ta2.i_tipos_afast
                    where a.i_entidades = b.i_entidades_inst
                      and a.i_funcionarios = b.i_instituidor
                      and ta2.classif = 9)
 order by f.i_entidades, f.i_funcionarios asc;


-- CORREÇÃO
-- Insere um afastamento para o instituidor com a classificação 9

insert into bethadba.afastamentos (i_entidades,i_funcionarios,dt_afastamento,i_tipos_afast,i_atos,dt_ultimo_dia,req_benef,comp_comunic,observacao,manual,sequencial,dt_afastamento_origem,desconsidera_rotina_prorrogacao,desconsidera_rotina_rodada,parecer_interno,conversao_fim_mp_664_2014,i_cid,i_medico_emitente,orgao_classe,nr_conselho,i_estados_orgao,acidente_transito,retificacao,dt_afastamento_retificacao,dt_retificacao,i_tipos_afast_antes,dt_afastamento_geracao,i_tipos_afast_geracao,origem_retificacao,tipo_processo,numero_processo)
select b.i_entidades,
       b.i_instituidor,
       dataAfastamento = (select dt_rescisao
                            from bethadba.rescisoes r 
                            join bethadba.motivos_apos ma
                              on r.i_motivos_apos = ma.i_motivos_apos 
                            join bethadba.tipos_afast ta
                              on ma.i_tipos_afast = ta.i_tipos_afast
                           where r.i_entidades = b.i_entidades_inst
                             and r.i_funcionarios = b.i_instituidor
                             and r.i_motivos_apos is not null
                             and r.dt_canc_resc is null
                             and ta.classif = 9),
       tiposAfastamento = (select ta.i_tipos_afast
                             from bethadba.rescisoes r 
                             join bethadba.motivos_apos ma
                               on r.i_motivos_apos = ma.i_motivos_apos 
                             join bethadba.tipos_afast ta
                               on ma.i_tipos_afast = ta.i_tipos_afast
                            where r.i_entidades = b.i_entidades_inst
                              and r.i_funcionarios = b.i_instituidor
                              and r.i_motivos_apos is not null
                              and r.dt_canc_resc is null
                              and ta.classif = 9),
       null,
       null,
       null,
       null,
       null,
       'S',
       null,
       null,
       'N',
       'N',
       'N',
       'N',
       null,
       null,
       null,
       null,
       null,
       null,
       'N',
       null,
       null,
       null,
       null,
       null,
       null,
       null,
       null
  from bethadba.funcionarios f
  join bethadba.beneficiarios b
    on f.i_entidades = b.i_entidades
   and f.i_funcionarios = b.i_funcionarios
 where f.tipo_func = 'B'
   and f.tipo_pens in (1, 2)
   and exists (select 1
                 from bethadba.rescisoes r 
                 join bethadba.motivos_apos ma
                   on r.i_motivos_apos = ma.i_motivos_apos 
                 join bethadba.tipos_afast ta
                   on ma.i_tipos_afast = ta.i_tipos_afast
                where r.i_entidades = b.i_entidades_inst
                  and r.i_funcionarios = b.i_instituidor
                  and r.i_motivos_apos is not null
                  and r.dt_canc_resc is null
                  and ta.classif = 9)
   and not exists (select 1
                     from bethadba.afastamentos a
                     join bethadba.tipos_afast ta2
                       on a.i_tipos_afast = ta2.i_tipos_afast
                    where a.i_entidades = b.i_entidades_inst
                      and a.i_funcionarios = b.i_instituidor
                      and ta2.classif = 9);