-- VALIDAÇÃO 12
-- Verifica a descrição dos logradouros que tem caracter especial no inicio da descrição

select substring(nome, 1, 1) as nome_com_caracter,
       i_ruas
  from bethadba.ruas 
 where nome_com_caracter in ('[', ']');


-- CORREÇÃO
-- Remove os caracteres especiais '[' e ']' do início da descrição do logradouro

update bethadba.ruas
set nome = ltrim(substring(nome, 2, len(nome)))
where left(nome, 1) in ('[', ']');

--