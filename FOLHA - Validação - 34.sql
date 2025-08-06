-- VALIDAÇÃO 34
-- Níveis de organogramas com separadores nulos 

select i_config_organ,
       i_niveis_organ,
       descricao 
  from bethadba.niveis_organ 
 where separador_nivel is null
   and i_niveis_organ != 1


-- CORREÇÃO
-- Atualiza os níveis de organogramas com separadores nulos, definindo o separador como '.'

update niveis_organ
   set separador_nivel = '.'
 where separador_nivel is null;