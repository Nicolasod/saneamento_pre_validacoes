-- VALIDAÇÃO 07  
-- Verifica dependente grau de parentesco(1-Filho(a)/6-Neto/8-Menor Tutelado/11-Bisneto) com data de nascimento MENOR que a do seu responsável.

select dependentes.i_pessoas resp ,
       p.dt_nascimento dt_resp, 
       dependentes.i_dependentes dep, 
       pdep.dt_nascimento dt_dep, 
       dependentes.grau grau_p
  from bethadba.dependentes 
  join bethadba.pessoas_fisicas p
    on (p.i_pessoas = dependentes.i_pessoas)
  join bethadba.pessoas_fisicas pdep
    on (pdep.i_pessoas = dependentes.i_dependentes)
 where dependentes.grau in (1, 6, 8, 11)
   and pdep.dt_nascimento < p.dt_nascimento;


-- CORREÇÃO
-- Atualiza a data de nascimento dos dependentes com grau de parentesco 1, 6, 8 ou 11 para ser igual à do responsável se a data de nascimento do dependente for menor que a do responsável

update bethadba.dependentes 
  join bethadba.pessoas_fisicas p
    on (p.i_pessoas = dependentes.i_pessoas)
  join bethadba.pessoas_fisicas pdep
    on (pdep.i_pessoas = dependentes.i_dependentes)
   set pdep.dt_nascimento = p.dt_nascimento
 where dependentes.grau in (1, 6, 8, 11)
   and pdep.dt_nascimento < p.dt_nascimento;