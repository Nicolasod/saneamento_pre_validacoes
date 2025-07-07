/*
 -- VALIDA��O 106
 * Pessoas com certid�o de nasicmento maior que 32 caracteres
 */

select 
    i_pessoas,
    num_reg
    from bethadba.pessoas_fis_compl
    where length(num_reg)  > 32

/*
 -- CORRE��O
 */

update bethadba.pessoas_fis_compl
    set num_reg = null
    where length(num_reg) > 32
