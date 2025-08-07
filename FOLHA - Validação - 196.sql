-- VALIDAÇÃO 196
-- Categoria esocial com tipos divergentes

select i_vinculos,
	     categoria_esocial,
       descricao,
       tipo_vinculo
  from bethadba.vinculos as v
 where categoria_esocial is not null
   and exists (select first 1
                 from bethadba.vinculos as v2
                where v2.categoria_esocial = v.categoria_esocial
                  and v2.tipo_vinculo <> v.tipo_vinculo)
 order by 2 asc;


-- CORREÇÃO
-- Atualizar o tipo de vínculo para que não haja divergência de categoria_esocial

update bethadba.vinculos as v
   set tipo_vinculo = (select tipo_vinculo
                         from bethadba.vinculos as v2
                        where v2.categoria_esocial = v.categoria_esocial
                          and i_vinculos = (select min(v3.i_vinculos)
                                              from bethadba.vinculos as v3
                                             where v3.categoria_esocial = v.categoria_esocial))
 where categoria_esocial is not null
   and i_vinculos > (select min(v4.i_vinculos)
                       from bethadba.vinculos as v4
                      where v4.categoria_esocial = v.categoria_esocial);