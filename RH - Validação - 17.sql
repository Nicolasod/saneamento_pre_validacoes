-- VALIDAÇÃO 17
-- Necessario possuir uma area de atuação

select i_entidades,
       i_concursos,
       i_candidatos
  from bethadba.candidatos as c
 where i_areas_atuacao is null;


-- CORREÇÃO
-- Atualiza os candidatos que não possuem área de atuação para a área de atuação padrão (1)

update bethadba.candidatos
   set i_areas_atuacao = 1
 where i_areas_atuacao is null;