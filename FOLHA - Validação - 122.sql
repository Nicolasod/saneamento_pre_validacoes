-- VALIDAÇÃO 122
-- Configuração Rais sem controle de ponto

select i_entidades,
       i_parametros_rel
  from bethadba.parametros_rel
 where sistema_ponto is null
   and i_parametros_rel = 2;


-- CORREÇÃO
-- Configuração Rais sem controle de ponto

update bethadba.parametros_rel
   set sistema_ponto = coalesce(
       (select top 1 sistema_ponto
          from bethadba.parametros_rel
         where sistema_ponto is not null
           and i_parametros_rel = 2
         group by sistema_ponto
         order by count(*) desc
       ), 1)
 where sistema_ponto is null
   and i_parametros_rel = 2;