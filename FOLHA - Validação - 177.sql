-- VALIDAÇÃO 177
-- Autônomo com vinculo com a categoria_esocial diferente de 701

select hf.i_entidades,
       hf.i_funcionarios,
       hf.i_vinculos 
  from bethadba.hist_funcionarios hf 
  join bethadba.funcionarios f
    on hf.i_entidades = f.i_entidades
   and hf.i_funcionarios = f.i_funcionarios 
  join bethadba.vinculos v
    on hf.i_vinculos = v.i_vinculos
 where f.tipo_func = 'A' 
   and f.conselheiro_tutelar = 'N'
   and v.categoria_esocial not in ('701', '711', '741');


-- CORREÇÃO
-- Atualizar a categoria_esocial do vinculo para 701

update bethadba.vinculos v
   set v.categoria_esocial = '701'
 where v.categoria_esocial not in ('701', '711', '741')
   and exists (select 1 
                 from bethadba.hist_funcionarios hf 
                 join bethadba.funcionarios f
                   on hf.i_entidades = f.i_entidades
                  and hf.i_funcionarios = f.i_funcionarios 
                where hf.i_vinculos = v.i_vinculos
                  and f.tipo_func = 'A' 
                  and f.conselheiro_tutelar = 'N');