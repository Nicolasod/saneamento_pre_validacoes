-- VALIDAÇÃO 187
-- Pessoas com número da certidão contendo mais de 15 dígitos para os modelos antigos.

select i_pessoas,
       modelo = if isnumeric(bethadba.dbf_retira_caracteres_especiais(pessoas_fis_compl.num_reg)) = 1 then
                   'NOVO'
                else
                   'ANTIGO'
                endif,
       numeroNascimento = if modelo = 'ANTIGO' then 
                            pessoas_fis_compl.num_reg 
                          else
                            bethadba.dbf_retira_alfa_de_inteiros(pessoas_fis_compl.num_reg)
                          endif
  from bethadba.pessoas_fis_compl
 where numeroNascimento is not null
   and length(numeroNascimento) > 15
   and modelo = 'ANTIGO';


-- CORREÇÃO
-- Atualizar os registros com número da certidão contendo mais de 15 dígitos para os modelos antigos.

update bethadba.pessoas_fis_compl
   set num_reg = bethadba.dbf_retira_caracteres_especiais(num_reg)
 where i_pessoas in (select i_pessoas
                       from (select i_pessoas,
                                    modelo = if isnumeric(bethadba.dbf_retira_caracteres_especiais(pessoas_fis_compl.num_reg)) = 1 then
                                                'NOVO'
                                             else
                                                'ANTIGO'
                                             endif,
                                    numeroNascimento = if modelo = 'ANTIGO' then 
                                                          pessoas_fis_compl.num_reg 
                                                       else
                                                          bethadba.dbf_retira_alfa_de_inteiros(pessoas_fis_compl.num_reg)
                                                       endif
                               from bethadba.pessoas_fis_compl
                              where numeroNascimento is not null
                                and length(numeroNascimento) > 15
                                and modelo = 'ANTIGO') as subquery);