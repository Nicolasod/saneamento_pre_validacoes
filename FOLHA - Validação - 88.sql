-- VALIDAÇÃO 88
-- Dependentes com a data de inicio de dependencia menor que a data de nascimento

select dependentes.i_pessoas as pessoa, 
       dependentes.i_dependentes as dep, 
       dependentes.dt_ini_depende as dt_ini_dep, 
       pessoas_fisicas.dt_nascimento as dt_nasc
  from bethadba.dependentes,
  	   bethadba.pessoas_fisicas
 where dependentes.i_dependentes = pessoas_fisicas.i_pessoas
   and dependentes.dt_ini_depende is not null
   and dependentes.dt_ini_depende < pessoas_fisicas.dt_nascimento;


-- CORREÇÃO
-- Atualiza a data de início de dependência para ser igual à data de nascimento do dependente se a data de início de dependência for menor que a data de nascimento

update bethadba.dependentes
   set dt_ini_depende = dt_nascimento
  from bethadba.dependentes d,
       bethadba.pessoas_fisicas pf
 where d.i_dependentes = pf.i_pessoas
   and d.dt_ini_depende < pf.dt_nascimento;