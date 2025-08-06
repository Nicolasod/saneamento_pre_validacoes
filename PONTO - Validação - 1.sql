-- VALIDAÇÃO 1
-- Busca as descrições repetidas no horário ponto

select list(i_entidades) as entidades, 
       list(i_horarios_ponto) as horario, 
       descricao,
       count(descricao) as quantidade 
  from bethadba.horarios_ponto
 group by descricao 
having quantidade > 1;


-- CORREÇÃO
-- Atualiza as descrições duplicadas adicionando um sufixo numérico para diferenciá-las

-- 1. Criar uma tabela temporária com identificadores únicos para as duplicadas
create table #duplicadas (i_entidades integer, i_horarios_ponto integer, nova_descricao char(100));

-- 2. Inserir na tabela temporária os valores com nova descrição
insert into #duplicadas (i_entidades, i_horarios_ponto, nova_descricao)
select i_entidades, hp.i_horarios_ponto, hp.descricao || ' (' || row_number() over (partition by hp.descricao order by hp.i_horarios_ponto) || ')' as nova_descricao
  from bethadba.horarios_ponto hp
 where hp.descricao in (select descricao
                          from bethadba.horarios_ponto
                         group by descricao
                        having count(*) > 1);

-- 3. Atualizar os registros duplicados (exceto o primeiro, que manterá a descrição original)
update bethadba.horarios_ponto hp
   set descricao = (select d.nova_descricao
                      from #duplicadas d
                     where d.i_entidades = hp.i_entidades
                       and d.i_horarios_ponto = hp.i_horarios_ponto)
 where exists (select 1
                 from #duplicadas d
                where d.i_entidades = hp.i_entidades  
                  and d.i_horarios_ponto = hp.i_horarios_ponto);

-- 4. (Opcional) Excluir a tabela temporária
drop table #duplicadas;