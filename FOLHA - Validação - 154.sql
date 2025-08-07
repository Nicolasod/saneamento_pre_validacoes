-- VALIDAÇÃO 154
-- Dependente sem data de inicio

select i_pessoas, 
       i_dependentes 
  from bethadba.dependentes d
 where dt_ini_depende is null;


-- CORREÇÃO
-- Atualiza a data de nascimento do dependente como data de inicio do dependente

update bethadba.dependentes d
   set dt_ini_depende = pf.dt_nascimento
  from bethadba.pessoas_fisicas  pf
 where d.dt_ini_depende is null
   and d.i_dependentes = pf.i_pessoas;