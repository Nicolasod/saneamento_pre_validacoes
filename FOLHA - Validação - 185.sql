-- VALIDAÇÃO 185
-- Descrição de tipos de cargos duplicadas

select a.i_tipos_cargos,
       a.descricao
  from bethadba.tipos_cargos as a
 where exists(select first 1
 				from bethadba.tipos_cargos as b
               where b.descricao = a.descricao
                 and b.i_tipos_cargos <> a.i_tipos_cargos);


-- CORREÇÃO
-- Atualizar a descrição do tipo de cargo duplicada inserindo o prefixo 'i_tipos_cargos - ' antes da descrição original

update bethadba.tipos_cargos as a
   set descricao = a.i_tipos_cargos || ' - ' || a.descricao
 where exists (select first 1
 				         from bethadba.tipos_cargos as b
                where b.descricao = a.descricao
                  and b.i_tipos_cargos <> a.i_tipos_cargos);