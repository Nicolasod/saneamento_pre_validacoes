-- VALIDAÇÃO 143
-- ordem duplicada de campos adicionais

select nome,
  ordem,
  list(codigo),
  count(ordem) as quantidade
  from (select 'cargos' as nome, ordem, i_caracteristicas as codigo
   from bethadba.cargos_caract_cfg 
    union all    
    select 'eventos' as nome, ordem, i_caracteristicas as codigo
   from bethadba.eventos_caract_cfg
    union all    
    select 'tipos_cargos' as nome, ordem, i_caracteristicas as codigo
   from bethadba.tipos_cargos_caract_cfg
    union all    
    select 'tipos_afast' as nome, ordem, i_caracteristicas as codigo
   from bethadba.tipos_afast_caract_cfg
    union all    
    select 'atos' as nome, ordem, i_caracteristicas as codigo
   from bethadba.atos_caract_cfg
    union all    
    select 'areas_atuacao' as nome, ordem, i_caracteristicas as codigo
   from bethadba.areas_atuacao_caract_cfg
    union all    
    select 'empresas' as nome, ordem, i_caracteristicas as codigo
   from bethadba.empresas_ant_caract_cfg    
    union all    
    select 'niveis' as nome, ordem, i_caracteristicas as codigo
   from bethadba.niveis_caract_cfg        
    union all    
    select 'organogramas' as nome, ordem, i_caracteristicas as codigo
   from bethadba.organogramas_caract_cfg
    union all    
    select 'funcionario' as nome, ordem, i_caracteristicas as codigo
   from bethadba.funcionarios_caract_cfg fcc
    union all    
    select 'hist_cargos' as nome, ordem, i_caracteristicas as codigo
   from bethadba.hist_cargos_caract_cfg    
    union all    
    select 'pessoas' as nome, ordem, i_caracteristicas as codigo
   from bethadba.pessoas_caract_cfg) as tab
 group by nome, ordem
having quantidade > 1;


-- CORREÇÃO
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