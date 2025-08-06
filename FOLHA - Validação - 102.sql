-- VALIDAÇÃO 102
-- Pessoas com nome das ruas cadastrados sem codigo das ruas

select i_pessoas, nome_rua
  from bethadba.pessoas_enderecos
 where nome_rua is not null
   and i_ruas is null;


-- CORREÇÃO
-- Insere os logradouros na tabela ruas e atualiza o código das ruas na tabela pessoas_enderecos

begin
  declare w_pessoa integer;
  declare w_nome_rua varchar(120);
  declare w_conta integer;
 
  set w_conta = 472; -- Informar aqui o último código de logradouro cadastrado no sistema
 
  llloop: for ll as cursor2 dynamic scroll cursor for
	  select i_pessoas,
           nome_rua
      from bethadba.pessoas_enderecos
     where nome_rua is not null and i_ruas is null
  do
    set w_conta = w_conta + 1;
    set w_pessoa = i_pessoas;
    set w_nome_rua = nome_rua;

    insert into bethadba.ruas (i_ruas, i_ruas_ini, i_ruas_fim, i_cidades, nome, tipo, cep. epigrafe, lei, zona_fiscal, extensao, dia_vcto, i_sefaz) 
    values (w_conta, null, null, null, w_nome_rua, 57, null, null, null, null, null, null);

    update bethadba.pessoas_enderecos
       set i_ruas = w_conta
     where i_ruas is null
       and i_pessoas = w_pessoa
       and nome_rua = w_nome_rua;
  end for;
end;