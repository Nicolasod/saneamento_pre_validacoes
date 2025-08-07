-- VALIDAÇÃO 198
-- Há níveis salariais não presente nos historicos de cargos

select distinct funcionarios.i_entidades as chave_dsk1,
       funcionarios.i_funcionarios as chave_dsk2,
	     dataAlteracao = tabAlt.dataAlteracao,
	     hs.i_niveis,
	     hc.i_cargos
  from bethadba.funcionarios,
       bethadba.hist_cargos as hc,
       bethadba.concursos,
       bethadba.hist_funcionarios as hf,
       bethadba.hist_salariais as hs,
       bethadba.niveis,
       bethadba.planos_salariais,
       bethadba.pessoas,
       bethadba.pessoas_fisicas,
       bethadba.cargos,
       bethadba.tipos_cargos,
       bethadba.cargos_compl,
       bethadba.vinculos,
       (select entidade = f.i_entidades,
               funcionario = f.i_funcionarios,
	             dataAlteracao = hf.dt_alteracoes,
    	         origemHistorico = 'FUNCIONARIO'
          from bethadba.funcionarios as f,
               bethadba.hist_funcionarios as hf
         where f.i_entidades = hf.i_entidades
           and f.i_funcionarios = hf.i_funcionarios
           and hf.dt_alteracoes <= isnull((select first afast.dt_afastamento
                                             from bethadba.afastamentos as afast
                                            where afast.i_entidades = f.i_entidades
                                              and afast.i_funcionarios = f.i_funcionarios
                                              and afast.i_tipos_afast = (select tipos_afast.i_tipos_afast
                                                                           from bethadba.tipos_afast 
                                                                          where tipos_afast.i_tipos_afast = afast.i_tipos_afast
                                                                            and tipos_afast.classif = 9)), date('2999-12-31'))
                        
		   union
         
        select entidade = f.i_entidades,
               funcionario = f.i_funcionarios,
               dataAlteracao = hc.dt_alteracoes,
               origemHistorico = 'CARGO'
          from bethadba.funcionarios as f,
               bethadba.hist_cargos as hc
         where f.i_entidades = hc.i_entidades
           and f.i_funcionarios = hc.i_funcionarios
           and hc.dt_alteracoes <= isnull((select first afast.dt_afastamento
                                             from bethadba.afastamentos as afast	
                                            where afast.i_entidades = f.i_entidades
                                              and afast.i_funcionarios = f.i_funcionarios
                                              and afast.i_tipos_afast = (select tipos_afast.i_tipos_afast
                                                                           from bethadba.tipos_afast 
                                                                          where tipos_afast.i_tipos_afast = afast.i_tipos_afast
                                                                            and tipos_afast.classif = 9)), date('2999-12-31'))
           and not exists (select distinct 1
                             from bethadba.hist_funcionarios as hf
                            where hf.i_entidades = hc.i_entidades
                              and hf.i_funcionarios = hc.i_funcionarios
                              and hf.dt_alteracoes = hc.dt_alteracoes)
                              
		   union
		 
        select entidade = f.i_entidades,
               funcionario = f.i_funcionarios,
               dataAlteracao = hs.dt_alteracoes,
               origemHistorico = 'SALARIO' 
          from bethadba.funcionarios as f, 
               bethadba.hist_salariais as hs
         where f.i_entidades = hs.i_entidades
           and f.i_funcionarios = hs.i_funcionarios
           and hs.dt_alteracoes <= isnull((select first afast.dt_afastamento
                                             from bethadba.afastamentos as afast
                                            where afast.i_entidades = f.i_entidades
                                              and afast.i_funcionarios = f.i_funcionarios
                                              and afast.i_tipos_afast = (select tipos_afast.i_tipos_afast
                                                                           from bethadba.tipos_afast 
                                                                          where tipos_afast.i_tipos_afast = afast.i_tipos_afast
                                                                            and tipos_afast.classif = 9)),date('2999-12-31'))
           and not exists (select distinct 1
         				             from bethadba.hist_funcionarios as hf 
                            where hf.i_entidades = hs.i_entidades
                              and hf.i_funcionarios = hs.i_funcionarios
                              and hf.dt_alteracoes = hs.dt_alteracoes)
           and not exists (select distinct 1
           					         from bethadba.hist_cargos as hc
                            where hs.i_entidades = hc.i_entidades
                              and hs.i_funcionarios = hc.i_funcionarios
                              and hs.dt_alteracoes = hc.dt_alteracoes)
         order by dataAlteracao) as tabAlt
 where funcionarios.i_entidades = tabAlt.entidade
   and funcionarios.i_funcionarios = tabAlt.funcionario
   and hc.i_entidades = concursos.i_entidades
   and hc.i_concursos = concursos.i_concursos
   and niveis.i_entidades = hs.i_entidades
   and niveis.i_niveis = hs.i_niveis
   and pessoas.i_pessoas = pessoas_fisicas.i_pessoas
   and planos_salariais.i_planos_salariais = niveis.i_planos_salariais
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
   and cargos_compl.i_entidades = cargos.i_entidades
   and cargos_compl.i_cargos = cargos.i_cargos
   and funcionarios.tipo_func = 'F'
   and vinculos.categoria_esocial <> 901
   and hs.i_niveis is not null
   and exists (select first 1
   			 	       from bethadba.hist_cargos_compl as hcc
   			 	      where hcc.i_entidades = chave_dsk1
   			 	        and hcc.i_cargos = hc.i_cargos
                  and date(dataAlteracao) between date(hcc.dt_alteracoes)
                  and isnull(hcc.dt_final,'2999-12-31'))
   and not exists (select first 1
   					         from bethadba.hist_cargos_compl as hcc
   					        where hcc.i_entidades = chave_dsk1
   					          and hcc.i_cargos = hc.i_cargos
   					          and hcc.i_niveis = hs.i_niveis
                      and date(dataAlteracao) between date(hcc.dt_alteracoes)
        			        and isnull(hcc.dt_final,'2999-12-31'));


-- CORREÇÃO
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