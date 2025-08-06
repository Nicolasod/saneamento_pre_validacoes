-- VALIDAÇÃO 47
-- Verifica os eventos de média/vantagem se estão compondo outros eventos de média/vantagem

select i_eventos_medias,
       i_eventos
  from bethadba.mediasvant_eve 
 where i_eventos in (select i_eventos
                       from bethadba.mediasvant);


-- CORREÇÃO
-- Exclui os eventos de média vantagem que estão compondo outros eventos de média vantagem

delete from bethadba.mediasvant_eve 
 where i_eventos = 1033;