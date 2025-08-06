-- VALIDAÇÃO 6
-- Busca as Permutas com datas nulas

select i_entidades, 
       i_funcionarios, 
       i_turmas 
  from bethadba.permuta_func_turmas as pft
 where dt_inicial is null
    or dt_final is null;


-- CORREÇÃO
-- Exclui as permutas com datas nulas

delete bethadba.permuta_func_turmas as pft
 where dt_inicial is null
    or dt_final is null;