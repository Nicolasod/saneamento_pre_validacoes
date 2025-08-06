-- VALIDAÇÃO 119
-- O autônomo deve ter serviço lançado para todos os meses compreendidos pelo lançamento de variáveis

select v.i_entidades,
       v.i_funcionarios,
       isnull(count((hs.dt_alteracoes)),0) as quantidade,
       v.dt_inicial,
       v.dt_final,
       mes = if DATEDIFF(month, v.dt_inicial, v.dt_final) = 0 then
       			if v.dt_inicial = v.dt_final then
       				1
       			else
       				0
       			endif
             else
                DATEDIFF(month, v.dt_inicial, v.dt_final)
             endif
  from bethadba.variaveis v
  join bethadba.hist_salariais hs
    on v.i_entidades = hs.i_entidades
   and v.i_funcionarios = hs.i_funcionarios
  join bethadba.funcionarios f
    on hs.i_entidades = f.i_entidades
   and hs.i_funcionarios = f.i_funcionarios
 where isnull(date(hs.dt_alteracoes),GETDATE()) between v.dt_inicial and v.dt_final
   and f.tipo_func = 'A'
   and f.conselheiro_tutelar = 'N'
 group by hs.i_entidades, hs.i_funcionarios,v.dt_inicial, v.dt_final, v.i_funcionarios, v.i_entidades
having quantidade < mes
 order by v.i_entidades,v.i_funcionarios;


-- CORREÇÃO
-- Excluir as variáveis que não possuem serviço lançado para todos os meses compreendidos pelo lançamento de variáveis

delete from bethadba.variaveis
 where exists (select 1  
                 from bethadba.hist_salariais hs  
                 join bethadba.funcionarios f  
                   on hs.i_entidades = f.i_entidades  
                  and hs.i_funcionarios = f.i_funcionarios  
                where hs.i_entidades = variaveis.i_entidades  
                  and hs.i_funcionarios = variaveis.i_funcionarios  
                  and ISNULL(date(hs.dt_alteracoes), GETDATE()) between variaveis.dt_inicial and variaveis.dt_final  
                  and f.tipo_func = 'A'  
                  and f.conselheiro_tutelar = 'N'  
                group by hs.i_entidades, hs.i_funcionarios 
               having ISNULL(count((hs.dt_alteracoes)), 0) < (case when DATEDIFF(month, variaveis.dt_inicial, variaveis.dt_final) = 0 then   
                                                                 case when variaveis.dt_inicial = variaveis.dt_final then
                                                                     1
                                                                 else
                                                                     0  
                                                                 end  
                                                              else
                                                                 DATEDIFF(month, variaveis.dt_inicial, variaveis.dt_final)  
                                                              end));