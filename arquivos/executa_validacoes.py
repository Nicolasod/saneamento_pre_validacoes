import os
import pyodbc
from datetime import datetime

# Configuração da conexão para Sybase (ajuste conforme necessário)
conn = pyodbc.connect(r"FILEDSN=c:\Scripts\saneamento_pre_validacoes\arquivos\conexao.dsn")
cursor = conn.cursor()

pasta = r'c:\Scripts\saneamento_pre_validacoes'
pasta_saida = r'c:\Scripts\saneamento_pre_validacoes\arquivos\saneamentoValidado'

# Lista todos os arquivos .sql na pasta
arquivos_sql = [f for f in os.listdir(pasta) if f.endswith('.sql')]

# Gera nome único para o arquivo de correção usando data e hora
nome_arquivo = f"correcao_{datetime.now().strftime('%Y%m%d_%H%M%S')}.sql"
arquivo_saida = os.path.join(pasta_saida, nome_arquivo)

with open(arquivo_saida, 'w', encoding='utf-8') as fout:
    for arquivo in arquivos_sql:
        with open(os.path.join(pasta, arquivo), encoding='utf-8') as f:
            conteudo = f.read()

        # Separar o SELECT e o script de correção
        partes = conteudo.split('-- CORREÇÃO', maxsplit=1)
        if len(partes) < 2:
            continue  # pula arquivos sem padrão esperado

        # Pega o bloco SELECT até o primeiro ponto e vírgula
        select_sql = ''
        dentro_select = False
        for linha in partes[0].splitlines():
            if linha.strip().lower().startswith('select'):
                dentro_select = True
            if dentro_select:
                select_sql += linha + '\n'
            if dentro_select and ';' in linha:
                break
        select_sql = select_sql.strip().rstrip(';')
        if not select_sql:
            continue

        # Executa o SELECT
        try:
            cursor.execute(select_sql)
            resultado = cursor.fetchall()
            if resultado:
                # Escreve o nome da validação (nome do arquivo sem extensão)
                fout.write(f"{os.path.splitext(arquivo)[0]}\n\n")
                # Escreve o bloco de correção
                correcao_sql = partes[1].strip()
                fout.write(correcao_sql + '\n\n')
        except Exception as e:
            print(f"Erro ao processar {arquivo}: {e}")

cursor.close()
conn.close()