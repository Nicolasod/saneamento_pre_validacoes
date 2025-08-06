-- VALIDAÇÃO 46
-- Verifica os eventos de média vantagem que não tem eventos vinculados

select m.i_eventos as eventos,                
       me.i_eventos_medias
  from bethadba.mediasvant m
  left join bethadba.mediasvant_eve me
    on (m.i_eventos = me.i_eventos_medias)
 where me.i_eventos_medias is null;


-- CORREÇÃO
-- Exclui os eventos de média vantagem que não possuem eventos vinculados

delete from bethadba.mediasvant
 where not exists(select 1
                    from bethadba.mediasvant_eve
                   where mediasvant_eve.i_eventos_medias = mediasvant.i_eventos);