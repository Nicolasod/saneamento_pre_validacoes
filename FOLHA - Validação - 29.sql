-- VALIDAÇÃO 29
-- Busca as alterações de históricos dos funcionários maior que a data de rescisão

select hs.i_funcionarios,
       hs.i_entidades,
       date(hs.dt_alteracoes) dt_alt,
       r.dt_rescisao dt_resc,
       date(STRING(r.dt_rescisao, ' ', substring(hs.dt_alteracoes, 12, 8))) as dt_alteracoes_novo
  from bethadba.hist_funcionarios hs
 inner join bethadba.rescisoes r on (hs.i_funcionarios = r.i_funcionarios and hs.i_entidades = r.i_entidades)
 where hs.dt_alteracoes > STRING((select max(s.dt_rescisao) 
                                    from bethadba.rescisoes s 
                                    join bethadba.motivos_resc mr on(s.i_motivos_resc = mr.i_motivos_resc)
                                   where s.i_funcionarios = r.i_funcionarios 
                                     and s.i_entidades = r.i_entidades
                                     and mr.dispensados != 3
                                     and s.dt_reintegracao is null
                                     and s.dt_canc_resc is null), ' 23:59:59')
 order by hs.dt_alteracoes DESC;


-- CORREÇÃO
-- Atualiza os históricos de funcionários com data de alteração maior que a data de rescisão, ajustando a data de alteração para um minuto após a última alteração ou para o primeiro dia do mês da data de rescisão se não houver alterações anteriores
-- Isso garante que as alterações sejam consistentes com a data de rescisão e evita problemas de integridade referencial

begin
  declare lsmsg varchar(100);
  declare w_nova_alteracao timestamp;
  declare w_ultima_alteracao timestamp;
  declare w_rescisao date;
  declare w_conta integer;

  set w_conta = 0;
  llloop: for ll as meuloop2 dynamic scroll cursor for
    select hist_funcionarios.i_entidades as w_entidade, hist_funcionarios.i_funcionarios as w_funcionario, hist_funcionarios.dt_alteracoes as w_alteracao
      from bethadba.hist_funcionarios
     where hist_funcionarios.dt_alteracoes > STRING((select max(s.dt_rescisao)
                                                       from bethadba.rescisoes s join
                                                            bethadba.motivos_resc mr on(s.i_motivos_resc = mr.i_motivos_resc)
                                                       where s.i_funcionarios = hist_funcionarios.i_funcionarios
                                                         and s.i_entidades = hist_funcionarios.i_entidades
                                                         and mr.dispensados != 3
                                                         and s.dt_reintegracao is null
                                                         and s.dt_canc_resc is null), ' 23:59:59')
     order by hist_funcionarios.i_entidades, hist_funcionarios.i_funcionarios, hist_funcionarios.dt_alteracoes
  do
    set w_conta = w_conta + 1;
    set lsmsg = string(w_entidade) || '-' || string(w_funcionario) || '-' || String(w_alteracao);
message(lsmsg) to client;
set w_rescisao = (select max(s.dt_rescisao)
                    from bethadba.rescisoes s join bethadba.motivos_resc mr on(s.i_motivos_resc = mr.i_motivos_resc)
                   where s.i_entidades = w_entidade
                     and s.i_funcionarios = w_funcionario
                     and mr.dispensados != 3
                     and s.dt_reintegracao is null
                     and s.dt_canc_resc is null);
set w_ultima_alteracao = (select max(dt_alteracoes)
							from bethadba.hist_funcionarios
                           where hist_funcionarios.i_entidades = w_entidade
                             and hist_funcionarios.i_funcionarios = w_funcionario
                             and cast(hist_funcionarios.dt_alteracoes as date) = w_rescisao);
if w_ultima_alteracao is null then
  set w_nova_alteracao = cast((String(w_rescisao) + ' 01:00:00') as timestamp)
 else
  set w_nova_alteracao = DateAdd(minute, 1, w_ultima_alteracao);
end if;

delete bethadba.hist_funcionarios_qualif_profissional
 where i_entidades = w_entidade
   and i_funcionarios = w_funcionario
   and dt_alteracoes = w_alteracao;

delete from bethadba.hist_funcionarios_prop_adic
 where i_entidades = w_entidade
   and i_funcionarios = w_funcionario
   and dt_alteracoes = w_alteracao;

update bethadba.hist_funcionarios
   set dt_alteracoes = w_nova_alteracao
 where i_entidades = w_entidade
   and i_funcionarios = w_funcionario
   and dt_alteracoes = w_alteracao;

end for;
end;