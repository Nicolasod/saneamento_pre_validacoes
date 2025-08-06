-- VALIDAÇÃO 19
-- Verifica se idade_ini e idade_fin estão vazios - Faltam dados nas colunas idade_ini e idade_fin na tabela planos_saude_tabelas_faixas. É necessário ter os dados preenchidos

select case 
        when count(*) > 0
        then (select count(*)
                from bethadba.planos_saude_tabelas_faixas) 
        else 1
       end total_registros
  from bethadba.planos_saude;


-- CORREÇÃO
-- Atualizar os registros na tabela planos_saude_tabelas_faixas para preencher idade_ini e idade_fin com valores padrão, se necessário.

update bethadba.planos_saude_tabelas_faixas
   set idade_ini = 0, idade_fin = 100
 where idade_ini is null
    or idade_fin is null;