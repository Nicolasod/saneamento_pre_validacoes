-- VALIDAÇÃO 71
-- Informar a conta bancaria quando o pagamento for credito em conta

select hf.i_funcionarios,
       mensagem_erro = 'Permanece inconsistência'
  from bethadba.hist_funcionarios hf 
  join bethadba.afastamentos a
    on (hf.i_funcionarios = a.i_funcionarios)
 where hf.forma_pagto = 'R'
   and hf.i_pessoas_contas is null 
   and a.i_tipos_afast = 7;


-- CORREÇÃO
-- Atualiza a conta bancária dos funcionários com forma de pagamento 'R' (Crédito em conta) para a conta bancária correspondente na tabela pessoas_contas

update bethadba.hist_funcionarios hf
   set forma_pagto = 'D'
 where forma_pagto = 'R'
   and i_pessoas_contas is null;