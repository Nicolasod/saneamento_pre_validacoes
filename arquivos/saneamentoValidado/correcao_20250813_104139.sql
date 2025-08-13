call bethadba.dbp_conn_gera (1, year(today()), 300, 0);
call bethadba.pg_setoption('fire_triggers','off');
call bethadba.pg_setoption('wait_for_COMMIT','on');
commit;

-- FOLHA - Validação - 125

-- Atualiza o responsável para a configuração Rais caso não tenha responsável cadastrado

update bethadba.parametros_rel
   set nome_resp = 'RAIS'
 where i_parametros_rel = 2
   and nome_resp is null;

commit;

-- FOLHA - Validação - 139

-- Atualiza o dt_aquis_fin do período A para um dia antes do dt_aquis_ini do período B

update bethadba.periodos a
   set a.dt_aquis_fin = dateadd(day, -1, b.dt_aquis_ini)
  from bethadba.periodos b
 where a.i_entidades = b.i_entidades
   and a.i_funcionarios = b.i_funcionarios
   and (a.dt_aquis_ini between b.dt_aquis_ini and b.dt_aquis_fin or a.dt_aquis_fin between b.dt_aquis_ini and b.dt_aquis_fin)
   and a.i_periodos <> b.i_periodos
   and not exists (select 1
                     from bethadba.periodos_ferias pf
                    where a.i_entidades=pf.i_entidades
                      and a.i_funcionarios=pf.i_funcionarios
                      and a.i_periodos=pf.i_periodos
                      and pf.tipo in (5,7))
   and not exists (select 1
                     from bethadba.periodos_ferias pf
                    where b.i_entidades=pf.i_entidades
                      and b.i_funcionarios=pf.i_funcionarios
                      and b.i_periodos=pf.i_periodos
                      and pf.tipo in (5,7));

commit;

-- FOLHA - Validação - 140

-- Ajuste da data de fim do periodo aquisitivo de ferias para o dia anterior ao inicio do proximo periodo aquisitivo

begin
  declare w_entidade integer;
  declare w_funcionario integer;
  declare w_periodo integer;
  declare w_new_data_aquis_fim timestamp;

  llloop: for ll as cursor1 dynamic scroll cursor for
	select a.i_entidades,
    	   a.i_funcionarios,
	       a.i_periodos,
    	   a.dt_aquis_ini as dataInicioA,
	       a.dt_aquis_fin as dataFimA,
    	   b.dt_aquis_ini as dataInicioB,
	       b.dt_aquis_fin as dataFimB,
    	   canceladoA = if exists (select 1
        	                         from bethadba.periodos_ferias as pf
            	                    where a.i_entidades = pf.i_entidades
                	                  and a.i_funcionarios = pf.i_funcionarios
                    	              and a.i_periodos = pf.i_periodos
                        	          and pf.tipo in (5,7)) then 'true' else 'false' endif,
	       canceladoB = if exists (select 1
    	                             from bethadba.periodos_ferias as pf
        	                        where b.i_entidades = pf.i_entidades
            	                      and b.i_funcionarios = pf.i_funcionarios
                	                  and b.i_periodos = pf.i_periodos
                    	              and pf.tipo in (5,7)) then 'true' else 'false' endif,
	       diferencaPeriodo = b.i_periodos - a.i_periodos,
    	   diferenca = DATEDIFF(day, a.dt_aquis_fin , b.dt_aquis_ini)
	  from bethadba.periodos as a,
	  	   bethadba.periodos as b
	 where a.i_periodos < b.i_periodos
	   and a.i_entidades = b.i_entidades
	   and a.i_funcionarios = b.i_funcionarios
	   and diferencaPeriodo = 1
	   and diferenca <> 1 
	   and (canceladoA = 'false' and canceladoB = 'false')
	 order by a.i_entidades, a.i_funcionarios, a.i_periodos, a.dt_aquis_ini
  
  do
  
	  set w_entidade = i_entidades;
    set w_funcionario = i_funcionarios;
    set w_periodo = i_periodos;
    set w_new_data_aquis_fim = DATEADD(DAY, -1, dataInicioB);

    update bethadba.periodos as p
       set p.dt_aquis_fin = w_new_data_aquis_fim
     where p.i_entidades = w_entidade
       and p.i_funcionarios = w_funcionario
       and p.i_periodos = w_periodo
  end for;
end;

commit;

-- FOLHA - Validação - 142

-- A correção será feita através de uma atualização da ordem das características, garantindo que cada uma tenha uma ordem única.

-- bethadba.cargos_caract_cfg
with ordenados as (
  select id_cargo_caract_cfg,
         row_number() over (order by ordem, id_cargo_caract_cfg) as nova_ordem
    from bethadba.cargos_caract_cfg
)
update bethadba.cargos_caract_cfg
   set ordem = ordenados.nova_ordem
  from ordenados
 where bethadba.cargos_caract_cfg.id_cargo_caract_cfg = ordenados.id_cargo_caract_cfg;

-- bethadba.eventos_caract_cfg
with ordenados as (
  select id_evento_caract_cfg,
         row_number() over (order by ordem, id_evento_caract_cfg) as nova_ordem
    from bethadba.eventos_caract_cfg
)
update bethadba.eventos_caract_cfg
   set ordem = ordenados.nova_ordem
  from ordenados
 where bethadba.eventos_caract_cfg.id_evento_caract_cfg = ordenados.id_evento_caract_cfg;

-- bethadba.tipos_cargos_caract_cfg
with ordenados as (
  select id_tipo_cargo_caract_cfg,
         row_number() over (order by ordem, id_tipo_cargo_caract_cfg) as nova_ordem
    from bethadba.tipos_cargos_caract_cfg
)
update bethadba.tipos_cargos_caract_cfg
   set ordem = ordenados.nova_ordem
  from ordenados
 where bethadba.tipos_cargos_caract_cfg.id_tipo_cargo_caract_cfg = ordenados.id_tipo_cargo_caract_cfg;

-- bethadba.tipos_afast_caract_cfg
with ordenados as (
  select id_tipo_afast_caract_cfg,
         row_number() over (order by ordem, id_tipo_afast_caract_cfg) as nova_ordem
    from bethadba.tipos_afast_caract_cfg
)
update bethadba.tipos_afast_caract_cfg
   set ordem = ordenados.nova_ordem
  from ordenados
 where bethadba.tipos_afast_caract_cfg.id_tipo_afast_caract_cfg = ordenados.id_tipo_afast_caract_cfg;

-- bethadba.atos_caract_cfg
with ordenados as (
  select id_ato_caract_cfg,
         row_number() over (order by ordem, id_ato_caract_cfg) as nova_ordem
    from bethadba.atos_caract_cfg
)
update bethadba.atos_caract_cfg
   set ordem = ordenados.nova_ordem
  from ordenados
 where bethadba.atos_caract_cfg.id_ato_caract_cfg = ordenados.id_ato_caract_cfg;

-- bethadba.areas_atuacao_caract_cfg
with ordenados as (
  select id_area_atuacao_caract_cfg,
         row_number() over (order by ordem, id_area_atuacao_caract_cfg) as nova_ordem
    from bethadba.areas_atuacao_caract_cfg
)
update bethadba.areas_atuacao_caract_cfg
   set ordem = ordenados.nova_ordem
  from ordenados
 where bethadba.areas_atuacao_caract_cfg.id_area_atuacao_caract_cfg = ordenados.id_area_atuacao_caract_cfg;

-- bethadba.empresas_ant_caract_cfg
with ordenados as (
  select id_empresa_ant_caract_cfg,
         row_number() over (order by ordem, id_empresa_ant_caract_cfg) as nova_ordem
    from bethadba.empresas_ant_caract_cfg
)
update bethadba.empresas_ant_caract_cfg
   set ordem = ordenados.nova_ordem
  from ordenados
 where bethadba.empresas_ant_caract_cfg.id_empresa_ant_caract_cfg = ordenados.id_empresa_ant_caract_cfg;

-- bethadba.niveis_caract_cfg
with ordenados as (
  select id_nivel_caract_cfg,
         row_number() over (order by ordem, id_nivel_caract_cfg) as nova_ordem
    from bethadba.niveis_caract_cfg
)
update bethadba.niveis_caract_cfg
   set ordem = ordenados.nova_ordem
  from ordenados
 where bethadba.niveis_caract_cfg.id_nivel_caract_cfg = ordenados.id_nivel_caract_cfg;

-- bethadba.organogramas_caract_cfg
with ordenados as (
  select id_organograma_caract_cfg,
         row_number() over (order by ordem, id_organograma_caract_cfg) as nova_ordem
    from bethadba.organogramas_caract_cfg
)
update bethadba.organogramas_caract_cfg
   set ordem = ordenados.nova_ordem
  from ordenados
 where bethadba.organogramas_caract_cfg.id_organograma_caract_cfg = ordenados.id_organograma_caract_cfg;

-- bethadba.funcionarios_caract_cfg
with ordenados as (
  select id_funcionario_caract_cfg,
         row_number() over (order by ordem, id_funcionario_caract_cfg) as nova_ordem
    from bethadba.funcionarios_caract_cfg
)
update bethadba.funcionarios_caract_cfg
   set ordem = ordenados.nova_ordem
  from ordenados
 where bethadba.funcionarios_caract_cfg.id_funcionario_caract_cfg = ordenados.id_funcionario_caract_cfg;

-- bethadba.hist_cargos_caract_cfg
with ordenados as (
  select id_hist_cargo_caract_cfg,
         row_number() over (order by ordem, id_hist_cargo_caract_cfg) as nova_ordem
    from bethadba.hist_cargos_caract_cfg
)
update bethadba.hist_cargos_caract_cfg
   set ordem = ordenados.nova_ordem
  from ordenados
 where bethadba.hist_cargos_caract_cfg.id_hist_cargo_caract_cfg = ordenados.id_hist_cargo_caract_cfg;

-- bethadba.pessoas_caract_cfg
with ordenados as (
  select id_pessoa_caract_cfg,
         row_number() over (order by ordem, id_pessoa_caract_cfg) as nova_ordem
    from bethadba.pessoas_caract_cfg
)
update bethadba.pessoas_caract_cfg
   set ordem = ordenados.nova_ordem
  from ordenados
 where bethadba.pessoas_caract_cfg.id_pessoa_caract_cfg = ordenados.id_pessoa_caract_cfg;

commit;

-- FOLHA - Validação - 143

-- A correção será feita através de uma atualização da ordem dos campos adicionais, garantindo que cada um tenha uma ordem única.

-- bethadba.cargos_caract_cfg
with ordenados as (
  select id_cargo_caract_cfg,
         row_number() over (order by ordem, id_cargo_caract_cfg) as nova_ordem
    from bethadba.cargos_caract_cfg
)
update bethadba.cargos_caract_cfg
   set ordem = ordenados.nova_ordem
  from ordenados
 where bethadba.cargos_caract_cfg.id_cargo_caract_cfg = ordenados.id_cargo_caract_cfg;

-- bethadba.eventos_caract_cfg
with ordenados as (
  select id_evento_caract_cfg,
         row_number() over (order by ordem, id_evento_caract_cfg) as nova_ordem
    from bethadba.eventos_caract_cfg
)
update bethadba.eventos_caract_cfg
   set ordem = ordenados.nova_ordem
  from ordenados
 where bethadba.eventos_caract_cfg.id_evento_caract_cfg = ordenados.id_evento_caract_cfg;

-- bethadba.tipos_cargos_caract_cfg
with ordenados as (
  select id_tipo_cargo_caract_cfg,
         row_number() over (order by ordem, id_tipo_cargo_caract_cfg) as nova_ordem
    from bethadba.tipos_cargos_caract_cfg
)
update bethadba.tipos_cargos_caract_cfg
   set ordem = ordenados.nova_ordem
  from ordenados
 where bethadba.tipos_cargos_caract_cfg.id_tipo_cargo_caract_cfg = ordenados.id_tipo_cargo_caract_cfg;

-- bethadba.tipos_afast_caract_cfg
with ordenados as (
  select id_tipo_afast_caract_cfg,
         row_number() over (order by ordem, id_tipo_afast_caract_cfg) as nova_ordem
    from bethadba.tipos_afast_caract_cfg
)
update bethadba.tipos_afast_caract_cfg
   set ordem = ordenados.nova_ordem
  from ordenados
 where bethadba.tipos_afast_caract_cfg.id_tipo_afast_caract_cfg = ordenados.id_tipo_afast_caract_cfg;

-- bethadba.atos_caract_cfg
with ordenados as (
  select id_ato_caract_cfg,
         row_number() over (order by ordem, id_ato_caract_cfg) as nova_ordem
    from bethadba.atos_caract_cfg
)
update bethadba.atos_caract_cfg
   set ordem = ordenados.nova_ordem
  from ordenados
 where bethadba.atos_caract_cfg.id_ato_caract_cfg = ordenados.id_ato_caract_cfg;

-- bethadba.areas_atuacao_caract_cfg
with ordenados as (
  select id_area_atuacao_caract_cfg,
         row_number() over (order by ordem, id_area_atuacao_caract_cfg) as nova_ordem
    from bethadba.areas_atuacao_caract_cfg
)
update bethadba.areas_atuacao_caract_cfg
   set ordem = ordenados.nova_ordem
  from ordenados
 where bethadba.areas_atuacao_caract_cfg.id_area_atuacao_caract_cfg = ordenados.id_area_atuacao_caract_cfg;

-- bethadba.empresas_ant_caract_cfg
with ordenados as (
  select id_empresa_ant_caract_cfg,
         row_number() over (order by ordem, id_empresa_ant_caract_cfg) as nova_ordem
    from bethadba.empresas_ant_caract_cfg
)
update bethadba.empresas_ant_caract_cfg
   set ordem = ordenados.nova_ordem
  from ordenados
 where bethadba.empresas_ant_caract_cfg.id_empresa_ant_caract_cfg = ordenados.id_empresa_ant_caract_cfg;

-- bethadba.niveis_caract_cfg
with ordenados as (
  select id_nivel_caract_cfg,
         row_number() over (order by ordem, id_nivel_caract_cfg) as nova_ordem
    from bethadba.niveis_caract_cfg
)
update bethadba.niveis_caract_cfg
   set ordem = ordenados.nova_ordem
  from ordenados
 where bethadba.niveis_caract_cfg.id_nivel_caract_cfg = ordenados.id_nivel_caract_cfg;

-- bethadba.organogramas_caract_cfg
with ordenados as (
  select id_organograma_caract_cfg,
         row_number() over (order by ordem, id_organograma_caract_cfg) as nova_ordem
    from bethadba.organogramas_caract_cfg
)
update bethadba.organogramas_caract_cfg
   set ordem = ordenados.nova_ordem
  from ordenados
 where bethadba.organogramas_caract_cfg.id_organograma_caract_cfg = ordenados.id_organograma_caract_cfg;

-- bethadba.funcionarios_caract_cfg
with ordenados as (
  select id_funcionario_caract_cfg,
         row_number() over (order by ordem, id_funcionario_caract_cfg) as nova_ordem
    from bethadba.funcionarios_caract_cfg
)
update bethadba.funcionarios_caract_cfg
   set ordem = ordenados.nova_ordem
  from ordenados
 where bethadba.funcionarios_caract_cfg.id_funcionario_caract_cfg = ordenados.id_funcionario_caract_cfg;

-- bethadba.hist_cargos_caract_cfg
with ordenados as (
  select id_hist_cargo_caract_cfg,
         row_number() over (order by ordem, id_hist_cargo_caract_cfg) as nova_ordem
    from bethadba.hist_cargos_caract_cfg
)
update bethadba.hist_cargos_caract_cfg
   set ordem = ordenados.nova_ordem
  from ordenados
 where bethadba.hist_cargos_caract_cfg.id_hist_cargo_caract_cfg = ordenados.id_hist_cargo_caract_cfg;

-- bethadba.pessoas_caract_cfg
with ordenados as (
  select id_pessoa_caract_cfg,
         row_number() over (order by ordem, id_pessoa_caract_cfg) as nova_ordem
    from bethadba.pessoas_caract_cfg
)
update bethadba.pessoas_caract_cfg
   set ordem = ordenados.nova_ordem
  from ordenados
 where bethadba.pessoas_caract_cfg.id_pessoa_caract_cfg = ordenados.id_pessoa_caract_cfg;

commit;

-- FOLHA - Validação - 164

-- Atualizar categoria do eSocial para 701 (Contribuinte Individual) para autônomos

update bethadba.vinculos v
   set v.categoria_esocial = '701'
 where v.i_vinculos in (select hf.i_vinculos
                          from bethadba.funcionarios f 
                          join bethadba.hist_funcionarios hf
                            on f.i_entidades = hf.i_entidades
                           and f.i_funcionarios = hf.i_funcionarios
                         where f.tipo_func = 'A'
                           and f.conselheiro_tutelar = 'N'
                           and v.categoria_esocial not in ('701'));

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

-- FOLHA - Validação - 172

-- Atualizar o afastamento com a data da rescisão se não houver afastamento, criar um novo com a data da rescisão

update bethadba.rescisoes
   set dt_rescisao = a.dt_afastamento
  from bethadba.afastamentos a
  join bethadba.tipos_afast ta
    on a.i_tipos_afast = ta.i_tipos_afast
 where ((ta.classif = 8 and rescisoes.i_motivos_apos is null)
    or (ta.classif = 9 and rescisoes.i_motivos_apos is not null)
    or (ta.classif = 8 and rescisoes.i_motivos_apos is not null))
   and rescisoes.i_entidades = a.i_entidades
   and rescisoes.i_funcionarios = a.i_funcionarios
   and rescisoes.dt_rescisao <> a.dt_afastamento;


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

commit;

-- FOLHA - Validação - 177

-- Atualizar a categoria_esocial do vinculo para 701

update bethadba.vinculos v
   set v.categoria_esocial = '701'
 where v.categoria_esocial not in ('701', '711', '741')
   and exists (select 1 
                 from bethadba.hist_funcionarios hf 
                 join bethadba.funcionarios f
                   on hf.i_entidades = f.i_entidades
                  and hf.i_funcionarios = f.i_funcionarios 
                where hf.i_vinculos = v.i_vinculos
                  and f.tipo_func = 'A' 
                  and f.conselheiro_tutelar = 'N');

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

-- FOLHA - Validação - 194

-- Exclui os registros de parâmetros de relatório que estejam com tipo de inscrição
-- 'J' e sem pessoa jurídica associada ou com tipo de inscrição 'F' e sem pessoa física associada

update bethadba.parametros_rel pr
   set pr.nome_resp = (select nome
   						           from bethadba.pessoas_nomes
   						          where i_pessoas = (select top 1 e.i_pessoas
                                   					 from bethadba.hist_entidades_compl e
					                                  where e.i_entidades = pr.i_entidades
                                              and i_pessoas is not null
                    					              order by i_competencias desc))
 where pr.i_parametros_rel = 2
   and ((pr.tipo_insc = 'J'
   and isnull((select first i_pessoas
                 from bethadba.pessoas
                where SIMILAR(nome, pr.nome_resp) >= 80),0) = 0)
    or (pr.tipo_insc = 'F'
   and isnull((select first i_pessoas
                 from bethadba.pessoas
                where SIMILAR(nome, pr.nome_resp) >= 80),0) = 0));

commit;

-- FOLHA - Validação - 196

-- Atualizar o tipo de vínculo para que não haja divergência de categoria_esocial

update bethadba.vinculos as v
   set tipo_vinculo = (select tipo_vinculo
                         from bethadba.vinculos as v2
                        where v2.categoria_esocial = v.categoria_esocial
                          and i_vinculos = (select min(v3.i_vinculos)
                                              from bethadba.vinculos as v3
                                             where v3.categoria_esocial = v.categoria_esocial))
 where categoria_esocial is not null
   and i_vinculos > (select min(v4.i_vinculos)
                       from bethadba.vinculos as v4
                      where v4.categoria_esocial = v.categoria_esocial);

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
 group by hs.i_entidades, hs.i_niveis, hc.i_cargos, hcc.dt_alteracoes, hcc.i_niveis, hs.dt_alteracoes
 order by hs.i_entidades, hc.i_cargos, hs.i_niveis;

commit;

-- Atualiza a tabela hist_salariais com a data de alteração do cargo que possui a menor data de alteração de salário
update bethadba.hist_salariais as hs
   set hs.dt_alteracoes = dateadd(second, 
        isnull(
            (select count(*)
               from bethadba.hist_salariais hs2
              where hs2.i_entidades = hs.i_entidades
                and hs2.i_funcionarios = hs.i_funcionarios
                and hs2.dt_alteracoes >= convert(date, cnv.dt_alteracao_cargo)
                and hs2.dt_alteracoes < dateadd(second, 60, convert(date, cnv.dt_alteracao_cargo))
            ), 0) 
        + isnull(cnv.seq, 0) - 1, -- incrementa pelo seq para garantir unicidade
        convert(date, cnv.dt_alteracao_cargo))
  from cnv_ajusta_199 as cnv
 where convert(date, cnv.menor_dt_alteracao_salario) = convert(date, cnv.dt_alteracao_cargo)
   and hs.dt_alteracoes = cnv.menor_dt_alteracao_salario
   and hs.i_niveis = cnv.nivel_salario
   and not exists (
        select 1
          from bethadba.hist_salariais hs3
         where hs3.i_entidades = hs.i_entidades
           and hs3.i_funcionarios = hs.i_funcionarios
           and hs3.dt_alteracoes = dateadd(second, 
                isnull(
                    (select count(*)
                       from bethadba.hist_salariais hs2
                      where hs2.i_entidades = hs.i_entidades
                        and hs2.i_funcionarios = hs.i_funcionarios
                        and hs2.dt_alteracoes >= convert(date, cnv.dt_alteracao_cargo)
                        and hs2.dt_alteracoes < dateadd(second, 60, convert(date, cnv.dt_alteracao_cargo))
                    ), 0)
                + isnull(cnv.seq, 0) - 1, -- incrementa pelo seq para garantir unicidade
                convert(date, cnv.dt_alteracao_cargo))
       );

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

-- FOLHA - Validação - 50

-- Atualiza a data final do gozo de férias para ser igual à data inicial mais o saldo de dias se a data inicial for maior que a data final

update bethadba.ferias
   set dt_gozo_fin = dateadd(day, saldo_dias, dt_gozo_ini)
 where dt_gozo_ini > dt_gozo_fin;

commit;

-- FOLHA - Validação - 62

-- Atualiza os cargos que não possuem configuração de férias

update bethadba.cargos_compl 
   set i_config_ferias = 1
 where i_config_ferias is null;

commit;

-- FOLHA - Validação - 68

-- Atualiza a conta bancária dos funcionários com forma de pagamento 'R' (Crédito em conta) para a conta bancária correspondente na tabela pessoas_contas

update bethadba.hist_funcionarios
   set i_pessoas_contas = (select i_pessoas_contas
                             from bethadba.pessoas_contas
                            where i_pessoas = hist_funcionarios.i_pessoas)
 where forma_pagto = 'R'
   and i_pessoas_contas is null;

commit;

-- FOLHA - Validação - 71

-- Atualiza a conta bancária dos funcionários com forma de pagamento 'R' (Crédito em conta) para a conta bancária correspondente na tabela pessoas_contas

update bethadba.hist_funcionarios hf
   set forma_pagto = 'D'
 where forma_pagto = 'R'
   and i_pessoas_contas is null;

commit;

-- FOLHA - Validação - 74

-- Atualiza o tipo de vínculo para 3 (Conselheiro Tutelar) onde o funcionário é conselheiro tutelar e o tipo de vínculo é diferente de 3

update bethadba.vinculos
   set tipo_vinculo = 3
 where i_vinculos in (select vinculos.i_vinculos
                        from bethadba.funcionarios
                        join bethadba.hist_funcionarios
                          on (funcionarios.i_entidades = hist_funcionarios.i_entidades
                         and funcionarios.i_funcionarios = hist_funcionarios.i_funcionarios)
                        join bethadba.vinculos
                          on (hist_funcionarios.i_vinculos = vinculos.i_vinculos)
                       where funcionarios.tipo_func = 'A'
                         and funcionarios.conselheiro_tutelar = 'S'
                         and vinculos.tipo_vinculo <> 3
                         and hist_funcionarios.dt_alteracoes = (select max(dt_alteracoes)
                                                                  from bethadba.hist_funcionarios hf
                                                                 where hf.i_entidades = funcionarios.i_entidades
                                                                   and hf.i_funcionarios = funcionarios.i_funcionarios));

commit;

-- FOLHA - Validação - 75

-- Atualiza o número da apólice de seguro dos estagiários que não possuem número da apólice informado para 0

update bethadba.hist_funcionarios
   set num_apolice_estagio = 0
 where num_apolice_estagio is null 
   and i_funcionarios in (select estagios.i_funcionarios
   					                from bethadba.estagios
          				         where num_apolice is null);

update bethadba.estagios
   set num_apolice = 0
 where num_apolice is null;

commit;

-- FOLHA - Validação - 76

-- Atualiza o agente de integração dos estagiários para uma entidade educacional padrão

begin
  -- Variável para armazenar o novo i_pessoas
  declare @nova_entidade int;

  -- Insere entidade educacional se não existir e captura o novo i_pessoas
  if not exists (select 1 from bethadba.pessoas where nome = 'Entidade Educacional') then
    insert into bethadba.pessoas (i_pessoas,dv,nome,nome_fantasia,tipo_pessoa,ddd,telefone,fax,ddd_cel,celular,inscricao_municipal,email,cod_unificacao,nome_social,considera_nome_social_fly)
    select (select coalesce(max(i_pessoas), 0) + 1 from bethadba.pessoas), null, 'Entidade Educacional', null, 'J', null, null, null, null, null, null, null, null, null, 'N';
    set @nova_entidade = (select max(i_pessoas) from bethadba.pessoas where nome = 'Entidade Educacional');
  else
    set @nova_entidade = (select i_pessoas from bethadba.pessoas where nome = 'Entidade Educacional');
  end if;

  update bethadba.hist_funcionarios
     set i_agente_integracao_estagio = @nova_entidade
   where i_agente_integracao_estagio is null
     and exists (
       select 1
         from bethadba.estagios
        where estagios.i_entidades = hist_funcionarios.i_entidades
          and estagios.i_funcionarios = hist_funcionarios.i_funcionarios
     );
end

commit;

-- FOLHA - Validação - 77

-- Atualiza o supervisor de estágio para o funcionário correspondente, onde o supervisor de estágio é nulo
 
update bethadba.hist_funcionarios 
   set hist_funcionarios.i_supervisor_estagio = (select i_pessoas
                                                   from bethadba.funcionarios
                                                  where hist_funcionarios.i_entidades = funcionarios.i_entidades
                                                    and hist_funcionarios.i_funcionarios = funcionarios.i_funcionarios)
 where bethadba.hist_funcionarios.i_funcionarios in(select hist_funcionarios.i_funcionarios
													  from bethadba.estagios, bethadba.hist_funcionarios
													 where hist_funcionarios.i_entidades = estagios.i_entidades
													   and hist_funcionarios.i_funcionarios = estagios.i_funcionarios
													   and hist_funcionarios.i_supervisor_estagio is null
													   and hist_funcionarios.dt_alteracoes = (select max(dt_alteracoes)
													   											from bethadba.hist_funcionarios hf
												                                               where hf.i_entidades = estagios.i_entidades
                                                												 and hf.i_funcionarios = estagios.i_funcionarios)
													 order by estagios.i_entidades,
															  estagios.i_funcionarios);

commit;

-- FOLHA - Validação - 82

-- Atualiza o CNPJ inválido para um CNPJ válido fictício

update bethadba.pessoas_juridicas
   set cnpj = right('000000000000' || cast((row_number() over (order by i_pessoas)) as varchar(12)), 12) || '91'
 where cnpj is not null
   and bethadba.dbf_valida_cgc_cpf(cnpj, null, 'J') = 0;

commit;

-- FOLHA - Validação - 97

-- Atualiza o campo num_reg para que tenha exatamente 32 caracteres, preenchendo com zeros à esquerda

update bethadba.pessoas_fis_compl
   set num_reg = replicate('0', 32 - length(bethadba.dbf_retira_caracteres_especiais(num_reg))) + bethadba.dbf_retira_caracteres_especiais(num_reg)
 where length(bethadba.dbf_retira_caracteres_especiais(num_reg)) < 32
   and num_reg is not null;

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

-- RH - Validação - 3

-- A correção deve ser feita no cadastro de matrícula, onde não deve ser possível incluir uma licença prêmio com data inicial anterior à data de admissão do funcionário.

update bethadba.licencas_premio_per
   set dt_inicial = funcionarios.dt_admissao
  from bethadba.funcionarios
 where licencas_premio_per.i_entidades = funcionarios.i_entidades
   and licencas_premio_per.i_funcionarios = funcionarios.i_funcionarios
   and licencas_premio_per.dt_inicial < funcionarios.dt_admissao;

commit;

call bethadba.pg_setoption('fire_triggers','on');
call bethadba.pg_setoption('wait_for_COMMIT','off');
commit;