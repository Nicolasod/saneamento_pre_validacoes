-- VALIDAÇÃO 94
-- Vinculo empregaticio CLT sem opção federal marcada

select distinct i_entidades,
	   i_funcionarios
  from bethadba.hist_funcionarios,
       bethadba.vinculos
 where hist_funcionarios.i_vinculos = vinculos.i_vinculos
   and tipo_vinculo = 1
   and prev_federal = 'N';


-- CORREÇÃO
-- Atualiza o campo prev_federal para 'S' e fundo_prev para 'N' para os vínculos empregatícios CLT que não possuem opção federal marcada

update bethadba.hist_funcionarios 
 inner join bethadba.vinculos v
    on (hist_funcionarios.i_vinculos = v.i_vinculos)
   set prev_federal = 'S', fundo_prev = 'N'
 where hist_funcionarios.i_vinculos = v.i_vinculos
   and v.tipo_vinculo = 1
   and hist_funcionarios.prev_federal = 'N';