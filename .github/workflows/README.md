
---

### **Documentação de Integração do GitHub Actions com ECS**

#### **1. Introdução**
Este documento fornece uma visão geral detalhada sobre como configurar e executar um fluxo de trabalho do GitHub Actions para realizar build, push de imagem Docker para o Docker Hub, e deploy em uma definição de tarefa no ECS (Elastic Container Service) da AWS.

#### **2. Workflow GitHub Actions**
- **Objetivo**: Automatizar o build, teste e deploy de uma aplicação Docker em um ambiente de produção usando GitHub Actions.
- **Estrutura do Workflow**:

  ```yaml
  name: CI/CD Pipeline

  on:
    push:
      branches:
        - main

  jobs:
    build:
      runs-on: ubuntu-latest

      steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Set up Docker
        uses: docker/setup-buildx-action@v2

      - name: Login to Docker Hub
        run: |
          echo $DOCKER_PASSWORD | docker login -u $DOCKER_USER --password-stdin

      - name: Build Docker image
        run: docker build -t $DOCKER_USER/repository:latest .

      - name: Push Docker image
        run: docker push $DOCKER_USER/repository:latest

    deploy:
      runs-on: ubuntu-latest

      steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Set up AWS CLI
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1  # Ajustar conforme sua região da AWS

      - name: Deploy to ECS
        run: |
          aws ecs update-service --cluster my-cluster --service my-service --force-new-deployment
  ```

- **Passos para configurar a Workflow**:
  1. **Definir Secrets no GitHub**: 
     - Crie variáveis secretas em `Settings > Secrets` no repositório GitHub para:
       - `DOCKER_USER`: Nome de usuário do Docker Hub.
       - `DOCKER_PASSWORD`: Senha do Docker Hub.
       - `AWS_ACCESS_KEY_ID`: ID da chave de acesso AWS.
       - `AWS_SECRET_ACCESS_KEY`: Chave secreta da AWS.
  2. **Inicie o Workflow**:
     - Sempre que você fizer um push para a branch `main`, o workflow será executado. Ele fará o build da imagem Docker, a enviará para o Docker Hub e, por fim, atualizará o serviço ECS com a nova imagem.

#### **3. ECS Describe-Task-Definition**
- **Objetivo**: Configurar uma definição de tarefa no ECS para que a aplicação Docker seja executada em um cluster ECS.
- **Exemplo de Task Definition**:

  ```json
  {
    "family": "my-task-family",
    "executionRoleArn": "arn:aws:iam::your-account-id:role/ecsTaskExecutionRole",
    "networkMode": "awsvpc",
    "containerDefinitions": [
      {
        "name": "my-container",
        "image": "docker_user/repository:latest",
        "memory": 512,
        "cpu": 256,
        "portMappings": [
          {
            "containerPort": 80,
            "hostPort": 8080,
            "protocol": "tcp"
          }
        ],
        "essential": true,
        "environment": [
          {
            "name": "ENV_VAR_1",
            "value": "value1"
          },
          {
            "name": "ENV_VAR_2",
            "value": "value2"
          }
        ]
      }
    ]
  }
  ```

- **Explicação**:
  - **family**: Identificador único para a definição de tarefa.
  - **executionRoleArn**: ARN da role que possui permissões suficientes para executar tarefas ECS.
  - **networkMode**: `awsvpc` é usado para suportar VPC para conectividade de rede.
  - **containerDefinitions**:
    - `name`: Nome do container.
    - `image`: Imagem Docker no Docker Hub.
    - `memory`: Quantidade de memória alocada para o container.
    - `cpu`: Quantidade de CPU alocada para o container.
    - `portMappings`: Mapeamento de portas do container para o host.
    - `essential`: Booleano que define se o container é essencial para o funcionamento da tarefa.
    - `environment`: Variáveis de ambiente que o container precisa para funcionar corretamente.

#### **4. Integração Workflow com ECS**
- **Como funciona o processo**:
  1. **Quando você faz um push na branch `main`**:
     - O workflow é acionado automaticamente.
     - **Etapa Build**:
       - O GitHub Actions configura o ambiente, define as variáveis secretas (`DOCKER_USER`, `DOCKER_PASSWORD`, `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`) necessárias para autenticar e interagir com o Docker Hub e AWS.
       - A imagem Docker é construída e enviada para o Docker Hub com os comandos:
         ```bash
         docker build -t $DOCKER_USER/repository:latest .
         docker push $DOCKER_USER/repository:latest
         ```
     - **Etapa Deploy**:
       - A AWS CLI é configurada com as credenciais e região do usuário para acessar e interagir com o ECS.
       - O comando `aws ecs update-service --cluster my-cluster --service my-service --force-new-deployment` é executado para forçar uma nova implantação do serviço ECS com a nova imagem Docker.

#### **5. Conclusão**
Este documento forneceu uma visão abrangente de como você pode configurar um fluxo de trabalho do GitHub Actions para automatizar o build, teste e deploy de uma aplicação Docker em um cluster ECS da AWS. A integração eficaz entre o GitHub Actions e o ECS permite uma entrega contínua rápida e segura de software, promovendo eficiência e minimizando a possibilidade de erros humanos.

Certifique-se de ajustar as configurações e o fluxo de trabalho conforme as necessidades específicas da sua aplicação e infraestrutura AWS.

---