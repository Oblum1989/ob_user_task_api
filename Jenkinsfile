pipeline {
  agent any

  environment {
    DOCKER_IMAGE = 'ob-user-task-api'
    DOCKER_TAG = "${env.BUILD_NUMBER}"
    RAILS_ENV = 'test'
  }

  stages {
    stage('Preparar Entorno') {
      steps {
        sh '''
          gem install bundler
          bundle install --jobs=4 --retry=3
        '''
      }
    }

    stage('Ejecutar Pruebas') {
      steps {
        sh '''
          bundle exec rails db:create db:schema:load
          bundle exec rspec
        '''
      }
    }

    stage('Construir Imagen Docker') {
      steps {
        script {
          docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
        }
      }
    }
  }

  post {
    success {
      echo 'Pipeline completado exitosamente!'
    }
    failure {
      echo 'Pipeline falló! Revisa los logs para más detalles.'
    }
  }
}
