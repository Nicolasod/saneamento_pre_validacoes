-- VALIDAÇÃO 11
-- Verifica CNPJ Nulo

select pj.i_pessoas
  from bethadba.pessoas_juridicas pj 
 inner join bethadba.pessoas p
    on (pj.i_pessoas = p.i_pessoas)
 where cnpj is null;


-- CORREÇÃO
-- Atualiza os CNPJ nulos para 0 para evitar erros de validação.

 -- Cria tabela temporária com os CNPJs gerados
create local temporary table tmp_cnpj (i_pessoas integer, novo_cnpj varchar(14));

insert into tmp_cnpj (i_pessoas, novo_cnpj)
select i_pessoas,
       right('000000000000' || cast(row_num as varchar(12)), 12) || '91'
  from (
    select i_pessoas, row_number() over (order by i_pessoas) as row_num
      from bethadba.pessoas_juridicas
     where cnpj is null
  ) as t;

-- Atualiza os registros usando a tabela temporária
update bethadba.pessoas_juridicas pj
   set cnpj = tmp.novo_cnpj
  from tmp_cnpj tmp
 where pj.i_pessoas = tmp.i_pessoas
   and pj.cnpj is null;

drop table tmp_cnpj;
commit;