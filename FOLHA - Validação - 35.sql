-- VALIDAÇÃO 35
-- Verifica a natureza de texto jurúdico se é nulo nos atos

select i_atos 
  from bethadba.atos 
 where i_natureza_texto_juridico is null;


-- CORREÇÃO
-- Atualiza a natureza de texto jurídico para 99 (SEM INFORMAÇÃO) onde a natureza de texto jurídico é nula
                 
insert into bethadba.natureza_texto_juridico (i_natureza_texto_juridico, descricao, codigo_tce, classif)
values (99, 'SEM INFORMAÇÃO', 99, 9);

update bethadba.atos
   set i_natureza_texto_juridico = 99
 where i_natureza_texto_juridico is null;