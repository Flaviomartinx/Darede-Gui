# Usa uma imagem base Python
FROM nginx:latest

# Copia o arquivo de configuração principal do NGINX
COPY /app/nginx.conf /NextGenAWS/Docker/app/nginx.conf

# Atualiza a imagem com os pacotes
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install nginx -y

# Expõe a porta em que a aplicação irá rodar
EXPOSE 443

# Define o comando padrão para iniciar a aplicação
CMD ["nginx", "-g", "daemon off;"]