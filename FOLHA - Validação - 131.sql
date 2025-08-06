-- VALIDAÇÃO 131
-- Data de alteração do histórico não pode ser menor que a data de nascimento

select i_pessoas
  from bethadba.hist_pessoas_fis
 where dt_nascimento > dt_alteracoes;


-- CORREÇÃO
-- Atualiza a data de alterações para 18 anos após a data de nascimento para os registros onde a data de nascimento é maior que a data de alterações

update bethadba.hist_pessoas_fis
   set dt_alteracoes = DATEADD(year, 18, dt_nascimento)
 where dt_nascimento > dt_alteracoes;