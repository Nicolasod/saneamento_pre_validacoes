-- VALIDAÇÃO 133
-- Verifica a existência de data de fechamento de cálculo da folha

select funcionarios.i_funcionarios,
       dados_calc.dt_fechamento
  from bethadba.dados_calc,
       bethadba.funcionarios 
 where dados_calc.i_entidades = funcionarios.i_entidades
   and dados_calc.i_funcionarios = funcionarios.i_funcionarios
   and dt_fechamento is null;


-- CORREÇÃO
-- Adiciona data de fechamento de cálculo da folha para as entidades que não possuem data de fechamento de cálculo da folha

for a1 as a2 cursor for
    select xxi_ent = i_entidades,
           xxi_compe = i_competencias,
           i_competencias,
           linha = row_number() over (order by xxi_ent),
           xxdt_fechamento = dateformat(dateadd(dd, -DAY(i_competencias),dateadd(mm,1,i_competencias)),'yyyy-MM-dd')
      from bethadba.dados_calc dc 
     where dt_fechamento is null
do
    update bethadba.dados_calc
       set dt_fechamento = xxdt_fechamento
     where i_competencias < '2099-12-01'
       and i_entidades = xxi_ent;
       
    message 'Data de fechamento adicionada: ' || xxdt_fechamento || ', na competencia: ' || i_competencias || '. Linha: ' ||linha to client;
end for;