# Backend User Task API

## 🚀 Descripción

Este proyecto es una prueba técnica en Ruby on Rails para evaluar habilidades en desarrollo de APIs RESTful y GraphQL, pruebas automatizadas, dockerización y buenas prácticas de backend.

## 📦 Stack Tecnológico

- **Ruby on Rails** - Framework web principal
- **PostgreSQL** - Base de datos relacional
- **GraphQL** (gem `graphql`) - API GraphQL
- **RSpec** - Framework de testing
- **Docker / Docker Compose** - Contenedorización
- **Jenkins** - Integración continua

## 📁 Estructura del Proyecto

```
app/
├── controllers/api/         # Controladores REST
├── graphql/                 # Tipos y mutations GraphQL
├── models/                  # Modelos ActiveRecord
config/                      # Configuración de Rails
db/migrate/                  # Migraciones
spec/                        # Pruebas con RSpec
.docker/                     # Configuración de Docker
.jenkins/                    # Jenkinsfile o scripts CI
```

## 🐳 Instalación y Ejecución con Docker

### Prerrequisitos

- Docker
- Docker Compose

### Pasos para ejecutar el proyecto

1. **Clonar el repositorio**

   ```bash
   git clone <url-del-repositorio>
   cd backend-user-task-api
   ```

2. **Construir las imágenes de Docker**

   ```bash
   docker-compose build
   ```

3. **Configurar variables de entorno**

   ```bash
   cp .env.example .env
   # Editar .env con las configuraciones necesarias
   ```

4. **Migraciones de base de datos**

   Las migraciones se ejecutan automáticamente al iniciar el servicio web gracias al comando `rails db:prepare` configurado en el docker-compose.yml.

5. **Cargar datos de prueba (opcional)**

   Si deseas cargar datos de prueba iniciales, puedes ejecutar:

   ```bash
   docker-compose run --rm web rails db:seed
   ```

6. **Iniciar los servicios**
   ```bash
   docker-compose up
   ```

La API estará disponible en `http://localhost:3000`.

### Servicios disponibles

- **API REST**: `http://localhost:3000/api/`
- **GraphQL Playground**: `http://localhost:3000/graphiql`
- **PostgreSQL**: `localhost:5432`

## 🧪 Ejecución de Pruebas

### Ejecutar todas las pruebas

```bash
docker-compose run test
```

### Ejecutar pruebas específicas

```bash
# Pruebas de un archivo específico
docker-compose run --rm test bundle exec rspec spec/models/user_spec.rb

# Pruebas de un directorio
docker-compose run --rm test bundle exec rspec spec/models

```

### Generar reporte de cobertura

```bash
docker-compose run --rm test bundle exec rspec --format html --out coverage/index.html
```

## 🏗️ Arquitectura y Decisiones Técnicas

### Arquitectura General

El proyecto sigue una arquitectura **MVC (Model-View-Controller)** con Rails, implementando tanto APIs REST como GraphQL para diferentes casos de uso.

#### Componentes Principales:

1. **Modelos (Models)**

   - Utilizan ActiveRecord para la gestión de datos
   - Implementan validaciones y relaciones

2. **Controladores REST (Controllers)**

   - Ubicados en `app/controllers/api/`
   - Siguen convenciones RESTful
   - Manejan autenticación y autorización
   - Responden en formato JSON

3. **API GraphQL**
   - Esquema definido en `app/graphql/`
   - Tipos, queries y mutations organizadas
   - Resolvers para consultas complejas

### Decisiones Técnicas

#### Base de Datos

- **PostgreSQL**: Elegida por su robustez, características avanzadas y soporte completo de Rails
- **Migraciones**: Control de versiones del esquema de base de datos
- **Índices**: Optimización para consultas frecuentes

#### API Design

- **REST + GraphQL**:
  - REST para operaciones CRUD simples
  - GraphQL para consultas complejas y relaciones anidadas

#### Pruebas

- **RSpec**: Framework de testing principal
- **Factory Bot**: Generación de datos de prueba
- **Tipos de pruebas**:
  - Unitarias (modelos)
  - Request specs (APIs)

#### Dockerización

- **Docker Compose**: Orquestación de servicios
- **Volúmenes**: Persistencia de datos y desarrollo
- **Variables de entorno**: Configuración flexible

#### Seguridad

- **Autenticación**: JWT tokens
- **CORS**: Configurado para frontends

### Patrones Implementados

- **Serializers**: Formateo consistente de respuestas JSON
- **Decorators**: Presentación de datos

## 🔧 Comandos Útiles

### Desarrollo

```bash
# Acceder al contenedor
docker-compose run --rm web bash

# Una vez dentro del contenedor, ejecutamos:
bundle exec rails db:migrate:status

# Consola de Rails
docker-compose run --rm web bundle exec rails console

```

## 📚 Documentación Adicional

- **API REST**: Documentación disponible en `http://localhost:3000/api-docs/index.html`
- **GraphQL**: Explorar schema en `http://localhost:3000/graphiql`
