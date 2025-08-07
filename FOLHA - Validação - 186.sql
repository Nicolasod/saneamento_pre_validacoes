-- VALIDAÇÃO 186
-- Descrição com caracteres superior ao limite(50)

select i_entidades,
       i_periodos_trab,
       descricao
  from bethadba.periodos_trab
 where length(descricao) > 50;


-- CORREÇÃO
-- Truncar a descrição para 50 caracteres

update bethadba.periodos_trab
   set descricao = substr(descricao, 1, 50)
 where length(descricao) > 50;