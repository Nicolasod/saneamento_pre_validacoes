-- VALIDAÇÃO 36
-- Verifica se a data de fonte de divulgação é menor que a data de publicação do ato

select a.i_atos,
       fa.dt_publicacao,
       fa.dt_publicacao as dd,
       a.dt_publicacao    ,
       a.dt_publicacao as tttt                
  from bethadba.atos as a
 inner join bethadba.fontes_atos as fa
    on (fa.i_atos = a.i_atos)
 where fa.dt_publicacao < a.dt_publicacao;


-- CORREÇÃO
-- Atualiza a data de publicação do ato para ser igual à data de fonte de divulgação onde a data de fonte de divulgação é menor que a data de publicação do ato

update bethadba.atos as a
 inner join bethadba.fontes_atos as fa
    on (fa.i_atos = a.i_atos)
   set a.dt_publicacao = fa.dt_publicacao
 where fa.dt_publicacao < a.dt_publicacao;