-- VALIDAÇÃO 06  
-- Pessoas com data de nascimento maior que data de dependência

select d.i_dependentes,
       pf.dt_nascimento,
       d.dt_ini_depende 
  from bethadba.dependentes d 
  join bethadba.pessoas_fisicas pf
    on (d.i_dependentes = pf.i_pessoas)
 where dt_nascimento > dt_ini_depende;


-- CORREÇÃO
-- Atualiza a data de início da dependência para ser igual à data de nascimento do dependente se a data de nascimento for maior que a data de início da dependência
                
update bethadba.dependentes a 
  join bethadba.pessoas_fisicas b
    on (a.i_dependentes = b.i_pessoas)
   set a.dt_ini_depende = b.dt_nascimento
 where b.dt_nascimento > dt_ini_depende;