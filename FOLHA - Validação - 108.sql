-- VALIDAÇÃO 108
-- Verifica o pensionista que esta com o campo tipo_pens null

select f.i_entidades,
       f.i_funcionarios, 
       f.tipo_pens  
  from bethadba.funcionarios f 
  join bethadba.hist_funcionarios hf
    on f.i_funcionarios = hf.i_funcionarios
   and f.i_entidades = hf.i_entidades 
  join bethadba.vinculos v
    on hf.i_vinculos = v.i_vinculos 
 where f.tipo_pens is null
   and v.tipo_func = 'B'
   and v.categoria_esocial is null;


-- CORREÇÃO
-- Atualiza o campo tipo_pens para 1 (pensão por morte) para os pensionistas que estão com o campo tipo_pens como null

update bethadba.funcionarios as f
   set f.tipo_pens = 1
  from bethadba.hist_funcionarios hf,
       bethadba.vinculos v 
 where f.tipo_pens is null
   and f.i_funcionarios = hf.i_funcionarios
   and f.i_entidades = hf.i_entidades
   and hf.i_vinculos = v.i_vinculos
   and v.tipo_func = 'B'
   and v.categoria_esocial is null;