-- VALIDAÇÃO 116
-- Verifica os funcionarios sem historico de cargo

select i_funcionarios
  from bethadba.funcionarios  
 where i_funcionarios not in (select i_funcionarios
                                from bethadba.hist_cargos);


-- CORREÇÃO
-- Insere o histórico de cargo para os funcionários que não possuem histórico, assumindo o cargo atual como o último

insert into bethadba.hist_cargos
       (i_entidades,
        i_funcionarios,
        dt_alteracoes,
        dt_saida,
        i_cargos,
        i_motivos_altcar,
        i_atos,
        i_concursos,
        dt_nomeacao,
        dt_posse,
        i_atos_saida,
        parecer_contr_interno,
        afim,
        desconsidera_rotina_prorrogacao,
        desconsidera_rotina_rodada,
        dt_exercicio,
        reabilitado_readaptado)
select f.i_entidades,
       f.i_funcionarios,
       CAST(f.dt_admissao AS datetime),
       null,
       'INFORMAR O CARGO A SER VINCULADO A MATRÍCULA',
       null,
       null,
       null,
       null,
       null,
       null,
       'S',
       null,
       'N',
       'N',
       f.dt_admissao, -- já está no formato date
       null
  from bethadba.funcionarios f
 where f.i_funcionarios not in (select i_funcionarios
                                  from bethadba.hist_cargos);