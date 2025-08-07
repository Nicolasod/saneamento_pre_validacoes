-- VALIDAÇÃO 176
-- Conselheiro com vinculo com a categoria_esocial diferente de 771

select hf.i_entidades,
       hf.i_funcionarios,
       hf.i_vinculos 
  from bethadba.hist_funcionarios as hf
  join bethadba.funcionarios as f
    on hf.i_entidades = f.i_entidades
   and hf.i_funcionarios = f.i_funcionarios
  join bethadba.vinculos v
    on hf.i_vinculos = v.i_vinculos
 where f.tipo_func = 'A' 
   and f.conselheiro_tutelar = 'S'
   and v.categoria_esocial <> '771';


-- CORREÇÃO
-- Atualizar a categoria_esocial do vinculo do conselheiro para 771

update bethadba.vinculos
   set categoria_esocial = '771'
 where i_vinculos in (select hf.i_vinculos
                        from bethadba.hist_funcionarios as hf
                        join bethadba.funcionarios as f
                          on hf.i_entidades = f.i_entidades
                         and hf.i_funcionarios = f.i_funcionarios
                       where f.tipo_func = 'A' 
                         and f.conselheiro_tutelar = 'S'
                         and hf.i_vinculos is not null
                         and hf.i_vinculos in (select i_vinculos
                                                 from bethadba.vinculos
                                                where categoria_esocial <> '771'));