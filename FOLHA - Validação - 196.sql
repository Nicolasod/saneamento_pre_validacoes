-- VALIDAÇÃO 196
-- Categoria esocial com tipos divergentes

select i_vinculos,
	   categoria_esocial,
       descricao,
       tipo_vinculo
  from bethadba.vinculos as v
 where categoria_esocial is not null
   and exists(select first 1
                from bethadba.vinculos as v2
               where v2.categoria_esocial = v.categoria_esocial
                 and v2.tipo_vinculo <> v.tipo_vinculo)
 order by 2 asc;


-- CORREÇÃO
-- Atualiza o tipo_vinculo para o valor mais comum dentro de cada categoria_esocial

update bethadba.vinculos as v
  set v.tipo_vinculo = (
      select first tipo_vinculo
        from (
            select v2.tipo_vinculo, count(*) as qtd
              from bethadba.vinculos v2
            where v2.categoria_esocial = v.categoria_esocial
            group by v2.tipo_vinculo
            order by qtd desc
        ) as sub
  )
where v.categoria_esocial in (
    select categoria_esocial
      from bethadba.vinculos
    where categoria_esocial is not null
    group by categoria_esocial
    having count(distinct tipo_vinculo) > 1
);