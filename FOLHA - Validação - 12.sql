-- VALIDAÇÃO 12
-- Verifica a descrição dos logradouros que tem caracter especial no inicio da descrição

select substring(nome, 1, 1) as nome_com_caracter,
       i_ruas
  from bethadba.ruas 
 where nome_com_caracter in ('[', ']');


-- CORREÇÃO
-- Retira o caracter especial do inicio da descrição dos logradouros
update bethadba.ruas
   set nome = ltrim(nome, '[]')
 where substring(nome, 1, 1) in ('[', ']');