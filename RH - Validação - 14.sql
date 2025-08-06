-- VALIDAÇÃO 14
-- Descrição habilitação maior que o permitido - Descrição habilitação maior que o permitido, não é permitido possuir mais de 100 caracateres

select i_areas_atuacao,
       nome
  from bethadba.areas_atuacao
 where length(descr_habilitacao) > 100;


-- CORREÇÃO
-- A descrição da habilitação deve ser corrigida para que não ultrapasse o limite de 100 caracteres.

update bethadba.areas_atuacao
   set descr_habilitacao = substr(descr_habilitacao, 1, 100)
 where length(descr_habilitacao) > 100;