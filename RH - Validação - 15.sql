-- VALIDAÇÃO 15
-- Ausência de membros em comissões - Ausência de membros em comissões, necessario um membro cadastrado para comissão

select i_comissoes_aval,
       nome
  from bethadba.comissoes_aval as ca
 where not exists(select first 1
                    from bethadba.comissoes_aval_membros as cam
                   where ca.i_comissoes_aval = cam.i_comissoes_aval);


-- CORREÇÃO
-- Excluir comissões que não possuem membros cadastrados

delete from bethadba.comissoes_aval
 where not exists (select first 1 
                     from bethadba.comissoes_aval_membros as cam
                    where comissoes_aval.i_comissoes_aval = cam.i_comissoes_aval);