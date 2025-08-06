-- VALIDAÇÃO 32
-- Classificações que estão com código errado no tipo de afastamento

select i_tipos_afast,
       classif,
       descricao
  from bethadba.tipos_afast
 where classif in (1, null);


-- CORREÇÃO
-- Atualiza a classificação dos tipos de afastamento para 2 (outros) onde a classificação é nula ou igual a 1

update bethadba.tipos_afast
   set classif = 2
 where classif is null
    or classif = 1;