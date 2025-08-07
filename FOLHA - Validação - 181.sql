-- VALIDAÇÃO 181
-- Caracteristicas de matrículas não presentes na tabela de caracteristicas CFG

select distinct i_caracteristicas
  from bethadba.funcionarios_prop_adic
 where i_caracteristicas not in (select i_caracteristicas
   								                 from bethadba.funcionarios_caract_cfg fcc);


-- CORREÇÃO
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