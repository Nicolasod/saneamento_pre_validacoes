-- VALIDAÇÃO 08  
-- Verifica os CPF's repetidos

select list(pf.i_pessoas) as ipessoa,
       cpf,
       count(cpf) as quantidade
  from bethadba.pessoas_fisicas pf 
 group by cpf 
having quantidade > 1;


-- CORREÇÃO
-- Atualiza os CPF's repetidos para nulo, mantendo apenas o maior i_pessoas

update bethadba.pessoas_fisicas
   set cpf = null
 where i_pessoas in (select maior.numPessoa
 					   from (select max(i_pessoas) as numPessoa,
 					   			    cpf
          					   from bethadba.pessoas_fisicas
          					  where (select count(1)
        					  		   from bethadba.pessoas_fisicas as pf
        					  		  where pf.cpf = pessoas_fisicas.cpf) > 1
							  group by cpf) as maior);