FROM python:3.9-slim

# Evita logs innecesarios y mejora rendimiento
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Copiamos requirements primero (mejor cache)
COPY ../app/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Copiamos el resto del código
COPY ../app/ .

CMD ["python", "app.py"]