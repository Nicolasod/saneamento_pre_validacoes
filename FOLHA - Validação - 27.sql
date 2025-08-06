-- VALIDAÇÃO 27
-- Busca as movimentações de pessoal repetidos

select list(i_tipos_movpes) as tiposs, 
       descricao,
       count(descricao) as quantidade 
  from bethadba.tipos_movpes 
 group by descricao 
having quantidade > 1;


-- CORREÇÃO
-- Atualiza as movimentações de pessoal repetidos para evitar duplicidade, adicionando o i_tipos_movpes ao nome do tipo de movimentação

update bethadba.tipos_movpes
   set tipos_movpes.descricao = tipos_movpes.i_tipos_movpes || '-' || tipos_movpes.descricao 
 where tipos_movpes.i_tipos_movpes in(select i_tipos_movpes
                                        from bethadba.tipos_movpes
                                       where (select count(i_tipos_movpes)
                                                from bethadba.tipos_movpes t
                                               where trim(t.descricao) = trim(tipos_movpes.descricao)) > 1);