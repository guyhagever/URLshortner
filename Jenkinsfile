pipeline {
  agent any
  environment {
    REGISTRY = 'docker.io'
    DOCKERHUB_CREDS = credentials('dockerhub')  
    IMAGE_NAMESPACE = "${DOCKERHUB_CREDS_USR}"   
    COMMIT = "${env.GIT_COMMIT?.take(12) ?: 'dev'}"
    IMAGE_API = "${REGISTRY}/${IMAGE_NAMESPACE}/urlshort-api"
    IMAGE_WORKER = "${REGISTRY}/${IMAGE_NAMESPACE}/urlshort-worker"
  }
  options { timestamps() }
  triggers { pollSCM('* * * * *') } 

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Build (TypeScript compile)') {
      agent { docker { image 'node:20-alpine' } }
      steps {
        sh '''
          apk add --no-cache bash
          corepack enable || true
          npm i -g pnpm
          cd apps/api && pnpm install && pnpm run build
          cd ../worker && pnpm install && pnpm run build
        '''
      }
    }

    stage('Docker Login') {
      steps {
        sh '''
          echo "$DOCKERHUB_CREDS_PSW" | docker login -u "$DOCKERHUB_CREDS_USR" --password-stdin $REGISTRY
        '''
      }
    }

    stage('Build & Push API Image') {
      steps {
        sh '''
          docker build -t ${IMAGE_API}:${COMMIT} -t ${IMAGE_API}:latest -f apps/api/Dockerfile .
          docker push ${IMAGE_API}:${COMMIT}
          docker push ${IMAGE_API}:latest
        '''
      }
    }

    stage('Build & Push Worker Image') {
      steps {
        sh '''
          docker build -t ${IMAGE_WORKER}:${COMMIT} -t ${IMAGE_WORKER}:latest -f apps/worker/Dockerfile .
          docker push ${IMAGE_WORKER}:${COMMIT}
          docker push ${IMAGE_WORKER}:latest
        '''
      }
    }

    stage('(Later) Deploy to K8s') {
      when { expression { return false } }
      steps {
        echo 'Kubernetes deployment is handled in Phase 3 via Helm from Jenkins.'
      }
    }
  }

  post {
    always {
      sh 'docker logout || true'
    }
  }
}
