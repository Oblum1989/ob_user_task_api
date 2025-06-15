# Backend User Task API

## 🚀 Descripción

Este proyecto es una prueba técnica en Ruby on Rails para evaluar habilidades en desarrollo de APIs RESTful y GraphQL, pruebas automatizadas, dockerización y buenas prácticas de backend.

## 📦 Stack Tecnológico

- Ruby on Rails
- PostgreSQL
- GraphQL (gem `graphql`)
- RSpec
- Docker / Docker Compose
- Jenkins (CI)
- AWS (despliegue opcional)

## 📁 Estructura del Proyecto

```
app/
├── controllers/api/         # Controladores REST
├── graphql/                 # Tipos y mutations GraphQL
├── models/                  # Modelos ActiveRecord

config/                      # Configuración de Rails
db/migrate/                 # Migraciones
spec/                       # Pruebas con RSpec
.docker/                    # Configuración de Docker
.jenkins/                   # Jenkinsfile o scripts CI
```

## 🐳 Uso con Docker

```bash
docker-compose build
docker-compose up
```

La API estará disponible en `http://localhost:3000`.

## 🧪 Pruebas

```bash
docker-compose run web bundle exec rspec
```