-- VALIDAÇÃO 52
-- Verifica os grupos funcionais repetidos

select list(i_entidades) as entidades,
       list(i_grupos) as grupos,
       nome,
       count(nome) as quantidade
  from bethadba.grupos
 group by nome 
having quantidade > 1;


-- CORREÇÃO
-- Atualiza os nomes dos grupos funcionais repetidos, adicionando o identificador da entidade ao final do nome

update bethadba.grupos g
   set nome = i_grupos || ' - ' || nome
 where nome in (select nome
                  from bethadba.grupos
                 group by nome
                having count(nome) > 1);