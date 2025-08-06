-- VALIDAÇÃO 14
-- Verifica os nomes dos tipos bases repetidos

select list(i_tipos_bases) tiposs, 
       nome, 
       count(nome) as quantidade
  from bethadba.tipos_bases 
 group by nome 
having quantidade > 1;


-- CORREÇÃO
-- Atualiza os nomes dos tipos bases repetidos para evitar duplicidade

update bethadba.tipos_bases
   set nome = i_tipos_bases || ' - ' || nome
 where nome in (select nome
                  from bethadba.tipos_bases 
                 group by nome 
                having count(nome) > 1);
