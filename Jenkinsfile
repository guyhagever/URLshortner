pipeline {
  agent any
  stages {
    stage('Build & Test') {
      steps { sh 'echo Building && npm install && npm test' }
    }
    stage('Docker Build & Push') {
      steps { sh 'echo Build & Push with Kaniko (placeholder)' }
    }
    stage('Deploy Helm') {
      steps { sh 'echo helm upgrade --install (placeholder)' }
    }
  }
}
