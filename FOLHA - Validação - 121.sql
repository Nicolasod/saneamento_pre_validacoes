-- VALIDAÇÃO 121
-- Verifica locais de avaliação sem números de sala

select i_pessoas,
       i_locais_aval
  from bethadba.locais_aval
 where num_sala is null
    or num_sala = ' ';


-- CORREÇÃO
-- Atualiza o número da sala para 1

update bethadba.locais_aval 
   set num_sala = 1
 where i_pessoas in (select i_pessoas
                       from bethadba.locais_aval
                      where num_sala is null
                         or num_sala = ' ')
   and num_sala is null
    or num_sala = ' ';