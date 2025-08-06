-- VALIDAÇÃO 58
-- Busca as contas bancárias dos funcionários que estão inválidas

select f.i_funcionarios,
       f.i_entidades,
       hf.dt_alteracoes,
       hf.i_bancos as banco_atual,
       hf.i_agencias as agencia_atual,
       hf.i_pessoas_contas,
       pc.i_bancos as banco_novo,
       pc.i_agencias as agencia_nova
  from bethadba.hist_funcionarios hf
 inner join bethadba.funcionarios f
    on (hf.i_funcionarios = f.i_funcionarios
   and hf.i_entidades = f.i_entidades)
 inner join bethadba.pessoas_contas pc
    on (f.i_pessoas = pc.i_pessoas
   and pc.i_pessoas_contas = hf.i_pessoas_contas)    
 where (pc.i_bancos != hf.i_bancos
    or pc.i_agencias != hf.i_agencias)
   and hf.forma_pagto = 'R';


-- CORREÇÃO
-- Atualiza os dados bancários dos funcionários com forma de pagamento 'R' (Crédito em conta) para os dados correspondentes na tabela pessoas_contas

update bethadba.hist_funcionarios,
       bethadba.pessoas_contas,
       bethadba.funcionarios
   set hist_funcionarios.i_bancos = pessoas_contas.i_bancos,
       hist_funcionarios.i_agencias = pessoas_contas.i_agencias
 where hist_funcionarios.i_entidades = funcionarios.i_entidades
   and hist_funcionarios.i_funcionarios = funcionarios.i_funcionarios
   and pessoas_contas.i_pessoas = funcionarios.i_pessoas
   and hist_funcionarios.i_pessoas_contas = pessoas_contas.i_pessoas_contas
   and (hist_funcionarios.i_bancos <> pessoas_contas.i_bancos
    or hist_funcionarios.i_agencias <> pessoas_contas.i_agencias)
   and hist_funcionarios.forma_pagto = 'R';