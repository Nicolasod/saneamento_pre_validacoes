-- VALIDAÇÃO 5
-- Busca as ocorrências do ponto com nome repetido

select LIST(i_ocorrencias_ponto) as ocorrencias_ponto, 
       trim(nome) as nose, 
       count(nome) as cods,
       mensagem_erro = 'Ocorrencias do ponto com nome repetido'
  from bethadba.ocorrencias_ponto
 group by nose
having cods > 1;


-- CORREÇÃO
-- Atualiza os pontos com nome repetido para adicionar um sufixo numérico

update bethadba.ocorrencias_ponto
   set nome = (select count(*) 
                 from bethadba.ocorrencias_ponto as op 
                where op.nome = bethadba.ocorrencias_ponto.nome) + 1 || ' - ' || nome
 where nome in (select nome 
                   from bethadba.ocorrencias_ponto 
                  group by nome 
                 having count(nome) > 1);