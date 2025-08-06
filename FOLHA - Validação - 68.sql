-- VALIDAÇÃO 68
-- Quando a forma de pagamento for Crédito em conta é necessário informar a conta bancária

select i_funcionarios,
       i_entidades,
       mensagem_erro = 'Funcionarios com recebimento credito em conta sem dados da conta bancaria'
  from bethadba.hist_funcionarios as hf 
 where forma_pagto = 'R'
   and i_pessoas_contas is null;


-- CORREÇÃO
-- Atualiza a conta bancária dos funcionários com forma de pagamento 'R' (Crédito em conta) para a conta bancária correspondente na tabela pessoas_contas

update bethadba.hist_funcionarios
   set i_pessoas_contas = (select i_pessoas_contas
                             from bethadba.pessoas_contas
                            where i_pessoas = hist_funcionarios.i_pessoas)
 where forma_pagto = 'R'
   and i_pessoas_contas is null;