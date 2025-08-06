-- VALIDAÇÃO 09  
-- Verifica os PIS's repetidos

select list(pf.i_pessoas) as idpessoa,
       num_pis,
       count(num_pis) as quantidade
  from bethadba.pessoas_fisicas as pf 
 group by num_pis
having quantidade > 1;


-- CORREÇÃO
-- Atualiza os PIS's repetidos para nulo, mantendo apenas o maior i_pessoas
               
update bethadba.pessoas_fisicas as pf
   set pf.num_pis = null
 where (select count(pf2.num_pis)
          from bethadba.pessoas_fisicas as pf2
         where pf2.num_pis = pf.num_pis) > 1
   and pf.i_pessoas < (select max(pf3.i_pessoas)
                          from bethadba.pessoas_fisicas as pf3
                         where pf3.num_pis = pf.num_pis);
 
update bethadba.hist_pessoas_fis as hpf
   set hpf.num_pis = pf.num_pis
  from bethadba.pessoas_fisicas as pf
 where isnull(hpf.num_pis, '') <> isnull(pf.num_pis, '')
   and hpf.i_pessoas = pf.i_pessoas;