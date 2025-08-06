-- VALIDAÇÃO 44
-- Verifica o nome de rua se está vazio

select i_ruas, nome
  from bethadba.ruas 
 where nome = ''
    or nome is null;


-- CORREÇÃO
-- Atualiza o nome da rua para 'rua sem nome' onde o nome está vazio ou é nulo

update bethadba.ruas 
   set nome = 'rua sem nome 40'
 where i_ruas = 40;