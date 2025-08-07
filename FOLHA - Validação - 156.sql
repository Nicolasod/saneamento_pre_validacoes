-- VALIDAÇÃO 156
-- Dependente com mais de uma configuração de IRRF

select i_dependentes,
	     count(i_dependentes) as total
  from (select distinct i_dependentes,
  						 dep_irrf
  		    from bethadba.dependentes_func df) as thd
 group by i_dependentes having total > 1;

-- CORREÇÃO
-- Deletar duplicidade de dependentes com mais de uma configuração de IRRF quando o dependente for o mesmo

delete from bethadba.dependentes_func
 where rowid in (select df.rowid
                   from (select i_dependentes,
                                dep_irrf,
                                row_number() over (partition by i_dependentes order by rowid) as rn
                           from bethadba.dependentes_func) df
                  where df.rn > 1
                    and df.i_dependentes in (select i_dependentes
                                               from (select i_dependentes,
                                                            count(i_dependentes) as total
                                                       from (select distinct i_dependentes,
                                                                             dep_irrf
                                                               from bethadba.dependentes_func) as thd
                                                      group by i_dependentes
                                                     having total > 1)));