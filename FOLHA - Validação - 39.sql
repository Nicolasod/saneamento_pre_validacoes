-- VALIDAÇÃO 39
-- Verifica descrição de configuração de organograma repetido

select list(i_config_organ) as iconfig,
       descricao,
       count(descricao) as quantidade
  from bethadba.config_organ 
 group by descricao 
having quantidade > 1;


-- CORREÇÃO
-- Atualiza a descrição da configuração de organograma repetido para evitar duplicidade, adicionando o i_config_organ ao nome da configuração

update bethadba.config_organ
   set descricao = i_config_organ || '-' || descricao
 where i_config_organ in (select i_config_organ
                            from bethadba.config_organ
                           where(select count(i_config_organ)
                                   from bethadba.config_organ co
                                  where trim(co.descricao) = trim(config_organ.descricao)) > 1);