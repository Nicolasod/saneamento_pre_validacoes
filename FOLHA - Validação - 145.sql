-- VALIDAÇÃO 145
-- Histórico de pessoa fisica sem data de nascimento

select i_pessoas
  from bethadba.hist_pessoas_fis
 where dt_nascimento is null
 order by i_pessoas;


-- CORREÇÃO
-- Atualiza a data de nascimento no histórico de pessoa física com a data de nascimento da pessoa física caso esteja nula no histórico de pessoa física
-- Caso a data de nascimento esteja nula na pessoa física, não será atualizado no histórico de pessoa física também e permanecerá nulo no histórico de pessoa física

begin	
	declare w_i_pessoas integer;
	declare w_dt_nascimento timestamp;
	
    llLoop: for ll as cur_01 dynamic scroll cursor for
		select hpf.i_pessoas as pessoas,
			   pf.dt_nascimento as nascimento
		  from bethadba.hist_pessoas_fis hpf
		  join bethadba.pessoas_fisicas pf
		    on (hpf.i_pessoas = pf.i_pessoas)
		 where hpf.dt_nascimento is null
    do
 		set w_i_pessoas = pessoas;
 		set w_dt_nascimento = nascimento;

  update bethadba.hist_pessoas_fis 
	 set dt_nascimento = w_dt_nascimento
   where dt_nascimento is null
	 and i_pessoas = w_i_pessoas;
    end for;
end;