-- VALIDAÇÃO 28
-- Busca os tipos de afastamentos repetidos

select list(i_tipos_afast) tiposafs, 
       trim(descricao) descricoes,
       count(descricao) as quantidade 
  from bethadba.tipos_afast 
 group by descricoes
having quantidade > 1;


-- CORREÇÃO
-- Atualiza os tipos de afastamentos repetidos para evitar duplicidade, adicionando o i_tipos_afast ao nome do tipo de afastamento

update bethadba.tipos_afast
   set tipos_afast.descricao = tipos_afast.i_tipos_afast || '-' || tipos_afast.descricao
 where tipos_afast.i_tipos_afast in (select i_tipos_afast
                                       from bethadba.tipos_afast
                                      where (select count(i_tipos_afast)
                                               from bethadba.tipos_afast as t
                                              where trim(t.descricao) = trim(tipos_afast.descricao)) > 1);