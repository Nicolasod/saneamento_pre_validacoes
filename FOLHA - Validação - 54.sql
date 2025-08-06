-- VALIDAÇÃO 54
-- Verifica se o número de telefone na lotação física é maior que 9 caracteres

select i_entidades,
       i_locais_trab,
       fone,
       length(fone) as quantidade
  from bethadba.locais_trab
 where quantidade > 9;


-- CORREÇÃO
-- Atualiza o número de telefone na lotação física para remover caracteres especiais e garantir que o número tenha no máximo 9 caracteres

update bethadba.locais_trab 
   set fone = replace(replace(replace(fone,'(',''),')',''),'48','')
 where fone in (select fone
                  from (select i_entidades,
                               i_locais_trab,
                               fone,
                               length(fone) as quantidade
                          from bethadba.locais_trab
                         where quantidade > 9) as teste);