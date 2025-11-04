pipeline {
  agent any

  environment {
    DOCKER_BUILDKIT = "0"  // Disable BuildKit to fix push issues
    dockerImageName = "swadeshgiri/react-app"
    registryCredential = "dockerhub-credentials"
    kubeconfigCredential = "kubeconfig-credentials-id"
  }

  stages {

    stage('Build Docker Image') {
      steps {
        script {
          echo "🚀 Building Docker image..."
          dockerImage = docker.build("${dockerImageName}:latest")
        }
      }
    }

    stage('Push Image to Docker Hub') {
      steps {
        script {
          echo "📦 Logging in and pushing image to Docker Hub..."
          docker.withRegistry('https://index.docker.io/v1/', registryCredential) {
            retry(3) {
              sh """
                echo "Tagging image..."
                docker tag ${dockerImageName}:latest ${dockerImageName}:latest

                echo "Pushing image to Docker Hub (attempt)..."
                docker push ${dockerImageName}:latest
              """
            }
          }
        }
      }
    }

    stage('Deploy to Kubernetes') {
      steps {
        script {
          echo "🚢 Deploying the latest image to Kubernetes..."
          withKubeConfig([credentialsId: kubeconfigCredential]) {
            sh '''
              kubectl apply -f deployment.yaml
              kubectl apply -f service.yaml
              echo "✅ Kubernetes deployment applied successfully!"
            '''
          }
        }
      }
    }
  }

  post {
    success {
      echo "✅ Pipeline completed successfully — new version deployed!"
    }
    failure {
      echo "❌ Pipeline failed. Check the logs above for details."
    }
  }
}
