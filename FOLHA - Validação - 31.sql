-- VALIDAÇÃO 31
-- Alterações de cargo dos funcionários maior que a data de rescisão

select hs.i_funcionarios,
       hs.i_entidades,
       hs.dt_alteracoes,
       r.dt_rescisao,
       STRING(r.dt_rescisao, ' ', substring(hs.dt_alteracoes, 12, 8)) as dt_alteracoes_novo
  from bethadba.hist_cargos as hs
 inner join bethadba.rescisoes as r
    on (hs.i_funcionarios = r.i_funcionarios and hs.i_entidades = r.i_entidades)
 where hs.dt_alteracoes > STRING((select max(s.dt_rescisao) 
                                    from bethadba.rescisoes as s
                                    join bethadba.motivos_resc mr
                                      on (s.i_motivos_resc = mr.i_motivos_resc)
                                   where s.i_funcionarios = r.i_funcionarios 
                                     and s.i_entidades = r.i_entidades
                                     and s.dt_canc_resc is null
                                     and s.dt_reintegracao is null
                                     and mr.dispensados != 3), ' 23:59:59')
 order by hs.dt_alteracoes DESC;


-- CORREÇÃO
-- Atualiza os históricos de cargos com data de alteração maior que a data de rescisão, ajustando a data de alteração para um minuto após a última alteração ou para o primeiro dia do mês da data de rescisão se não houver alterações anteriores

for a1 as a2 cursor for
    select
        hs.i_funcionarios,
        hs.i_entidades,
        hs.dt_alteracoes,
        r.dt_rescisao,
        linha = row_number() over (order by hs.i_funcionarios),
        dt_alteracoes_novo = dateadd(ss, -linha , date(STRING(r.dt_rescisao, ' ', substring(hs.dt_alteracoes, 12, 8)))),
        xSQL = 'update bethadba.hist_cargos set dt_alteracoes = '''||dt_alteracoes_novo||''' where i_funcionarios = '||hs.i_funcionarios||' and i_entidades = '||hs.i_entidades||' and dt_alteracoes = '''||hs.dt_alteracoes||''';'
    from bethadba.hist_cargos hs
    inner join bethadba.rescisoes r on (hs.i_funcionarios = r.i_funcionarios and hs.i_entidades = r.i_entidades)
    where hs.dt_alteracoes > STRING((select max(s.dt_rescisao)
                                           from bethadba.rescisoes s
                                           join bethadba.motivos_resc mr on(s.i_motivos_resc = mr.i_motivos_resc)
                                           where s.i_funcionarios = r.i_funcionarios
                                           and s.i_entidades = r.i_entidades
                                           and s.dt_canc_resc is null
                                           and s.dt_reintegracao is null
                                           and mr.dispensados != 3), ' 23:59:59')
    order by hs.i_funcionarios
do
    message xSQL ||' linha: '||linha to client;
    execute immediate xSQL;
end for;