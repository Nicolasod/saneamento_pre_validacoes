-- VALIDAÇÃO 14
-- Verifica os nomes dos tipos bases repetidos

select list(i_tipos_bases) tiposs, 
       nome, 
       count(nome) as quantidade
  from bethadba.tipos_bases 
 group by nome 
having quantidade > 1;


-- CORREÇÃO
-- Remove os tipos de base repetidos, mantendo apenas o registro com menor i_tipos_bases para cada nome

delete from bethadba.tipos_bases
where i_tipos_bases not in (
    select min(i_tipos_bases)
    from bethadba.tipos_bases
    group by nome