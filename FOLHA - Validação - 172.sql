-- VALIDAÇÃO 172
-- Rescisão sem afastamento ou data divergente do afastamento com a rescisão.

select r.i_entidades,
       r.i_funcionarios,
       r.dt_rescisao
  from bethadba.rescisoes r
  join bethadba.motivos_resc mr
    on r.i_motivos_resc = mr.i_motivos_resc
  join bethadba.tipos_afast ta2
    on mr.i_tipos_afast = ta2.i_tipos_afast
 where ta2.classif = 8
   and r.i_motivos_apos is null
   and mr.dispensados <> 4
   and not exists (select 1
                     from bethadba.afastamentos a
                     join bethadba.tipos_afast ta
                       on a.i_tipos_afast = ta.i_tipos_afast
                    where ta.classif = 8 
                      and a.i_entidades = r.i_entidades
                      and a.i_funcionarios = r.i_funcionarios 
                      and a.dt_afastamento = r.dt_rescisao)

union all

select r.i_entidades,
       r.i_funcionarios,
       r.dt_rescisao
  from bethadba.rescisoes r
  join bethadba.motivos_apos mr
    on r.i_motivos_apos = mr.i_motivos_apos
  join bethadba.tipos_afast ta2
    on mr.i_tipos_afast = ta2.i_tipos_afast
 where ta2.classif = 9
   and r.i_motivos_apos is not null
   and not exists (select 1
                     from bethadba.afastamentos a
                     join bethadba.tipos_afast ta
                       on a.i_tipos_afast = ta.i_tipos_afast
                    where ta.classif = 9
                      and a.i_entidades = r.i_entidades
                      and a.i_funcionarios = r.i_funcionarios
                      and a.dt_afastamento = r.dt_rescisao)

union all 

select r.i_entidades,
       r.i_funcionarios,
       r.dt_rescisao
  from bethadba.rescisoes r
  join bethadba.motivos_apos mr
    on r.i_motivos_apos = mr.i_motivos_apos
  join bethadba.tipos_afast ta2
    on mr.i_tipos_afast = ta2.i_tipos_afast
 where ta2.classif = 8
   and r.i_motivos_apos is not null
   and not exists(select 1
                    from bethadba.afastamentos a
                    join bethadba.tipos_afast ta
                      on a.i_tipos_afast = ta.i_tipos_afast
                   where ta.classif = 8
                     and a.i_entidades = r.i_entidades
                     and a.i_funcionarios = r.i_funcionarios
                     and a.dt_afastamento = r.dt_rescisao)

 order by i_funcionarios asc


-- CORREÇÃO
-- Atualizar o afastamento com a data da rescisão se não houver afastamento, criar um novo com a data da rescisão

update bethadba.afastamentos
   set dt_afastamento = r.dt_rescisao
  from bethadba.rescisoes r
  join bethadba.tipos_afast ta
    on (ta.classif = 8 or ta.classif = 9)
 where afastamentos.i_entidades = r.i_entidades
   and afastamentos.i_funcionarios = r.i_funcionarios
   and afastamentos.dt_afastamento = r.dt_rescisao
   and afastamentos.i_tipos_afast = ta.i_tipos_afast
   and not exists (select 1
                     from bethadba.rescisoes rr
                    where rr.i_entidades = r.i_entidades
                      and rr.i_funcionarios = r.i_funcionarios
                      and rr.dt_rescisao = r.dt_rescisao);

-- Se não houver afastamento, criar um novo afastamento com a data da rescisão.
insert into bethadba.afastamentos(
       i_entidades,
       i_funcionarios,
       dt_afastamento,
       i_tipos_afast,
       i_atos,
       dt_ultimo_dia,
       req_benef,
       comp_comunic,
       observacao,
       manual,
       sequencial,
       dt_afastamento_origem,
       desconsidera_rotina_prorrogacao,
       desconsidera_rotina_rodada,
       parecer_interno,
       conversao_fim_mp_664_2014,
       i_cid,
       i_medico_emitente,
       orgao_classe,
       nr_conselho,
       i_estados_orgao,
       acidente_transito,
       retificacao,
       dt_afastamento_retificacao,
       dt_retificacao,
       i_tipos_afast_antes,
       dt_afastamento_geracao,
       i_tipos_afast_geracao,
       origem_retificacao,
       tipo_processo,
       numero_processo)
select r.i_entidades,
       r.i_funcionarios,
       r.dt_rescisao,
       ta.i_tipos_afast,
       null,    -- i_atos
       null,    -- dt_ultimo_dia
       null,    -- req_benef
       null,    -- comp_comunic
       null,    -- observacao
       'S',     -- manual
       null,    -- sequencial
       null,    -- dt_afastamento_origem
       'N',     -- desconsidera_rotina_prorrogacao
       'N',     -- desconsidera_rotina_rodada
       'N',     -- parecer_interno
       'N',     -- conversao_fim_mp_664_2014
       null,    -- i_cid
       null,    -- i_medico_emitente
       null,    -- orgao_classe
       null,    -- nr_conselho
       null,    -- i_estados_orgao
       null,    -- acidente_transito
       'N',     -- retificacao
       null,    -- dt_afastamento_retificacao
       null,    -- dt_retificacao
       null,    -- i_tipos_afast_antes
       null,    -- dt_afastamento_geracao
       null,    -- i_tipos_afast_geracao
       null,    -- origem_retificacao
       null,    -- tipo_processo
       null     -- numero_processo
  from bethadba.rescisoes r
  join bethadba.tipos_afast ta
    on (ta.classif = 8 or ta.classif = 9)
 where not exists (select 1
                     from bethadba.afastamentos a
                    where a.i_entidades = r.i_entidades
                      and a.i_funcionarios = r.i_funcionarios
                      and a.dt_afastamento = r.dt_rescisao
                      and a.i_tipos_afast = ta.i_tipos_afast);