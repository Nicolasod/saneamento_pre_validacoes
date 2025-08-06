-- VALIDAÇÃO 73
-- Verifica dependente grau de parentesco(3-Pai/Mãe/4-Avô/Avó/12-Bisavô/Bisavó) com data de nascimento MAIOR que a do seu responsável

select dependentes.i_pessoas as resp,
       p.dt_nascimento as dt_resp, 
       dependentes.i_dependentes as dep, 
       pdep.dt_nascimento as dt_dep, 
       dependentes.grau as grau_p
  from bethadba.dependentes
  join bethadba.pessoas_fisicas as p
    on (p.i_pessoas = dependentes.i_pessoas)
  join bethadba.pessoas_fisicas as pdep
    on (pdep.i_pessoas = dependentes.i_dependentes)
 where dependentes.grau in (3,4,12)
   and pdep.dt_nascimento > p.dt_nascimento;


-- CORREÇÃO

update bethadba.pessoas_fisicas as pdep
  set dt_nascimento = p.dt_nascimento
  from bethadba.dependentes
  join bethadba.pessoas_fisicas as p
   on (p.i_pessoas = dependentes.i_pessoas)
 where pdep.i_pessoas = dependentes.i_dependentes
  and dependentes.grau in (3,4,12)
  and pdep.dt_nascimento > p.dt_nascimento;