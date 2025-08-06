-- VALIDAÇÃO 89
-- Verificar dependentes com data de casamento menor que a data de nascimento do dependente

select dependentes.i_pessoas as pessoa,
       dependentes.i_dependentes as dep, 
       dependentes.dt_casamento as dt_casam, 
       pessoas_fisicas.dt_nascimento as dt_nasc
  from bethadba.dependentes, bethadba.pessoas_fisicas
 where dependentes.i_dependentes = pessoas_fisicas.i_pessoas
   and dependentes.dt_casamento is not null
   and dependentes.dt_casamento < pessoas_fisicas.dt_nascimento;


-- CORREÇÃO
-- Atualiza a data de casamento dos dependentes para nulo se a data de casamento for menor que a data de nascimento do dependente

update bethadba.dependentes
   set dt_casamento = null
  from bethadba.dependentes d,
       bethadba.pessoas_fisicas pf
 where d.i_dependentes = pf.i_pessoas
   and d.dt_casamento < pf.dt_nascimento;