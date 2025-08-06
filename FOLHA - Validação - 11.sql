-- VALIDAÇÃO 11
-- Verifica CNPJ Nulo

select pj.i_pessoas
  from bethadba.pessoas_juridicas pj 
 inner join bethadba.pessoas p
    on (pj.i_pessoas = p.i_pessoas)
 where cnpj is null;


-- CORREÇÃO
-- Atualiza os CNPJ nulos para 0 para evitar erros de validação.

update bethadba.pessoas_juridicas
   set cnpj = right('000000000000' || cast((row_number() over (order by i_pessoas)) as varchar(12)), 12) || '91'
 where cnpj is null;