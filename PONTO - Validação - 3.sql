-- VALIDAÇÃO 3
-- Verifica a descrição do motivo de alteração do ponto se contém mais que 30 caracteres

select i_motivos_altponto,
       length(descricao) as tamanho_descricao
  from bethadba.motivos_altponto 
 where tamanho_descricao > 30;


-- CORREÇÃO
-- Trunca a descrição do motivo de alteração do ponto para 30 caracteres

update bethadba.motivos_altponto
   set descricao = left(descricao, 30)
 where length(descricao) > 30;