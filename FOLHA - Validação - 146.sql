-- VALIDAÇÃO 146
-- Validar se o CPF é numérico na tabela hist_pessoas_fis

select i_pessoas ,
       dt_alteracoes ,
       isnumeric(cpf) as validacao 
  from bethadba.hist_pessoas_fis hpf 
 where cpf is not null
   and cpf <> ''
   and validacao = 0;


-- CORREÇÃO
-- Atualizar o campo CPF para NULL onde o CPF não for numérico na tabela hist_pessoas_fis

update bethadba.hist_pessoas_fis
   set cpf = (select right('0000000000' + cast(row_number() over (order by i_pessoas) as varchar(11)), 11)
                from (select i_pessoas
                        from bethadba.hist_pessoas_fis
                       where cpf is not null
                         and cpf <> ''
                         and isnumeric(cpf) = 0) as sub
               where sub.i_pessoas = hist_pessoas_fis.i_pessoas)
 where cpf is not null
   and cpf <> ''
   and isnumeric(cpf) = 0
   and not exists (select 1
                     from bethadba.hist_pessoas_fis h2
                    where h2.cpf = right('0000000000' + cast(row_number() over (order by hist_pessoas_fis.i_pessoas) as varchar(11)), 11)
                      and h2.i_pessoas <> hist_pessoas_fis.i_pessoas);