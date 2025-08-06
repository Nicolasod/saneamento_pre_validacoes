-- VALIDAÇÃO 40
-- Verifica os RG's repetidos

select list(i_pessoas) as pess,
       rg,
       count(rg) as quantidade
  from bethadba.pessoas_fisicas
 group by rg 
having quantidade > 1;


-- CORREÇÃO
-- Atualiza os RG's repetidos para nulo, evitando duplicidade
 
update bethadba.pessoas_fisicas as pf1
   set rg = null
 where exists (select 1
                 from bethadba.pessoas_fisicas as pf2
                where pf1.rg = pf2.rg
                  and pf1.i_pessoas <> pf2.i_pessoas);