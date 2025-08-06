-- VALIDAÇÃO 69
-- Descrição do motivo de alteração salarial repetida

select list(i_motivos_altsal ) as motivoss, 
       trim(descricao) as descricaos, 
       count(descricao) as quantidade,
       mensagem_erro = 'Descrição de motivo de alteração salarial repetindo'
  from bethadba.motivos_altsal 
 group by descricaos
having quantidade > 1;


-- CORREÇÃO
-- Atualiza a descrição dos motivos de alteração salarial repetidos para evitar duplicidade

update bethadba.motivos_altsal
   set motivos_altsal.descricao = motivos_altsal.descricao || '-' || motivos_altsal.i_motivos_altsal
 where motivos_altsal.i_motivos_altsal in (select i_motivos_altsal
                                             from bethadba.motivos_altsal
                                            where (select count(i_motivos_altsal)
                                                     from bethadba.motivos_altsal m
                                                    where trim(m.descricao) = trim(motivos_altsal.descricao)) > 1);