create PROCEDURE desbth.unificacao_atos()

begin
  if not exists (select distinct(t.table_id)
                   from systable t, syscolumn c, sysuserperms u
                  where t.table_id = c.table_id
                    and t.creator = u.user_id
                    and t.table_name = 'unifica_atos'
                    and u.user_name = 'tecbth_rgriodosul')
  then
    create table tecbth_rgriodosul.unifica_atos(
      i_atos integer null,
      ato integer null,
      num_ato char(50) null,
      relacao varchar(200),
      tot integer null);
    commit;
  else
      delete from tecbth_rgriodosul.unifica_atos;
      commit;
  end if;

begin
  declare cur_atos dynamic scroll cursor for
    select i_atos,
           ato,
           num_ato,
           relacao,tot
      from (select a.i_atos,
                   ato,
                   a.num_ato,
                   relacao,tot
              from bethadba.atos a,
                   (select num_ato ,
                           i_tipos_atos,
                           i_natureza_texto_juridico,
                           list(i_atos) as relacao,
                           count () as tot,
                           min(i_atos) as ato
                      from bethadba.atos
                     group by num_ato,i_tipos_atos,i_natureza_texto_juridico
                    having tot> 1) as tab
              where a.num_ato = tab.num_ato
                and a.i_tipos_atos = tab.i_tipos_atos
                and isnull(a.i_natureza_texto_juridico,1) = isnull(tab.i_natureza_texto_juridico,1)) tab_geral
     order by 1;

  declare w_i_atos integer;
  declare w_ato integer;
  declare w_num_ato char(300);
  declare w_relacao char(300);
  declare w_tot integer;

  open cur_atos with hold;
    l_item: loop
      fetch next cur_atos into w_i_atos,w_ato,w_num_ato,w_relacao,w_tot;
        if sqlstate = '02000' then
          leave l_item;
        end if;
      message 'w_i_atos: '|| w_i_atos||' w_ato: '||w_ato||' w_num_ato: '||w_num_ato to client;

      update bethadba.adic_funcs_per set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.afastamentos set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.aposent_pensoes set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.atos_func set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.averbacoes set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.beneficiarios set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.cargos_vinculos set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.comissoes_aval set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.config_organ set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.editais_concursos set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.estagios set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.eventos set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.ferias set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.funcionarios_vinctemp set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.funcoes_func set i_atos_inicio = w_ato where i_atos_inicio = w_i_atos;
      update bethadba.funcoes_func set i_atos_fim = w_ato where i_atos_fim = w_i_atos;
      update bethadba.hist_cargos set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.hist_cargos set i_atos_saida = w_ato where i_atos_saida = w_i_atos;
      update bethadba.hist_cargos_compl set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.hist_niveis set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.hist_salariais set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.indice_beneficio set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.laudos_medicos set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.licencas_premio set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.licencas_premio_disp set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.mov_cargos set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.mov_planos_previd set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.niveis set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.ocorrencias_func set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.rescisoes set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.responsaveis_compl set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.tabelas set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.comissoes_concursos set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.cargos_tipos_diarias set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.contratos set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.contratos_aditivos set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.funcoes set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.motivos set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.transferencias set i_atos_transf = w_ato where i_atos_transf = w_i_atos;
      update bethadba.transferencias set i_atos_devolucao = w_ato where i_atos_devolucao = w_i_atos;
      update bethadba.subfuncoes set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.hist_cargos_cadastro set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.atos_vinculados set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.parcelas_atos set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.mov_areas_atuacao_cargos set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.validar_movto set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.rescisoes_autonomo set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.conv_cloud_tabelas_encargos set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.hist_eventos set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.hist_quadro_cargos set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.cloud_atos set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.cloud_atos_fontes set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.isencoes set i_atos = w_ato where i_atos = w_i_atos;
      update bethadba.desc_sit_divida set i_atos = w_ato where i_atos = w_i_atos;
      commit;

      insert into tecbth_rgriodosul.unifica_atos values (w_i_atos,w_ato,w_num_ato,w_relacao,w_tot);
      commit;

    end loop;
  
    close cur_atos;
  end;

  delete from bethadba.atos where i_atos not in (
  select distinct (i_atos) from (select i_atos from bethadba.adic_funcs_per where i_atos is not null union all
                                select i_atos from bethadba.afastamentos where i_atos is not null union all
                                select i_atos from bethadba.aposent_pensoes where i_atos is not null union all
                                select i_atos from bethadba.atos_func where i_atos is not null union all
                                select i_atos from bethadba.averbacoes where i_atos is not null union all
                                select i_atos from bethadba.beneficiarios where i_atos is not null union all
                                select i_atos from bethadba.cargos_vinculos where i_atos is not null union all
                                select i_atos from bethadba.comissoes_aval where i_atos is not null union all
                                select i_atos from bethadba.config_organ where i_atos is not null union all
                                select i_atos from bethadba.editais_concursos where i_atos is not null union all
                                select i_atos from bethadba.estagios where i_atos is not null union all
                                select i_atos from bethadba.eventos where i_atos is not null union all
                                select i_atos from bethadba.ferias where i_atos is not null union all
                                select i_atos from bethadba.funcionarios_vinctemp where i_atos is not null union all
                                select i_atos_inicio from bethadba.funcoes_func where i_atos_inicio is not null union all
                                select i_atos_fim from bethadba.funcoes_func where i_atos_fim is not null union all
                                select i_atos from bethadba.hist_cargos where i_atos is not null union all
                                select i_atos_saida from bethadba.hist_cargos where i_atos_saida is not null union all
                                select i_atos from bethadba.hist_cargos_compl where i_atos is not null union all
                                select i_atos from bethadba.hist_niveis where i_atos is not null union all
                                select i_atos from bethadba.hist_salariais where i_atos is not null union all
                                select i_atos from bethadba.indice_beneficio where i_atos is not null union all
                                select i_atos from bethadba.laudos_medicos where i_atos is not null union all
                                select i_atos from bethadba.licencas_premio where i_atos is not null union all
                                select i_atos from bethadba.licencas_premio_disp where i_atos is not null union all
                                select i_atos from bethadba.mov_cargos where i_atos is not null union all
                                select i_atos from bethadba.mov_planos_previd where i_atos is not null union all
                                select i_atos from bethadba.niveis where i_atos is not null union all
                                select i_atos from bethadba.ocorrencias_func where i_atos is not null union all
                                select i_atos from bethadba.rescisoes where i_atos is not null union all
                                select i_atos from bethadba.responsaveis_compl where i_atos is not null union all
                                select i_atos from bethadba.tabelas where i_atos is not null union all
                                select i_atos from bethadba.comissoes_concursos where i_atos is not null union all
                                select i_atos from bethadba.cargos_tipos_diarias where i_atos is not null union all
                                select i_atos from bethadba.contratos where i_atos is not null union all
                                select i_atos from bethadba.contratos_aditivos where i_atos is not null union all
                                select i_atos from bethadba.funcoes where i_atos is not null union all
                                select i_atos from bethadba.motivos where i_atos is not null union all
                                select i_atos_transf from bethadba.transferencias where i_atos_transf is not null union all
                                select i_atos_devolucao from bethadba.transferencias  where i_atos_devolucao is not null union all
                                select i_atos from bethadba.subfuncoes where i_atos is not null union all
                                select i_atos from bethadba.hist_cargos_cadastro where i_atos is not null union all
                                select i_atos from bethadba.atos_vinculados where i_atos is not null union all
                                select i_atos from bethadba.parcelas_atos where i_atos is not null union all
                                select i_atos from bethadba.mov_areas_atuacao_cargos where i_atos is not null union all
                                select i_atos from bethadba.validar_movto where i_atos is not null union all
                                select i_atos from bethadba.rescisoes_autonomo where i_atos is not null union all
                                select i_atos from bethadba.conv_cloud_tabelas_encargos where i_atos is not null union all
                                select i_atos from bethadba.hist_eventos where i_atos is not null union all
                                select i_atos from bethadba.hist_quadro_cargos where i_atos is not null union all
                                select i_atos from bethadba.cloud_atos where i_atos is not null union all
                                select i_atos from bethadba.cloud_atos_fontes where i_atos is not null union all
                                select i_atos from bethadba.isencoes where i_atos is not null union all
                                select i_atos from bethadba.desc_sit_divida where i_atos is not null) as tab_aux_atos
                          where i_atos is not null order by 1);

end;

call tecbth_rgriodosul.unificacao_atos();

commit;