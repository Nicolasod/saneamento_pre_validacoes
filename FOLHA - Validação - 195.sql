-- VALIDAÇÃO 195
-- Agrupador sem eventos

select i_agrupadores,
       descricao,
       tipo
  from bethadba.agrupadores_eventos as ae
 where not exists(select first 1
                    from bethadba.eventos
                   where i_agrupadores = ae.i_agrupadores);


-- CORREÇÃO
-- Excluir agrupadores sem eventos

delete from agrupadores_eventos
 where not exists (select first 1
                     from bethadba.eventos
                    where i_agrupadores = agrupadores_eventos.i_agrupadores);