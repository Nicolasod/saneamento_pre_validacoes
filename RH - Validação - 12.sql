-- VALIDAÇÃO 12
-- Cursos duplicados - Existem cursos com a mesma descrição e tipo

select c.i_cursos,
       c.nome,
       c.tipo
  from bethadba.cursos as c
 where exists (select first 1
                 from bethadba.cursos as c2
                where c2.nome = c.nome
                  and c2.tipo = c.tipo
                  and c2.i_cursos <> c.i_cursos);


-- CORREÇÃO

