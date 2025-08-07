-- VALIDAÇÃO 178
-- Funcionario com vínculo com a categoria_esocial 771 ou 701

select hf.i_entidades,
       hf.i_funcionarios,
       hf.i_vinculos,
       v.categoria_esocial
  from bethadba.hist_funcionarios as hf 
  join bethadba.funcionarios as f
    on hf.i_entidades = f.i_entidades
   and hf.i_funcionarios = f.i_funcionarios 
  join bethadba.vinculos v
    on hf.i_vinculos = v.i_vinculos
 where f.tipo_func = 'F'
   and v.categoria_esocial in ('701','771');


-- Correção
-- Atualiza o vínculo para 5 (Estatutário - Regime Estatutário - Efetivo) para funcionários do tipo F (Funcionário Público) com vínculo com a categoria_esocial 701 ou 771

update bethadba.vinculos
   set categoria_esocial = '5'
 where i_vinculos in (select hf.i_vinculos
                        from bethadba.hist_funcionarios as hf 
                        join bethadba.funcionarios as f
                          on hf.i_entidades = f.i_entidades
                         and hf.i_funcionarios = f.i_funcionarios 
                        join bethadba.vinculos v
                          on hf.i_vinculos = v.i_vinculos
                       where f.tipo_func = 'F'
                         and v.categoria_esocial in ('701','771'));