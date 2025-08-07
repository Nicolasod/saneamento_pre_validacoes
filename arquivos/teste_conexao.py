import pyodbc

try:
    conn = pyodbc.connect(r"FILEDSN=c:\Scripts\saneamento_pre_validacoes\arquivos\conexao.dsn")
    cursor = conn.cursor()
    cursor.execute("SELECT 1")
    resultado = cursor.fetchone()
    if resultado:
        print("Conexão bem-sucedida!")
    else:
        print("Conexão estabelecida, mas sem retorno do banco.")
    cursor.close()
    conn.close()
except Exception as e:
    print(f"Erro ao conectar: {e}")