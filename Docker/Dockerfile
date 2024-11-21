# Usa uma imagem base Python
FROM python:3.9-slim

# Copia o arquivo de configuração principal do NGINX
COPY /site /etc/nginx/sites-available/

# Define variáveis para os diretórios da aplicação e do repositório
ENV app=/NextGenAWS/Docker/app
ENV site=/NextGenAWS/Docker/site

# Copia o arquivo de configuração principal do NGINX
COPY /app/nginx.conf /NextGenAWS/Docker/app/nginx.conf

# Atualiza a imagem com os pacotes
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install nginx -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Instala o Flask e outras dependências de Python
COPY /apps/requirements.txt /apps/requirements.txt
RUN pip install --no-cache-dir -r /apps/requirements.txt

# Expõe a porta em que a aplicação irá rodar
EXPOSE 5000 443

# Comando para iniciar o servidor NGINX e a aplicação Flask
CMD service nginx start && python $REPO_DIR/app.py