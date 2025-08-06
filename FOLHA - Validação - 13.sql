-- VALIDAÇÃO 13
-- Verifica os bairros com descrição repetidos

select list(i_bairros) as idbairro, 
       trim(nome) as nomes, 
       count(nome) as quantidade
  from bethadba.bairros 
 group by nomes
having quantidade > 1;


-- CORREÇÃO
-- Atualiza os nomes dos bairros repetidos para evitar duplicidade

update bethadba.bairros
   set bairros.nome = bairros.nome || ' - (Cod: ' || i_bairros  || ')'
 where bairros.i_bairros in (select codigo
				   		       from (select max(i_bairros) as codigo,
							   				nome
      				  				   from bethadba.bairros
      				  				  where (select count(i_bairros)
	   		 		 						   from bethadba.bairros as b
       		 			 					  where trim(b.nome) = trim(bairros.nome)) > 1
       		 		  	 	  		  group by nome) as maior);