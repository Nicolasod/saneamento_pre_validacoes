-- VALIDAÇÃO 4
-- Busca os funcionários com marcações com origem inválida

select i_funcionarios,
       mensagem_erro = 'Não são permitidas marcações com origem de Pré-assinaladas'
  from bethadba.apuracoes_marc as am
 where origem_marc not in ('O','I','A');


-- CORREÇÃO
-- Atualiza as marcações com origem inválida para uma origem válida

update bethadba.apuracoes_marc
   set origem_marc = 'I'
 where origem_marc not in ('O','I','A');