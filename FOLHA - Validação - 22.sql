-- VALIDAÇÃO 22 
-- Verifica as folha que não foram fechadas conforme competência passada por parâmetro

select i_entidades,
       i_competencias
  from bethadba.processamentos 
 where dt_fechamento is null;


-- CORREÇÃO
-- Atualiza a data de fechamento das folhas que não foram fechadas, adicionando a data de fechamento como o último dia do mês da competência

for a1 as a2 cursor for
    select xxi_ent = i_entidades,
           xxi_compe = i_competencias,
           i_competencias,
           linha = row_number() over (order by xxi_ent),
           xxdt_fechamento = dateformat(dateadd(dd, -DAY(i_competencias),dateadd(mm,1,i_competencias)),'yyyy-MM-dd')
      from bethadba.processamentos
     where dt_fechamento is null
       and i_competencias < '2999-12-01'
do
    update bethadba.processamentos
       set dt_fechamento = xxdt_fechamento
     where i_competencias = xxi_compe
       and i_entidades = xxi_ent;
    
    message 'Data de fechamento adicionada: ' || xxdt_fechamento || ', na competencia: ' || i_competencias || '. Linha: ' ||linha to client; 
end for;