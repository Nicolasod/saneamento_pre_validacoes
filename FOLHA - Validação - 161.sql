-- VALIDAÇÃO 161
-- Organograma não cadastrado no controle de vagas do cargo

select distinct hf.i_entidades,
       hf.i_funcionarios,
       hf.i_config_organ,
       hf.i_organogramas,              
       hc.i_cargos,
       num_sintetico = (select no3.tot_digitos
                          from bethadba.niveis_organ no3
                         where no3.i_config_organ = hf.i_config_organ
                           and no3.i_niveis_organ = organogramas.nivel  - 1),
       sintetico = left(hf.i_organogramas, num_sintetico) + repeat('0', (select no3.num_digitos
                                                                           from bethadba.niveis_organ no3
                                                                          where no3.i_config_organ = hf.i_config_organ
                                                                            and no3.i_niveis_organ = organogramas.nivel))
  from bethadba.funcionarios,
       bethadba.hist_cargos hc,
       bethadba.hist_funcionarios hf,
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
        select entidade = f.i_entidades,
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
         where not exists (select distinct 1
                             from bethadba.hist_funcionarios hf
                            where hf.i_entidades = hc.i_entidades
                              and hf.i_funcionarios = hc.i_funcionarios
                              and hf.dt_alteracoes = hc.dt_alteracoes)
         order by dataAlteracao) as tabAlt,
       bethadba.cargos,
       bethadba.tipos_cargos,
       bethadba.organogramas        
 where funcionarios.i_entidades = tabAlt.entidade
   and funcionarios.i_funcionarios = tabAlt.funcionario
   and cargos.i_cargos = hc.i_cargos
   and cargos.i_entidades = hc.i_entidades
   and funcionarios.i_funcionarios = hf.i_funcionarios
   and funcionarios.i_entidades = hf.i_entidades
   and hf.i_funcionarios = hc.i_funcionarios
   and hf.i_entidades = hc.i_entidades
   and hf.i_config_organ = organogramas.i_config_organ
   and hf.i_organogramas = organogramas.i_organogramas
   and hf.dt_alteracoes = bethadba.dbf_GetDataHisFun(hf.i_entidades, hf.i_funcionarios, dataAlteracao)
   and hc.dt_alteracoes = bethadba.dbf_GetDataHisCar(hc.i_entidades, hc.i_funcionarios, dataAlteracao)
   and funcionarios.tipo_func = 'F'
   and exists (select 1
                 from bethadba.cargos_organogramas co
                where co.i_entidades = hf.i_entidades
                  and co.i_cargos = hc.i_cargos)
   and not exists (select 1
                     from bethadba.cargos_organogramas co
                    where co.i_entidades = hf.i_entidades
                      and co.i_cargos = hc.i_cargos
                      and co.i_organogramas = sintetico);


-- CORREÇÃO
update bethadba.cargos_organogramas
   set i_organogramas = sintetico
  from (select hf.i_entidades,
               hf.i_funcionarios,
               hf.i_config_organ,
               hf.i_organogramas,              
               hc.i_cargos,
               num_sintetico = (select no3.tot_digitos
                                  from bethadba.niveis_organ no3
                                 where no3.i_config_organ = hf.i_config_organ
                                   and no3.i_niveis_organ = organogramas.nivel  - 1),
               sintetico = left(hf.i_organogramas, num_sintetico) + repeat('0', (select no3.num_digitos
                                                                                   from bethadba.niveis_organ no3
                                                                                  where no3.i_config_organ = hf.i_config_organ
                                                                                    and no3.i_niveis_organ = organogramas.nivel))
          from bethadba.funcionarios,
               bethadba.hist_cargos hc,
               bethadba.hist_funcionarios hf,
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
                select entidade = f.i_entidades,
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
                 where not exists (select distinct 1
                                     from bethadba.hist_funcionarios hf
                                    where hf.i_entidades = hc.i_entidades
                                      and hf.i_funcionarios = hc.i_funcionarios
                                      and hf.dt_alteracoes = hc.dt_alteracoes)
                 order by dataAlteracao) as tabAlt,
               bethadba.cargos,
               bethadba.tipos_cargos,
               bethadba.organogramas
         where funcionarios.i_entidades = tabAlt.entidade
           and funcionarios.i_funcionarios = tabAlt.funcionario
           and cargos.i_cargos = hc.i_cargos
           and cargos.i_entidades = hc.i_entidades
           and funcionarios.i_funcionarios = hf.i_funcionarios
           and funcionarios.i_entidades = hf.i_entidades
           and hf.i_funcionarios = hc.i_funcionarios
           and hf.i_entidades = hc.i_entidades
           and hf.i_config_organ = organogramas.i_config_organ
           and hf.i_organogramas = organogramas.i_organogramas
           and hf.dt_alteracoes = bethadba.dbf_GetDataHisFun(hf.i_entidades, hf.i_funcionarios, dataAlteracao)
           and hc.dt_alteracoes = bethadba.dbf_GetDataHisCar(hc.i_entidades, hc.i_funcionarios, dataAlteracao)
           and funcionarios.tipo_func = 'F'
           and exists (select 1
                         from bethadba.cargos_organogramas co
                        where co.i_entidades = hf.i_entidades
                          and co.i_cargos = hc.i_cargos)
           and not exists (select 1
                             from bethadba.cargos_organogramas co
                            where co.i_entidades = hf.i_entidades
                              and co.i_cargos = hc.i_cargos
                              and co.i_organogramas = sintetico)) as sintetico
 where cargos_organogramas.i_entidades = sintetico.i_entidades
   and cargos_organogramas.i_cargos = sintetico.i_cargos
   and cargos_organogramas.i_organogramas = sintetico.i_organogramas
   and cargos_organogramas.i_config_organ = sintetico.i_config_organ;