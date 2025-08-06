-- VALIDAÇÃO 84
-- Pessoas fisicas com data de nascimento nula 

select f.i_pessoas as pessoa
  from bethadba.pessoas_fisicas f
  join bethadba.dependentes d
    on (d.i_pessoas = f.i_pessoas)
 where f.dt_nascimento is null
 group by f.i_pessoas;


-- CORREÇÃO
-- Atualiza a data de nascimento das pessoas fisicas com base na data de alteração mais recente do histórico de pessoas, subtraindo 18 anos.

update bethadba.pessoas_fisicas pf
   set pf.dt_nascimento = DATEADD(year, -18, max(hpf.dt_alteracoes))
  from bethadba.dependentes d
  join bethadba.hist_pessoas_fis hpf
    on hpf.i_pessoas = d.i_pessoas
 where pf.i_pessoas = d.i_pessoas
   and pf.dt_nascimento is null
 group by pf.i_pessoas;