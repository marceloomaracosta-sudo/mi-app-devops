#!/bin/bash

# Actualizar sistema
sudo apt update -y

# Instalar Docker
sudo apt install -y docker.io

# Iniciar Docker
sudo systemctl start docker
sudo systemctl enable docker

# Permisos
sudo usermod -aG docker ubuntu

# Ir al home
cd /home/ubuntu

# Crear app simple Flask
cat <<EOF > app.py
from flask import Flask
app = Flask(__name__)

@app.route('/')
def home():
    return "Hola Marcelo, tu app DevOps funciona 🚀"

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
EOF

# Crear Dockerfile
cat <<EOF > Dockerfile
FROM python:3.9-slim
WORKDIR /app
COPY app.py .
RUN pip install flask
CMD ["python", "app.py"]
EOF

# Build imagen
sudo docker build -t mi-app .

# Ejecutar contenedor
sudo docker run -d -p 80:5000 mi-app