-- VALIDAÇÃO 02
-- Busca as pessoas com data de nascimento maior que data de admissão

select i_funcionarios,
       i_entidades,
       f.dt_admissao, f.dt_admissao as admissao,
       pf.dt_nascimento, pf.dt_nascimento as datanascimento,
       pf.i_pessoas,
       pf.i_pessoas as pessoas,
       p.nome
  from bethadba.funcionarios f
 inner join bethadba.pessoas_fisicas pf
    on (f.i_pessoas = pf.i_pessoas)
 inner join bethadba.pessoas p
    on (f.i_pessoas = p.i_pessoas)
 where pf.dt_nascimento > f.dt_admissao;


-- CORREÇÃO
-- Atualiza a data de nascimento das pessoas para ser igual à data de admissão se a data de nascimento for maior que a data de admissão

update bethadba.pessoas_fisicas
   set PF.dt_nascimento = F.dt_admissao
  from bethadba.funcionarios as F
  left join bethadba.pessoas_fisicas as PF
    on PF.i_pessoas = F.i_pessoas
 where PF.dt_nascimento > F.dt_admissao;