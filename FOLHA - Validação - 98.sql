/*
 -- VALIDA��O 98
 * Telefone com mais de 11 caracteres na lota��o fisica
 */

select 
                i_entidades,
                i_locais_trab,
                fone,
                length(fone) as quantidade
            from 
                bethadba.locais_trab
            where 
                quantidade > 11

/*
 -- CORRE��O
 */

update
    bethadba.locais_trab
set
    fone = right(trim(replace(replace(replace(fone,'-',''),'(',''),')','')),8)
where
    length(fone) > 9;

