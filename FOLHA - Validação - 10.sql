-- VALIDAÇÃO 10 
-- PIS inválido

select pessoas.i_pessoas
  from bethadba.pessoas 
  left join bethadba.pessoas_fisicas
 where bethadba.dbf_chk_pis(num_pis) > 0
   and pessoas.tipo_pessoa != 'J'
   and num_pis is not null;


-- CORREÇÃO
-- Atualiza os PIS's inválidos para nulo
                 
update bethadba.pessoas_fisicas 
   set num_pis = null 
 where i_pessoas in (select pessoas.i_pessoas
                       from bethadba.pessoas 
                       left join bethadba.pessoas_fisicas
                      where bethadba.dbf_chk_pis(num_pis) > 0
   and pessoas.tipo_pessoa != 'J'
   and num_pis is not null);