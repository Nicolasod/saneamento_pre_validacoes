-- VALIDAÇÃO 91
-- Deve haver no máximo um local de trabalho principal

select  principal = if isnull(locais_mov.principal,'N') = 'S' then 'true' else 'false' endif,
        dataInicio = dt_inicial,
        dataFim = dt_final,
        i_funcionarios func,
        count(principal) as total,
        max(i_locais_trab)
   from bethadba.locais_mov
  where i_funcionarios = i_funcionarios 
    and i_entidades = i_entidades
    and principal = 'true'
  group by principal, dataInicio, dataFim, principal, i_funcionarios
 having total > 1
  order by locais_mov.i_funcionarios;


-- CORREÇÃO
-- Atualiza o campo principal para 'N' para todos os locais de trabalho dos funcionarios e depois atualiza para 'S' apenas o local de trabalho com a maior data de início

update bethadba.locais_mov
   set principal = 'N';

update bethadba.locais_mov
   set principal = 'S'
 where dt_inicial = (select max(lm.dt_inicial)
                       from bethadba.locais_mov as lm
                      where lm.i_funcionarios = i_funcionarios
                        and lm.i_entidades = i_entidades);