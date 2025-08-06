-- VALIDAÇÃO 134
-- Verifica os lançamentos posteriores a rescisão

select hf.i_entidades as chave_dsk1,
       hf.i_funcionarios as chave_dsk2,
       r.dt_rescisao,
       v2.dt_inicial,
       v2.dt_final 
  from bethadba.hist_funcionarios hf
 inner join bethadba.hist_cargos hc
    on hf.i_entidades = hc.i_entidades
   and hf.i_funcionarios = hc.i_funcionarios
   and hf.dt_alteracoes <= hc.dt_alteracoes 
 inner join bethadba.funcionarios f
    on f.i_funcionarios = hf.i_funcionarios
   and f.i_entidades = hf.i_entidades
 inner join bethadba.rescisoes r
    on r.i_funcionarios = hf.i_funcionarios
   and r.i_entidades = hf.i_entidades
 inner join bethadba.variaveis v2
    on r.i_entidades = v2.i_entidades
   and r.i_funcionarios = v2.i_funcionarios 
 inner join bethadba.vinculos v
    on v.i_vinculos = hf.i_vinculos
 where hf.i_entidades in (1,2,3,4)
   and (r.dt_rescisao < v2.dt_inicial or r.dt_rescisao < v2.dt_final)
   and r.i_motivos_apos is null
   and r.dt_canc_resc is null
   and r.i_rescisoes  = (select max(r.i_rescisoes)
                           from bethadba.rescisoes r
                          where r.i_entidades = chave_dsk1
                            and r.i_funcionarios = chave_dsk2
                            and r.dt_canc_resc is null
                            and r.i_motivos_apos is null)
 group by hf.i_entidades, hf.i_funcionarios, r.dt_rescisao, v2.dt_inicial, v2.dt_final 
 order by hf.i_entidades, hf.i_funcionarios;


-- CORREÇÃO
-- Ajusta a data final da variavel para a data de rescisão e remove os lançamentos posteriores a rescisão
                
begin
    llLoop: for ll as cur_01 dynamic scroll cursor for
        select v.i_entidades as w_i_entidades, v.i_funcionarios as w_i_funcionarios, v.i_eventos as w_i_eventos, v.dt_inicial as w_dt_inicial, r.dt_rescisao as w_dt_rescisao
          from bethadba.variaveis v, bethadba.rescisoes r
         where r.i_entidades = v.i_entidades
           and r.i_funcionarios = v.i_funcionarios
           and r.dt_rescisao < v.dt_final
    do
        message 'Ajustando a data final da variavel: '+string(w_i_funcionarios)+' - '+string(w_i_eventos)+' - '+string(w_dt_inicial) to client;

        update bethadba.variaveis
           set dt_final = substring(w_dt_rescisao,0,7)
         where i_entidades = w_i_entidades
           and i_funcionarios = w_i_funcionarios
           and i_eventos = w_i_eventos
           and dt_inicial = w_dt_inicial
    end for;
   
   delete bethadba.variaveis
     from bethadba.variaveis v
    inner join bethadba.rescisoes r
       on (v.i_funcionarios = r.i_funcionarios and v.i_entidades = r.i_entidades) 
    where r.dt_rescisao < v.dt_inicial
      and r.i_motivos_apos is null
      and r.dt_canc_resc is null
      and r.i_rescisoes  = (select max(r1.i_rescisoes)
                              from bethadba.rescisoes r1
                             where r1.i_entidades = r.i_entidades
                               and r1.i_funcionarios = r.i_funcionarios
                               and r1.dt_canc_resc is null
                               and r1.i_motivos_apos is null)
end;