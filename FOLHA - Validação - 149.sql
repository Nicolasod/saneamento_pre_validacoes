-- VALIDAÇÃO 149
-- Pensionistas não registrados

select f.i_entidades,
       f.i_funcionarios,
       f.tipo_pens
  from bethadba.funcionarios as f 
 where f.tipo_pens in (1, 2)
   and f.tipo_func = 'B'
   and not exists (select 1
                     from bethadba.beneficiarios as b
                    where f.i_entidades = b.i_entidades
                      and f.i_funcionarios = b.i_funcionarios)
 order by f.i_entidades, f.i_funcionarios asc;


-- CORREÇÃO
-- Inserir os pensionistas não registrados na tabela de beneficiários

insert into bethadba.beneficiarios (i_entidades,i_funcionarios,i_entidades_inst,i_instituidor,i_atos,duracao_ben,dt_vencto,perc_recebto,config,alvara,dt_alvara,situacao,dt_cessacao,motivo_cessacao,parecer_interno,motivo_inicio,origem_beneficio,nr_beneficio,acao_judicial,matricula_instituidor,cnpj_instituidor,tipo_beneficio,data_recebido,cnpj_ente_sucedido,observacao_beneficio,nr_beneficio_anterior)
select f.i_entidades,
       f.i_funcionarios,
       1 as i_entidades_inst, -- Supondo que a entidade do instituidor é a entidade 1
       1 as i_instituidor, -- Supondo que o instituidor é o ID 1
       null as i_atos,
       'V' as duracao_ben, -- Supondo que a Data de duração do benefício é 'V - Vitalícia'
       null as dt_vencto,
       100 as perc_recebto, -- Percentual de recebimento padrão '100%'
       1 as config, -- Configuração padrão
       null as alvara,
       null as dt_alvara,
       null as situacao,
       null as dt_cessacao,
       null as motivo_cessacao,
       'N' as parecer_interno, -- Parecer interno padrão 'N - Nenhum'
       null as motivo_inicio,
       null as origem_beneficio,
       null as nr_beneficio,
       null as acao_judicial,
       null as matricula_instituidor,
       null as cnpj_instituidor,
       null as tipo_beneficio,
       null as data_recebido,
       null as cnpj_ente_sucedido,
       null as observacao_beneficio,
       null as nr_beneficio_anterior
  from bethadba.funcionarios as f 
 where f.tipo_pens in (1, 2)
   and f.tipo_func = 'B'
   and not exists (select 1
                     from bethadba.beneficiarios as b
                    where f.i_entidades = b.i_entidades
                      and f.i_funcionarios = b.i_funcionarios);