-- VALIDAÇÃO 127
-- Configuração Rais sem controle de ponto

select rc.campo
  from bethadba.rais_campos rc
 where exists (select 1
                 from bethadba.rais_eventos re
                where re.campo = rc.campo)
   and rc.cnpj is null;


-- CORREÇÃO
-- Atualiza os campos CNPJ que estão nulos para 0 para que não sejam considerados na validação e não gere erro de validação.

update bethadba.bethadba.rais_campos
   set CNPJ = right('000000000000' || cast((row_number() over) as varchar(12)), 12) || '91'
 where CNPJ is null;