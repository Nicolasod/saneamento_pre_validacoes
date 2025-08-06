-- VALIDAÇÃO 115
-- Verifica os funcionarios sem historico de funcionarios

select distinct i_funcionarios 
  from bethadba.funcionarios
 where i_funcionarios not in (select i_funcionarios
                                from bethadba.hist_funcionarios);


-- CORREÇÃO
-- Insere o histórico de funcionários para os funcionários que não possuem histórico, utilizando os dados atuais dos funcionários

insert into bethadba.hist_funcionarios (i_entidades,i_funcionario,dt_alteracoes,i_config_organ,i_organogramas,i_grupos,i_vinculos,i_pessoas,i_bancos,i_agencias,i_pessoas_contas,i_horarios,func_princ,i_agentes_nocivos,optante_fgts,prev_federal,prev_estadual,fundo_ass,fundo_prev,ocorrencia_sefip,forma_pagto,multiplic,tipo_contrato,fundo_financ,remunerado_cargo_efetivo,i_turmas,num_quadro_cp,num_cp,provisorio,bate_cartao,i_pessoas_estagio,dt_final_estagio,nivel_curso_estagio,num_apolice_estagio,estagio_obrigatorio_estagio,i_agente_integracao_estagio,i_supervisor_estagio,controle_jornada,grau_exposicao,tipo_admissao,tipo_trabalhador,i_sindicatos,seguro_vida_estagio,categoria,desc_salario_variavel,duracao_ben,dt_vencto,tipo_beneficio,i_responsaveis,tipo_ingresso, aposentado, recebe_abono)
select a.i_entidades,a.i_funcionarios,a.dt_admissao,b.i_config_organ,b.i_organogramas,b.i_grupos,b.i_vinculos,b.i_pessoas,null,null,null,null,null,null,b.optante_fgts,b.prev_federal,b.prev_estadual,b.fundo_ass,b.fundo_prev,b.ocorrencia_sefip,b.forma_pagto,b.multiplic,null,b.fundo_financ,b.remunerado_cargo_efetivo,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,b.categoria,null,null,null,null,null,null,null,null
  from bethadba.funcionarios a
  join bethadba.hist_funcionarios b
    on (a.i_pessoas = b.i_pessoas)
 where b.i_funcionarios = (select max(x.i_funcionarios)
                             from bethadba.hist_funcionarios x
                            where x.i_pessoas = b.i_pessoas)
   and b.dt_alteracoes = (select max(s.dt_alteracoes)
                            from bethadba.hist_funcionarios s
                           where s.i_funcionarios = b.i_funcionarios) 
   and a.i_funcionarios in (select z.i_funcionarios
                              from bethadba.funcionarios z
                             where i_funcionarios not in (select i_funcionarios
                                                            from bethadba.hist_funcionarios));

-- Insere o histórico de funcionários para os funcionários que não possuem histórico, utilizando os dados atuais dos funcionários
-- Atenção: Certifique-se de que os dados inseridos estão corretos e completos, pois isso pode afetar a integridade dos dados do sistema.
-- Lembre-se de ajustar os valores de i_config_organ, i_organogramas e i_grupos conforme necessário, pois eles devem corresponder a valores válidos no seu sistema.
-- Certifique-se de que os campos i_bancos, i_agencias, i_pessoas _contas, i_horarios, i_turmas, num_quadro_cp e num_cp sejam preenchidos corretamente, se aplicável.
-- Atenção: Certifique-se de que os campos i_pessoas_estagio, dt_final_estagio, nivel_curso_estagio, num_apolice_estagio, estagio_obrigatorio_estagio, i_agente_integracao_estagio e i_supervisor_estagio sejam preenchidos corretamente, se aplicável.
-- Atenção: Certifique-se de que os campos controle_jornada, grau_exposicao, tipo_admissao, tipo_trabalhador, i_sindicatos, seguro_vida_estagio, categoria, desc_salario_variavel, duracao_ben, dt_vencto, tipo_beneficio, i_responsaveis, tipo_ingresso, aposentado e recebe_abono sejam preenchidos corretamente, se aplicável.
-- Atenção: Certifique-se de que os campos i_config_organ, i_organogramas, i_grupos, i_vinculos, i_pessoas, i_bancos, i_agencias, i_pessoas_contas, i_horarios, func_princ, i_agentes_nocivos, optante_fgts, prev_federal, prev_estadual, fundo

insert into bethadba.hist_funcionarios(i_entidades,i_funcionarios,    dt_alteracoes,i_config_organ,i_organogramas,i_grupos,i_vinculos,i_pessoas,i_bancos,i_agencias,i_pessoas_contas,i_horarios,func_princ,i_agentes_nocivos,optante_fgts,prev_federal,prev_estadual,fundo_ass,fundo_prev,ocorrencia_sefip,forma_pagto,multiplic,tipo_contrato,fundo_financ,remunerado_cargo_efetivo,i_turmas,num_quadro_cp,num_cp,provisorio,bate_cartao,i_pessoas_estagio,dt_final_estagio,nivel_curso_estagio,num_apolice_estagio,estagio_obrigatorio_estagio,i_agente_integracao_estagio,i_supervisor_estagio,controle_jornada,grau_exposicao,tipo_admissao,tipo_trabalhador,i_sindicatos,seguro_vida_estagio,categoria,desc_salario_variavel,duracao_ben,dt_vencto,tipo_beneficio,i_responsaveis,tipo_ingresso,aposentado,recebe_abono)
select a.i_entidades,a.i_funcionarios,a.dt_admissao,1,'000000000' //ADICIONAR UM ORGANOGRAMA VALIDO, LEMBRANDO QUE O MESMO DEVE SER UMA STRING,1,5,a.i_pessoas,null,null,null,null,null,null,'N','S','N','N','N',0,'R',1,null,'N','N',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'M',null,null,null,null,null,null,null,null
  from bethadba.funcionarios a
 where i_funcionarios in (select z.i_funcionarios
                            from bethadba.funcionarios z
                           where i_funcionarios not in (select i_funcionarios
                                                          from bethadba.hist_funcionarios));