-- VALIDAÇÃO 14
-- Verifica os nomes dos tipos bases repetidos

select list(i_tipos_bases) tiposs, 
       nome, 
       count(nome) as quantidade
  from bethadba.tipos_bases 
 group by nome 
having quantidade > 1;


-- CORREÇÃO
-- Adiciona um sufixo "- 1", "- 2", etc. ao final do nome dos tipos bases repetidos

update bethadba.tipos_bases tb
set nome = nome || ' - ' || rn
from (
    select i_tipos_bases,
           nome,
           row_number() over (partition by nome order by i_tipos_bases) as rn
    from bethadba.tipos_bases
) t
where tb.i_tipos_bases = t.i_tipos_bases
  and t.rn > 1;