-- VALIDAÇÃO 17
-- Necessario possuir uma area de atuação

select i_entidades,
       i_concursos,
       i_candidatos
  from bethadba.candidatos as c
 where i_areas_atuacao is null;


-- CORREÇÃO
-- Insere em areas_conhec apenas os registros que não existem
insert into bethadba.areas_conhec (i_entidades, i_concursos, i_cargos, num_vagas, i_areas_atuacao)
select distinct c.i_entidades, c.i_concursos, c.i_cargos, 1, 1
  from bethadba.candidatos c
 where c.i_areas_atuacao is null
   and not exists (
       select 1
         from bethadba.areas_conhec ac
        where ac.i_entidades = c.i_entidades
          and ac.i_concursos = c.i_concursos
          and ac.i_cargos = c.i_cargos
          and ac.i_areas_atuacao = 1
   );

-- Agora atualiza os candidatos
update bethadba.candidatos
   set i_areas_atuacao = 1
 where i_areas_atuacao is null;

commit;