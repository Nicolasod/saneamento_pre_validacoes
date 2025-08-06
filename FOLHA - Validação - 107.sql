-- VALIDAÇÃO 107
-- Funcionario com data de fim de lotação maior que a data de fim de contrato

select f.i_entidades,
       f.i_funcionarios,
       f.dt_final,
       fv.dt_fim_vinculo
  from bethadba.locais_mov f
  left join bethadba.funcionarios_vinctemp fv 
    on f.i_funcionarios = fv.i_funcionarios
 where f.dt_final > fv.dt_fim_vinculo;


-- CORREÇÃO
-- Atualiza a data final da lotação para a data de fim do vínculo temporário apenas para os casos onde a data final da lotação é maior que a data de fim

update bethadba.locais_mov
   set dt_final = dt_fim_vinculo
  from bethadba.locais_mov lm
  left join bethadba.funcionarios_vinctemp vt
    on lm.i_funcionarios = vt.i_funcionarios
 where lm.dt_final > vt.dt_fim_vinculo;