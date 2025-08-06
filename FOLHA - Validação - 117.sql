-- VALIDAÇÃO 117
-- Verifica os funcionarios sem historico

select f.i_funcionarios
  from bethadba.funcionarios as f
 where f.i_funcionarios not in (select hs.i_funcionarios
 								                  from bethadba.hist_salariais as hs);


-- CORREÇÃO
-- Insere o histórico salarial para os funcionários que não possuem histórico, assumindo o salário atual como o último

insert into bethadba.hist_salariais
       (i_entidades,
        i_funcionarios,
        dt_alteracoes,
        i_niveis,
        i_clas_niveis,
        i_referencias,
        i_motivos_altsal,
        i_atos,salario,
        horas_mes,
        horas_sem,
        observacao,
        controla_jornada_parc,
        deduz_iss,
        aliq_iss,
        qtd_dias_servico,
        dt_alteracao_esocial,
        dt_chave_esocial)
select f.i_entidades,
       f.i_funcionarios,
       CAST(f.dt_admissao AS datetime),
       null,
       null,
       null,
       null,
       null,
       0.01,
       200.00,
       40.00,
       null,
       null,
       null,
       null,
       null,
       null,
       f.dt_admissao -- já está no formato date
  from bethadba.funcionarios f
 where f.i_funcionarios not in (select hs.i_funcionarios
                                  from bethadba.hist_salariais as hs);