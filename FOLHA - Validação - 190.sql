-- VALIDAÇÃO 190
-- Descrição de habilitação superior ao limite de caracteres

select aa.i_areas_atuacao,
       aa.nome,
       aa.descr_habilitacao
  from bethadba.areas_atuacao as aa
 where length(aa.descr_habilitacao) > 100;


-- CORREÇÃO
-- A correção deve ser feita no cadastro da área de atuação, reduzindo o tamanho da descrição para 100 caracteres ou menos.

update bethadba.areas_atuacao
   set descr_habilitacao = substr(descr_habilitacao, 1, 100)
 where length(descr_habilitacao) > 100;