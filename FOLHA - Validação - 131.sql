/*
 -- VALIDA��O 131
 * Data de altera��o do hist�rico n�o pode ser menor que a data de nascimento
 */

select i_pessoas from bethadba.hist_pessoas_fis where dt_nascimento > dt_alteracoes
          
/*
 -- CORRE��O
 */
                
update bethadba.hist_pessoas_fis
set dt_alteracoes = DATEADD(year, 18, dt_nascimento)
where dt_nascimento > dt_alteracoes;
