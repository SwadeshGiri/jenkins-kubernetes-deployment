pipeline {
  agent any

  environment {
    dockerImageName = "swadeshgiri/react-app"
    registryCredential = "dockerhub-credentials"
    kubeconfigCredential = "kubeconfig-credentials-id"
  }

  stages {

    stage('Build Docker Image') {
      steps {
        script {
          echo "Building Docker image..."
          dockerImage = docker.build("${dockerImageName}:latest")
        }
      }
    }

    stage('Push Image to Docker Hub') {
      steps {
        script {
          echo "Logging in and pushing image to Docker Hub..."
          docker.withRegistry('https://index.docker.io/v1/', registryCredential) {
            sh """
              echo "Tagging image..."
              docker tag ${dockerImageName}:latest ${dockerImageName}:latest
              
              echo "Pushing image to Docker Hub..."
              docker push ${dockerImageName}:latest
            """
          }
        }
      }
    }

    stage('Deploy to Kubernetes') {
      steps {
        script {
          echo "Deploying the latest image to Kubernetes..."
          withKubeConfig([credentialsId: kubeconfigCredential]) {
            sh 'kubectl apply -f deployment.yaml'
            sh 'kubectl apply -f service.yaml'
          }
        }
      }
    }
  }

  post {
    success {
      echo "✅ Deployment completed successfully!"
    }
    failure {
      echo "❌ Pipeline failed. Check the logs above for details."
    }
  }
}
