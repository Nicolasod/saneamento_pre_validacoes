-- VALIDAÇÃO 05  
-- Verifica se o dependente está cadastrado como 10 - OUTROS

select i_dependentes,
       i_pessoas,
       mot_ini_depende 
  from bethadba.dependentes,
 where grau = 10;


-- CORREÇÃO
-- Atualiza o grau do dependente para 5 (OUTROS) se o motivo de início do dependente não for um dos motivos válidos ou for nulo

update bethadba.dependentes 
   set grau = 5 
 where grau = 10 
   and mot_ini_depende not in (1,2,3,4,7,8) 
    or mot_ini_depende is null;

update bethadba.dependentes 
   set grau = 2 
 where grau = 10 
   and mot_ini_depende in (7);

update bethadba.dependentes 
   set grau = 8 
 where grau = 10 
   and mot_ini_depende in (2);

update bethadba.dependentes 
   set grau = 1 
 where grau = 10 
   and mot_ini_depende in (1,2,3,4);