-- VALIDAÇÃO 98
-- Telefone com mais de 11 caracteres na lotação fisica

select i_entidades,
       i_locais_trab,
       fone,
       length(fone) as quantidade
  from bethadba.locais_trab
 where quantidade > 11;


-- CORREÇÃO
-- Atualiza o campo fone para que tenha no máximo 8 caracteres, removendo caracteres especiais e espaços

update bethadba.locais_trab
   set fone = right(trim(replace(replace(replace(fone,'-',''),'(',''),')','')),8)
 where length(fone) > 9;