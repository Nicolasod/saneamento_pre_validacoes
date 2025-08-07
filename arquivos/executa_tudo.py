import subprocess
import os
import pyodbc

# Caminhos
pasta_saida = r'c:\Scripts\saneamento_pre_validacoes\arquivos\saneamentoValidado'
script_validacoes = r'c:\Scripts\saneamento_pre_validacoes\arquivos\executa_validacoes.py'
dsn_path = r"FILEDSN=c:\Scripts\saneamento_pre_validacoes\arquivos\conexao.dsn"

# 1. Executa o script de validações
subprocess.run(['python', script_validacoes], check=True)

# 2. Descobre o arquivo de correção mais recente
arquivos = [os.path.join(pasta_saida, f) for f in os.listdir(pasta_saida) if f.startswith('correcao_') and f.endswith('.sql')]
arquivo_correcoes = max(arquivos, key=os.path.getmtime)

# 3. Executa o arquivo de correção no banco
with open(arquivo_correcoes, encoding='utf-8') as f:
    comandos = f.read()

conn = pyodbc.connect(dsn_path)
cursor = conn.cursor()

print(f"Executando correções do arquivo: {arquivo_correcoes}\n")

comando_buffer = ""
titulo_correção = ""
for linha in comandos.splitlines():
    if linha.strip().startswith('-- '):
        if comando_buffer.strip():
            try:
                cursor.execute(comando_buffer)
                conn.commit()
                print(f"Correção executada: {titulo_correção}")
            except Exception as e:
                conn.rollback()
                print(f"Erro ao executar correção {titulo_correção}:\n{e}\nComando SQL:\n{comando_buffer}\n")
        titulo_correção = linha.strip()
        comando_buffer = ""
    else:
        comando_buffer += linha + '\n'

# Executa o último comando, se houver
if comando_buffer.strip():
    try:
        cursor.execute(comando_buffer)
        conn.commit()
        print(f"Correção executada: {titulo_correção}")
    except Exception as e:
        conn.rollback()
        print(f"Erro ao executar correção {titulo_correção}:\n{e}\nComando SQL:\n{comando_buffer}\n")

cursor.close()
conn.close()