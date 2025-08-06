-- VALIDAÇÃO 16
-- Descrição maior que o numero permitido de caracteres - Descrição maior que o numero permitido de caracteres(500)

select i_fatores,
       nome
  from bethadba.fatores as f
 where length(f.descricao) > 500;


-- CORREÇÃO
-- Atualizando a descrição para que não exceda o limite de 500 caracteres

update bethadba.fatores
   set descricao = substr(descricao, 1, 500)
 where length(descricao) > 500;