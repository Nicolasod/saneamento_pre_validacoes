call bethadba.dbp_conn_gera (1, year(today()), 300, 0);
call bethadba.pg_setoption('fire_triggers','off');
call bethadba.pg_setoption('wait_for_COMMIT','on');
commit;

-- FOLHA - Validação - 153

-- Atualizar a lotação fisica principal 'S' para apenas uma por funcionário, setando as demais para 'N' considerando como principal a lotação física com data inicial menor e sem data final
-- ou com data final maior que as demais.

update bethadba.locais_mov lm1
   set principal = 'S'
 where principal = 'N'
   and not exists (
       select 1
         from bethadba.locais_mov lm2
        where lm2.i_entidades = lm1.i_entidades
          and lm2.i_funcionarios = lm1.i_funcionarios
          and lm2.principal = 'S'
          and (lm2.dt_inicial < lm1.dt_inicial
            or (lm2.dt_inicial = lm1.dt_inicial
            and (lm2.dt_final is null
             or lm2.dt_final > lm1.dt_final)))
   );

update bethadba.locais_mov lm
   set principal = 'N'
 where principal = 'S'
   and exists (
       select 1
         from bethadba.locais_mov lm2
        where lm2.i_entidades = lm.i_entidades
          and lm2.i_funcionarios = lm.i_funcionarios
          and lm2.principal = 'S'
          and (lm2.dt_inicial < lm.dt_inicial
            or (lm2.dt_inicial = lm.dt_inicial
            and (lm2.dt_final is null
             or lm2.dt_final > lm.dt_final)))
   );

commit;

-- FOLHA - Validação - 156

-- Deletar duplicidade de dependentes com mais de uma configuração de IRRF quando o dependente for o mesmo

delete from bethadba.dependentes_func
 where rowid in (select df.rowid
                   from (select i_dependentes,
                                dep_irrf,
                                row_number() over (partition by i_dependentes order by rowid) as rn
                           from bethadba.dependentes_func) df
                  where df.rn > 1
                    and df.i_dependentes in (select i_dependentes
                                               from (select i_dependentes,
                                                            count(i_dependentes) as total
                                                       from (select distinct i_dependentes,
                                                                             dep_irrf
                                                               from bethadba.dependentes_func) as thd
                                                      group by i_dependentes
                                                     having total > 1)));

commit;

-- FOLHA - Validação - 163

-- 1. Realizar update para inserir um valor no campo vlr_prev_oficial
-- 2. Inserir na tabela processos_judic_pagamentos_det o relacionamento com os processos judiciais
-- 3. Inserir na tabela processos_judic_pagamentos_encargos o relacionamento com os processos judiciais

-- Update para o campo vlr_prev_oficial
update bethadba.processos_judic_compet
   set vlr_prev_oficial = 1;

-- Insert para o relacionamento com a tabela processos_judic_pagamentos_det
insert into bethadba.processos_judic_pagamentos_det
      (i_entidades, i_funcionarios, i_processos_judiciais, i_competencias, i_tipos_proc, data_referencia)
select pj.i_entidades,
       pj.i_funcionarios,
       pj.i_processos_judiciais,
       pj.dt_final,
       11,
       pj.dt_final
  from bethadba.processos_judiciais pj
 where pj.i_funcionarios not in (select i_funcionarios
                                   from bethadba.processos_judic_pagamentos_encargos);
                  
-- Insert para o relacionamento com a tabela processos_judic_pagamentos_encargos
insert into bethadba.processos_judic_pagamentos_encargos
      (i_entidades, i_funcionarios, i_processos_judiciais, i_competencias, i_tipos_proc, data_referencia, i_receitas, aliquota, valor_inss)
select 1,
       pj.i_funcionarios,
       pj.i_processos_judiciais,
       pj.dt_final,
       11,
       pj.dt_final,
       113851,
       null,
       null
  from bethadba.processos_judiciais pj
 where pj.i_funcionarios not in (select i_funcionarios
                                   from bethadba.processos_judic_pagamentos_encargos)
   and pj.i_processos_judiciais not in (select i_processos_judiciais
                                          from bethadba.processos_judic_pagamentos_encargos);

commit;

-- FOLHA - Validação - 171

-- Afastamentos sem rescisão ou data divergente da rescisão com o afastamento.

begin
    declare w_i_entidades integer;
    declare w_i_funcionarios integer;
    declare w_dt_afastamento timestamp;
    
    llLoop: for ll as cur_01 dynamic scroll cursor for
        select a.i_entidades,
               a.i_funcionarios,
               a.dt_afastamento,
               dt_rescisao = (select first r.dt_rescisao
                                from bethadba.rescisoes r
                               where r.dt_canc_resc is null
                                 and r.i_entidades = a.i_entidades
                                 and r.i_funcionarios = a.i_funcionarios
                                 and r.dt_rescisao = a.dt_afastamento)
          from bethadba.afastamentos a
          join bethadba.tipos_afast ta
            on a.i_tipos_afast = ta.i_tipos_afast
         where ta.classif = 8
           and a.dt_ultimo_dia is null
           and dt_rescisao is null
         order by i_funcionarios asc
    do 
        set w_i_entidades = i_entidades;
        set w_i_funcionarios = i_funcionarios;
        set w_dt_afastamento = dt_afastamento;
  
        update bethadba.rescisoes 
           set dt_rescisao = w_dt_afastamento
         where i_funcionarios = w_i_funcionarios
           and i_entidades = w_i_entidades;
  
        -- DEPOIS DESCOMENTAR as LINHAS A BAIXO E RODA-LAS
        -- insert into bethadba.rescisoes
        --  (i_entidades,i_funcionarios,i_rescisoes,i_motivos_resc,dt_rescisao,aviso_ind,vlr_saldo_fgts,fgts_mesant,compl_mensal,complementar,trab_dia_resc,proc_adm,deb_adm_pub,tipo_decisao,mensal,repor_vaga,aviso_desc,dt_chave_esocial)
        -- values (w_i_entidades,w_i_funcionarios,1,15,w_dt_afastamento,'N',0,'S','N','N','N','N','N','A','N','N','N',w_dt_afastamento);

    end for;
end;

commit;

-- FOLHA - Validação - 18

-- Atualiza os CBO's nulos para um valor padrão (exemplo: 312320) para evitar problemas de integridade referencial

update bethadba.cargos
   set i_cbo = 312320 
 where i_cargos = 9999;

commit;

-- FOLHA - Validação - 180

-- Remove a configuração de férias dos cargos com classificação comissionado ou não classificado

update bethadba.cargos_compl cc
   set i_config_ferias = null
  from bethadba.cargos c
  join bethadba.tipos_cargos tc
    on c.i_tipos_cargos = tc.i_tipos_cargos
 where c.i_entidades = cc.i_entidades
   and c.i_cargos = cc.i_cargos
   and tc.classif in (0, 2)
   and cc.i_config_ferias is not null;

commit;

-- FOLHA - Validação - 181

-- Inserir as caracteristicas que não existem na tabela de caracteristicas CFG

insert into bethadba.funcionarios_caract_cfg (i_caracteristicas, ordem, permite_excluir, dt_expiracao)
select fpa.i_caracteristicas,
       (select coalesce(max(ordem), 0) + row_number() over (order by fpa.i_caracteristicas)
          from bethadba.funcionarios_caract_cfg) as ordem,
       'S',
       to_date('31/12/9999','dd/mm/yyyy')
  from bethadba.funcionarios_prop_adic fpa
 where fpa.i_caracteristicas not in (select i_caracteristicas
                                       from bethadba.funcionarios_caract_cfg);

commit;

-- FOLHA - Validação - 187

-- Atualizar os registros com número da certidão contendo mais de 15 dígitos para os modelos antigos.

update bethadba.pessoas_fis_compl
   set num_reg = bethadba.dbf_retira_caracteres_especiais(num_reg)
 where i_pessoas in (select i_pessoas
                       from (select i_pessoas,
                                    modelo = if isnumeric(bethadba.dbf_retira_caracteres_especiais(pessoas_fis_compl.num_reg)) = 1 then
                                                'NOVO'
                                             else
                                                'ANTIGO'
                                             endif,
                                    numeroNascimento = if modelo = 'ANTIGO' then 
                                                          pessoas_fis_compl.num_reg 
                                                       else
                                                          bethadba.dbf_retira_alfa_de_inteiros(pessoas_fis_compl.num_reg)
                                                       endif
                               from bethadba.pessoas_fis_compl
                              where numeroNascimento is not null
                                and length(numeroNascimento) > 15
                                and modelo = 'ANTIGO') as subquery);

commit;

-- FOLHA - Validação - 189

-- Atualiza o histórico do nivel com a data do histórico do cargo
update bethadba.hist_niveis
   set dt_alteracoes = (select min(a.dt_alteracoes)
   						  from bethadba.hist_cargos_compl as a
   						 where a.i_entidades = hist_niveis.i_entidades
						   and a.i_niveis =hist_niveis.i_niveis)
 where dt_alteracoes < (select min(c.dt_alteracoes)
 						  from bethadba.hist_niveis as c
						 where c.i_entidades = hist_niveis.i_entidades
						   and c.i_niveis = hist_niveis.i_niveis);

-- Se a correção acima não resolver, fazer um update do histórico do cargo com a data do histórico do nivel
update bethadba.hist_cargos_compl
   set dt_alteracoes = (select min(a.dt_alteracoes)
   						  from bethadba.hist_niveis as a
   						 where a.i_entidades = hist_cargos_compl.i_entidades
						   and a.i_niveis = hist_cargos_compl.i_niveis)
 where dt_alteracoes < (select min(c.dt_alteracoes)
 						  from bethadba.hist_cargos_compl as c
						 where c.i_entidades = hist_cargos_compl.i_entidades
						   and c.i_niveis = hist_cargos_compl.i_niveis);

-- Se a correção acima não resolver, fazer um insert de um novo histórico na data do histórico do cargo
insert into bethadba.hist_cargos_compl (i_entidades,i_cargos,dt_alteracoes,i_niveis,i_clas_niveis_ini,i_referencias_ini,i_clas_niveis_fin,i_referencias_fin,i_atos,dt_final)
select i_entidades,
	   i_cargos,
	   (select min(a.dt_alteracoes)
		  from bethadba.hist_niveis as a
		 where a.i_entidades = hist_cargos_compl.i_entidades
		   and a.i_niveis = hist_cargos_compl.i_niveis) as dt_alteracoes,
	   i_niveis,
	   i_clas_niveis_ini,
	   i_referencias_ini,
	   i_clas_niveis_fin,
	   i_referencias_fin,
	   i_atos,
	   null
  from bethadba.hist_cargos_compl
 where dt_alteracoes > (select min(c.dt_alteracoes)
						  from bethadba.hist_niveis as c
						 where c.i_entidades = hist_cargos_compl.i_entidades
						   and c.i_niveis = hist_cargos_compl.i_niveis);

commit;

-- FOLHA - Validação - 198

-- Cria tabela temporária para ajustar os dados

create table cnv_ajusta_198(i_entidades integer, i_funcionarios integer, dataAlteracao timestamp, i_niveis integer, i_cargos integer);


-- Insere os dados na tabela temporária cnv_ajusta_198

insert into cnv_ajusta_198(i_entidades integer, i_funcionarios integer, dataAlteracao timestamp, i_niveis integer, i_cargos integer)
select distinct funcionarios.i_entidades as chave_dsk1,
       funcionarios.i_funcionarios as chave_dsk2,        
       dataAlteracao = tabAlt.dataAlteracao,
       hs.i_niveis,
       hc.i_cargos
  from bethadba.funcionarios,
       bethadba.hist_cargos hc 
  left outer join bethadba.concursos
    on (hc.i_entidades = concursos.i_entidades
   and hc.i_concursos = concursos.i_concursos),
       bethadba.hist_funcionarios hf,
       bethadba.hist_salariais hs
  left outer join bethadba.niveis
    on niveis.i_entidades = hs.i_entidades
   and niveis.i_niveis = hs.i_niveis
  left outer join bethadba.planos_salariais
    on planos_salariais.i_planos_salariais = niveis.i_planos_salariais,
       (select entidade = f.i_entidades,
               funcionario = f.i_funcionarios,
               dataAlteracao = hf.dt_alteracoes,
               origemHistorico = 'FUNCIONARIO'
          from bethadba.funcionarios f 
          join bethadba.hist_funcionarios hf
            on (f.i_entidades = hf.i_entidades
           and f.i_funcionarios = hf.i_funcionarios
           and hf.dt_alteracoes <= isnull((select first afast.dt_afastamento
                                             from bethadba.afastamentos afast
                                            where afast.i_entidades = f.i_entidades
                                              and afast.i_funcionarios = f.i_funcionarios
                                              and afast.i_tipos_afast = (select tipos_afast.i_tipos_afast
                                                                           from bethadba.tipos_afast 
                                                                          where tipos_afast.i_tipos_afast = afast.i_tipos_afast
                                                                            and tipos_afast.classif = 9)), date('2999-12-31')))

       union 
        select entidade=f.i_entidades,
               funcionario = f.i_funcionarios,
               dataAlteracao = hc.dt_alteracoes ,
               origemHistorico = 'CARGO'
          from bethadba.funcionarios f 
          join bethadba.hist_cargos hc
            on (f.i_entidades = hc.i_entidades
           and f.i_funcionarios = hc.i_funcionarios
           and hc.dt_alteracoes <= isnull((select first afast.dt_afastamento
                                             from bethadba.afastamentos afast
                                            where afast.i_entidades = f.i_entidades
                                              and afast.i_funcionarios = f.i_funcionarios
                                              and afast.i_tipos_afast = (select tipos_afast.i_tipos_afast
                                                                           from bethadba.tipos_afast 
                                                                          where tipos_afast.i_tipos_afast = afast.i_tipos_afast
                                                                            and tipos_afast.classif = 9)), date('2999-12-31')))
         where not exists( select distinct 1
                             from bethadba.hist_funcionarios hf 
                            where hf.i_entidades = hc.i_entidades
                              and hf.i_funcionarios = hc.i_funcionarios
                              and hf.dt_alteracoes = hc.dt_alteracoes)
       union 
        select entidade = f.i_entidades,
               funcionario = f.i_funcionarios,
               dataAlteracao = hs.dt_alteracoes,
               origemHistorico = 'SALARIO' 
          from bethadba.funcionarios f 
          join bethadba.hist_salariais hs
            on (f.i_entidades = hs.i_entidades
           and f.i_funcionarios = hs.i_funcionarios
           and hs.dt_alteracoes <= isnull((select first afast.dt_afastamento
                                             from bethadba.afastamentos afast
                                            where afast.i_entidades = f.i_entidades
                                              and afast.i_funcionarios = f.i_funcionarios
                                              and afast.i_tipos_afast = (select tipos_afast.i_tipos_afast
                                                                           from bethadba.tipos_afast 
                                                                          where tipos_afast.i_tipos_afast = afast.i_tipos_afast
                                                                            and tipos_afast.classif = 9)), date('2999-12-31')))
         where not exists (select distinct 1
                             from bethadba.hist_funcionarios hf 
                            where hf.i_entidades = hs.i_entidades
                              and hf.i_funcionarios= hs.i_funcionarios
                              and hf.dt_alteracoes = hs.dt_alteracoes) 
                              and not exists(select distinct 1
                                               from bethadba.hist_cargos hc
                                              where hs.i_entidades = hc.i_entidades
                                                and hs.i_funcionarios= hc.i_funcionarios
                                                and hs.dt_alteracoes = hc.dt_alteracoes)
         order by dataAlteracao) as tabAlt,
         bethadba.pessoas
    left outer join bethadba.pessoas_fisicas
      on (pessoas.i_pessoas = pessoas_fisicas.i_pessoas),
         bethadba.cargos,
         bethadba.tipos_cargos,
         bethadba.cargos_compl,
         bethadba.vinculos
   where funcionarios.i_entidades = tabAlt.entidade
     and funcionarios.i_funcionarios = tabAlt.funcionario
     and tipos_cargos.i_tipos_cargos = cargos.i_tipos_cargos
     and cargos.i_cargos = hc.i_cargos
     and cargos.i_entidades = hc.i_entidades
     and funcionarios.i_funcionarios = hf.i_funcionarios
     and funcionarios.i_entidades = hf.i_entidades
     and pessoas.i_pessoas = funcionarios.i_pessoas
     and hf.i_funcionarios = hc.i_funcionarios
     and hf.i_entidades = hc.i_entidades
     and hs.i_funcionarios = hc.i_funcionarios
     and hs.i_entidades = hc.i_entidades
     and hs.dt_alteracoes = bethadba.dbf_GetDataHisSal(hs.i_entidades, hs.i_funcionarios, dataAlteracao)
     and hf.dt_alteracoes = bethadba.dbf_GetDataHisFun(hf.i_entidades, hf.i_funcionarios, dataAlteracao)
     and hc.dt_alteracoes = bethadba.dbf_GetDataHisCar(hc.i_entidades, hc.i_funcionarios, dataAlteracao)
     and hf.i_vinculos = vinculos.i_vinculos
     and cargos_compl.i_entidades=cargos.i_entidades
     and cargos_compl.i_cargos = cargos.i_cargos
     and funcionarios.tipo_func = 'F'
     and vinculos.categoria_esocial <> 901
     and hs.i_niveis is not null
     and exists (select first 1
                   from bethadba.hist_cargos_compl hcc
                  where hcc.i_entidades = chave_dsk1
                    and hcc.i_cargos = hc.i_cargos
                    and date(dataAlteracao) between date(hcc.dt_alteracoes) and isnull(hcc.dt_final,'2999-12-31'))
     and not exists (select first 1
                       from bethadba.hist_cargos_compl hcc
                      where hcc.i_entidades = chave_dsk1
                        and hcc.i_cargos = hc.i_cargos
                        and hcc.i_niveis = hs.i_niveis
                        and date(dataAlteracao) between date(hcc.dt_alteracoes) and isnull(hcc.dt_final,'2999-12-31'));

commit;


-- Insere os dados corrigidos na tabela de histórico de cargos complementares
-- Ignora se já existir

insert into bethadba.hist_cargos_compl(i_entidades,i_cargos,dt_alteracoes,i_niveis) on existing skip
select i_entidades,
       i_cargos,
       dataAlteracao,
       i_niveis
  from cnv_ajusta_198;

commit;

-- FOLHA - Validação - 199

-- Cria tabela temporária para armazenar os ajustes
create table cnv_ajusta_199
(i_entidades integer, menor_dt_alteracao_salario timestamp, nivel_salario integer, i_cargos integer, dt_alteracao_cargo timestamp, nivel_cargo integer, seq integer);

commit;

-- Atualiza a tabela cnv_ajusta_199 com os dados necessários para o ajuste
insert into cnv_ajusta_199 (i_entidades,menor_dt_alteracao_salario,nivel_salario,i_cargos,dt_alteracao_cargo,nivel_cargo,seq)
select hs.i_entidades,
       min(hs.dt_alteracoes) as menor_dt_alteracao_salario,
       hs.i_niveis as nivel_salario,
       hc.i_cargos,
       hcc.dt_alteracoes as dt_alteracao_cargo,
       hcc.i_niveis as nivel_cargo,
       row_number() over (partition by hs.i_entidades, hs.i_niveis, hc.i_cargos, hcc.dt_alteracoes, hcc.i_niveis order by hs.dt_alteracoes) as seq
  from bethadba.hist_salariais as hs
  join bethadba.hist_cargos as hc 
    on hs.i_funcionarios = hc.i_funcionarios 
   and hs.i_entidades = hc.i_entidades
  join bethadba.hist_cargos_compl as hcc 
    on hc.i_cargos = hcc.i_cargos 
   and hc.i_entidades = hcc.i_entidades
 where hs.i_niveis is not null
   and hs.dt_alteracoes < hcc.dt_alteracoes
   and hs.i_niveis = hcc.i_niveis
 group by hs.i_entidades, hs.i_niveis, hc.i_cargos, hcc.dt_alteracoes, hcc.i_niveis
 order by hs.i_entidades, hc.i_cargos,  hs.i_niveis;

commit;

-- Atualiza a tabela hist_salariais com a data de alteração do cargo que possui a menor data de alteração de salário
update bethadba.hist_salariais as hs
   set hs.dt_alteracoes = convert(date, cnv.dt_alteracao_cargo)
  from cnv_ajusta_199 as cnv
 where convert(date, cnv.menor_dt_alteracao_salario) = convert(date, cnv.dt_alteracao_cargo)
   and hs.dt_alteracoes = cnv.menor_dt_alteracao_salario
   and hs.i_niveis = cnv.nivel_salario;

commit;

-- limpa a tabela cnv_ajusta_199
delete cnv_ajusta_199;

commit;

-- Atualiza a tabela cnv_ajusta_199 com os dados necessários para o ajuste
insert into cnv_ajusta_199 (i_entidades,menor_dt_alteracao_salario,nivel_salario,i_cargos,dt_alteracao_cargo,nivel_cargo,seq)
select hs.i_entidades,
       min(hs.dt_alteracoes) as menor_dt_alteracao_salario,
       hs.i_niveis as nivel_salario,
       hc.i_cargos,
       hcc.dt_alteracoes as dt_alteracao_cargo,
       hcc.i_niveis as nivel_cargo,
       row_number() over (partition by hs.i_entidades, hs.i_niveis, hc.i_cargos, hcc.dt_alteracoes, hcc.i_niveis order by hs.dt_alteracoes) as seq
  from bethadba.hist_salariais hs
  join bethadba.hist_cargos hc 
    on hs.i_funcionarios = hc.i_funcionarios 
   and hs.i_entidades = hc.i_entidades
  join bethadba.hist_cargos_compl hcc 
    on hc.i_cargos = hcc.i_cargos 
   and hc.i_entidades = hcc.i_entidades
 where hs.i_niveis is not null
   and hs.dt_alteracoes < hcc.dt_alteracoes
   and hs.i_niveis = hcc.i_niveis
 group by hs.i_entidades, hs.i_niveis, hc.i_cargos, hcc.dt_alteracoes, hcc.i_niveis
 order by hs.i_entidades, hc.i_cargos, hs.i_niveis;

commit;

-- Atualiza a tabela hist_cargos_compl com a menor data de alteração de salário
-- Atualiza hist_cargos_compl, incrementando 1 segundo se houver conflito de chave primária
update bethadba.hist_cargos_compl
  set hist_cargos_compl.dt_alteracoes = (
      -- Busca a menor data de alteração de salário, incrementando segundos até não haver conflito
      select dateadd(second, isnull((
        select count(*)
          from bethadba.hist_cargos_compl as hcc2
         where hcc2.i_entidades = cnv_ajusta_199.i_entidades
          and hcc2.i_cargos = cnv_ajusta_199.i_cargos
          and hcc2.i_niveis = cnv_ajusta_199.nivel_cargo
          and hcc2.dt_alteracoes >= convert(date, cnv_ajusta_199.menor_dt_alteracao_salario)
          and hcc2.dt_alteracoes < dateadd(second, 60, convert(date, cnv_ajusta_199.menor_dt_alteracao_salario))
      ), 0), convert(date, cnv_ajusta_199.menor_dt_alteracao_salario))
   )
  from cnv_ajusta_199
 where convert(date, cnv_ajusta_199.menor_dt_alteracao_salario) < convert(date, cnv_ajusta_199.dt_alteracao_cargo)
  and hist_cargos_compl.i_entidades = cnv_ajusta_199.i_entidades
  and hist_cargos_compl.i_cargos = cnv_ajusta_199.i_cargos
  and hist_cargos_compl.i_niveis = cnv_ajusta_199.nivel_cargo
  and hist_cargos_compl.dt_alteracoes = (
      select min(a.dt_alteracoes)
       from bethadba.hist_cargos_compl as a
      where a.i_entidades = bethadba.hist_cargos_compl.i_entidades
        and a.i_cargos = bethadba.hist_cargos_compl.i_cargos
        and a.i_niveis = bethadba.hist_cargos_compl.i_niveis
   );

commit;

-- Atualiza as datas de alteração dos salários com a data de alteração do cargo que possui a menor data de alteração de salário
update bethadba.hist_salariais
   set hist_salariais.dt_alteracoes = dt_alteracao_cargo
  from cnv_ajusta_199
 where convert(date,menor_dt_alteracao_salario) = convert(date, dt_alteracao_cargo)
   and hist_salariais.dt_alteracoes = menor_dt_alteracao_salario
   and hist_salariais.i_niveis = nivel_salario;

commit;

-- limpa a tabela cnv_ajusta_199
delete cnv_ajusta_199;

commit;

-- Atualiza a tabela cnv_ajusta_199 com os dados necessários para o ajuste
insert into cnv_ajusta_199 (i_entidades,menor_dt_alteracao_salario,nivel_salario,i_cargos,dt_alteracao_cargo,nivel_cargo,seq)
select hs.i_entidades,
       min(hs.dt_alteracoes) as menor_dt_alteracao_salario,
       hs.i_niveis as nivel_salario,
       hc.i_cargos,
       hcc.dt_alteracoes as dt_alteracao_cargo,
       hcc.i_niveis as nivel_cargo,
       row_number() over (partition by hs.i_entidades, hs.i_niveis, hc.i_cargos, hcc.dt_alteracoes, hcc.i_niveis order by hs.dt_alteracoes) as seq
  from bethadba.hist_salariais hs
  join bethadba.hist_cargos hc 
    on hs.i_funcionarios = hc.i_funcionarios 
   and hs.i_entidades = hc.i_entidades
  join bethadba.hist_cargos_compl hcc 
    on hc.i_cargos = hcc.i_cargos 
   and hc.i_entidades = hcc.i_entidades
 where hs.i_niveis is not null
   and hs.dt_alteracoes < hcc.dt_alteracoes
   and hs.i_niveis = hcc.i_niveis
 group by hs.i_entidades, hs.i_niveis, hc.i_cargos, hcc.dt_alteracoes, hcc.i_niveis
 order by hs.i_entidades, hc.i_cargos, hs.i_niveis;

commit;

-- Atualiza as datas de alteração dos cargos complementares com a menor data de alteração de salário
update bethadba.hist_cargos_compl
   set hist_cargos_compl.dt_alteracoes = menor_dt_alteracao_salario
  from cnv_ajusta_199
 where convert(date,menor_dt_alteracao_salario) < convert(date, dt_alteracao_cargo)
   and hist_cargos_compl.i_entidades = cnv_ajusta_199.i_entidades
   and hist_cargos_compl.i_cargos = cnv_ajusta_199.i_cargos
   and hist_cargos_compl.i_niveis = cnv_ajusta_199.nivel_cargo
   and hist_cargos_compl.dt_alteracoes = (select min(a.dt_alteracoes)
              from bethadba.hist_cargos_compl as a
             where a.i_entidades = bethadba.hist_cargos_compl.i_entidades
               and a.i_cargos = bethadba.hist_cargos_compl.i_cargos
               and a.i_niveis = bethadba.hist_cargos_compl.i_niveis);

commit;

-- Atualiza as datas de alteração dos salários com a data de alteração do cargo que possui a menor data de alteração de salário
update bethadba.hist_salariais
   set hist_salariais.dt_alteracoes = dt_alteracao_cargo
  from cnv_ajusta_199
 where convert(date,menor_dt_alteracao_salario) = convert(date, dt_alteracao_cargo)
   and hist_salariais.dt_alteracoes = menor_dt_alteracao_salario
   and hist_salariais.i_niveis = nivel_salario;

commit;

-- Atualiza as datas de alteração dos níveis salariais
update bethadba.hist_niveis
   set dt_alteracoes = (select min(a.dt_alteracoes) - 1
                          from bethadba.hist_cargos_compl as a
                         where a.i_entidades = hist_niveis.i_entidades
                           and a.i_niveis =hist_niveis.i_niveis)
 where dt_alteracoes = (select min(c.dt_alteracoes)
                          from bethadba.hist_niveis as c
                         where c.i_entidades = hist_niveis.i_entidades
                           and c.i_niveis = hist_niveis.i_niveis)
   and (select min(a.dt_alteracoes) + 1
          from bethadba.hist_cargos_compl as a
         where a.i_entidades =hist_niveis.i_entidades
           and a.i_niveis =hist_niveis.i_niveis) < hist_niveis.dt_alteracoes;

commit;

-- Atualiza as datas de alteração das classificações de níveis
update bethadba.hist_clas_niveis
   set dt_alteracoes = (select min(a.dt_alteracoes)
                          from bethadba.hist_niveis as a
                         where a.i_entidades =hist_clas_niveis.i_entidades
                           and a.i_niveis =hist_clas_niveis.i_niveis)
 where dt_alteracoes = (select min(c.dt_alteracoes)
                          from bethadba.hist_clas_niveis as c
                         where c.i_entidades = hist_clas_niveis.i_entidades
                           and c.i_niveis = hist_clas_niveis.i_niveis)
   and (select min(a.dt_alteracoes)
          from bethadba.hist_niveis as a
         where a.i_entidades = hist_clas_niveis.i_entidades
           and a.i_niveis =hist_clas_niveis.i_niveis) < hist_clas_niveis.dt_alteracoes;

commit;

commit;

-- FOLHA - Validação - 20

-- Atualiza os vinculos empregaticios repetidos para evitar duplicidade, adicionando o i_vinculos ao nome do vinculo

update bethadba.vinculos
   set vinculos.descricao = vinculos.i_vinculos || vinculos.descricao
 where i_vinculos in (2, 12);

commit;

-- FOLHA - Validação - 21

-- Atualiza a categoria eSocial nulo para um valor padrão (exemplo: '01') para evitar problemas de integridade referencial

update bethadba.motivos_resc set categoria_esocial = '01' where i_motivos_resc = 1;
update bethadba.motivos_resc set categoria_esocial = '02' where i_motivos_resc = 2;
update bethadba.motivos_resc set categoria_esocial = '04' where i_motivos_resc = 3;
update bethadba.motivos_resc set categoria_esocial = '07' where i_motivos_resc = 4;
update bethadba.motivos_resc set categoria_esocial = '12' where i_motivos_resc = 6;
update bethadba.motivos_resc set categoria_esocial = '10' where i_motivos_resc = 8;
update bethadba.motivos_resc set categoria_esocial = '24' where i_motivos_resc = 9;
update bethadba.motivos_resc set categoria_esocial = '03' where i_motivos_resc = 10;
update bethadba.motivos_resc set categoria_esocial = '04' where i_motivos_resc = 11;
update bethadba.motivos_resc set categoria_esocial = '06' where i_motivos_resc = 12;
update bethadba.motivos_resc set categoria_esocial = '10' where i_motivos_resc = 13;
update bethadba.motivos_resc set categoria_esocial = '10' where i_motivos_resc = 14;
update bethadba.motivos_resc set categoria_esocial = '06' where i_motivos_resc = 15;
update bethadba.motivos_resc set categoria_esocial = '40' where i_motivos_resc = 16;
update bethadba.motivos_resc set categoria_esocial = '40' where i_motivos_resc = 17;

commit;

-- FOLHA - Validação - 30

-- Alterar a data do campo hs.dt_alteracoes para um minuto após a última alteração dentro do mesmo mês da data do campo r.dt_rescisao sem gerar duplicidade

-- Cria a tabela temporária de minutos
create local temporary table minutos (n int);
insert into minutos
select row_num - 1
from sa_rowgenerator(1, 1440);

-- Atualiza a tabela de histórico salarial
update bethadba.hist_salariais hs
   set dt_alteracoes = (
      select min(dt_nova)
        from (
            select dateadd(minute, m.n, STRING(r.dt_rescisao, ' ', substring(hs.dt_alteracoes, 12, 8))) as dt_nova
              from bethadba.rescisoes r2
             cross join minutos m
             where r2.i_funcionarios = hs.i_funcionarios
               and r2.i_entidades = hs.i_entidades
               and r2.dt_rescisao = r.dt_rescisao
               and not exists (
                   select 1
                     from bethadba.hist_salariais hsx
                    where hsx.i_funcionarios = hs.i_funcionarios
                      and hsx.i_entidades = hs.i_entidades
                      and hsx.dt_alteracoes = dateadd(minute, m.n, STRING(r.dt_rescisao, ' ', substring(hs.dt_alteracoes, 12, 8)))
               )
        ) as possiveis
    )
  from bethadba.rescisoes r
 where hs.i_entidades = r.i_entidades
   and hs.i_funcionarios = r.i_funcionarios
   and dt_alteracoes > STRING((select max(s.dt_rescisao) 
                      from bethadba.rescisoes s 
                      join bethadba.motivos_resc mr
                        on (s.i_motivos_resc = mr.i_motivos_resc)
                      where s.i_funcionarios = r.i_funcionarios 
                        and s.i_entidades = r.i_entidades
                        and s.dt_canc_resc is null
                        and s.dt_reintegracao is null
                        and mr.dispensados != 3), ' 23:59:59');

drop table minutos;

commit;

-- FOLHA - Validação - 52

-- Atualiza os nomes dos grupos funcionais repetidos, adicionando o identificador da entidade ao final do nome

update bethadba.grupos g
   set nome = i_grupos || ' - ' || nome
 where nome in (select nome
                  from bethadba.grupos
                 group by nome
                having count(nome) > 1);

commit;

-- FOLHA - Validação - 82

-- Atualiza o CNPJ inválido para um CNPJ válido fictício

update bethadba.pessoas_juridicas
   set cnpj = right('000000000000' || cast((row_number() over (order by i_pessoas)) as varchar(12)), 12) || '91'
 where cnpj is not null
   and bethadba.dbf_valida_cgc_cpf(cnpj, null, 'J') = 0;

commit;

-- FOLHA - Validação - 91

-- Atualiza o campo principal para 'N' para todos os locais de trabalho dos funcionarios e depois atualiza para 'S' apenas o local de trabalho com a maior data de início

update bethadba.locais_mov
   set principal = 'N';

update bethadba.locais_mov
   set principal = 'S'
 where dt_inicial = (select max(lm.dt_inicial)
                       from bethadba.locais_mov as lm
                      where lm.i_funcionarios = i_funcionarios
                        and lm.i_entidades = i_entidades);

commit;

-- FOLHA - Validação - 96

-- Insere um responsável legal para o beneficiário menor de idade

insert into bethadba.beneficiarios_repres_legal (i_entidades, i_funcionarios, i_pessoas, tipo, dt_inicial, dt_final)
values (2, 292, 2835, 5, 2020-09-01, null);

commit;

-- PONTO - Validação - 2

-- Atualiza as descrições repetidas para que sejam únicas

update bethadba.turmas
   set descricao = i_turmas || ' - ' || descricao
 where exists (select 1 
                 from bethadba.turmas t2
                where t1.descricao = t2.descricao
                  and t1.i_turmas <> t2.i_turmas);

commit;

-- RH - Validação - 18

-- Inserir os dados na tabela planos_saude_tabelas_faixas

INSERT INTO bethadba.planos_saude_tabelas_faixas (i_pessoas,i_entidades,i_planos_saude,i_tabelas,i_sequencial,idade_ini,idade_fin,vlr_plano)
VALUES (1, 1, 1, 1, 1, 0, 17, 100.00);

commit;

-- RH - Validação - 19

-- Atualizar os registros na tabela planos_saude_tabelas_faixas para preencher idade_ini e idade_fin com valores padrão, se necessário.

update bethadba.planos_saude_tabelas_faixas
   set idade_ini = 0, idade_fin = 100
 where idade_ini is null
    or idade_fin is null;

commit;

call bethadba.pg_setoption('fire_triggers','on');
call bethadba.pg_setoption('wait_for_COMMIT','off');
commit;