-- VALIDAÇÃO 56
-- Busca as descrições repetidas dos níveis salariais

select niveis.i_entidades as entidades,
       niveis.nome as nomes,
       count(niveis.nome) as quantidade,
       list(niveis.i_niveis) as codigos
  from bethadba.niveis
 group by niveis.i_entidades, niveis.nome
having count(niveis.nome) > 1;


-- CORREÇÃO
-- Atualiza os nomes dos níveis salariais repetidos, adicionando o identificador do nível ao início do nome e garantindo que os nomes sejam únicos

update bethadba.niveis
   set niveis.nome = niveis.i_niveis || ' - ' || niveis.nome
 where niveis.i_niveis in (select i_niveis
                             from bethadba.niveis
                            where (select count(i_niveis)
                                     from bethadba.niveis as n
                                    where trim(n.nome) = trim(niveis.nome)) > 1);