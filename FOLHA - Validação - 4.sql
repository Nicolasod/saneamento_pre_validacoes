-- VALIDAÇÃO 04  
-- Busca os campos adicionais com descrição repetido

select list(i_caracteristicas) as caracteristicas, 
       trim(nome) as nomes, 
       count(nome) 
  from bethadba.caracteristicas 
 group by nomes
having count(nome) > 1;


-- CORREÇÃO
-- Atualiza os nomes dos campos adicionais repetidos para evitar duplicidade
                
update bethadba.caracteristicas
   set nome = i_caracteristicas || nome
 where i_caracteristicas in (select nm_caract
							   from (select max(i_caracteristicas) as nm_caract,
							   				nome
 									   from bethadba.caracteristicas
 									  where (select count(1)
 											   from bethadba.caracteristicas c
 											  where c.i_caracteristicas = c.i_caracteristicas
 												and trim(c.nome) = trim(caracteristicas.nome)) > 1
									  group by nome ) as maior);