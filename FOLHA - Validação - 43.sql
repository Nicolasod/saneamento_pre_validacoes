-- VALIDAÇÃO 43
-- Verifica o número de endereço se está vazio

select i_pessoas
  from bethadba.pessoas_enderecos 
 where numero = '';


-- CORREÇÃO

update bethadba.pessoas_enderecos 
   set numero = 0
 where i_pessoas in (select i_pessoas
                       from bethadba.pessoas_enderecos 
                      where numero = '')
   and numero = '';