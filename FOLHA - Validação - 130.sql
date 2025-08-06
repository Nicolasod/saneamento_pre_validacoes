-- VALIDAÇÃO 130
-- Cadastro agrupador de evento

select ae.i_agrupadores
  from bethadba.agrupadores_eventos ae
 where ordenacao is null;


-- CORREÇÃO
-- Atualiza a ordenação dos agrupadores de eventos que estão com ordenação nula com o valor do campo i_agrupadores

update bethadba.agrupadores_eventos
   set ordenacao = i_agrupadores
 where ordenacao is null;