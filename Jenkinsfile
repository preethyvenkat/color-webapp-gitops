pipeline {
  agent any

  environment {
    AWS_REGION = "us-east-1"
    ECR_REPO = "141409473062.dkr.ecr.us-east-1.amazonaws.com/color-webapp"
    IMAGE_TAG = "v${BUILD_NUMBER}"
    MANIFEST_REPO = "git@github.com:preethyvenkat/color-webapp-gitops.git"
  }

  stages {

    stage('Build Docker Image') {
      steps {
        script {
          sh "docker build -t $ECR_REPO:$IMAGE_TAG ."
        }
      }
    }

    stage('Login to Amazon ECR') {
      steps {
        withCredentials([
          usernamePassword(
            credentialsId: 'aws-creds',
            usernameVariable: 'AWS_ACCESS_KEY_ID',
            passwordVariable: 'AWS_SECRET_ACCESS_KEY'
          )
        ]) {
          script {
            sh """
              aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
              aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
              aws configure set region $AWS_REGION

              aws ecr get-login-password --region $AWS_REGION | \
              docker login --username AWS --password-stdin ${ECR_REPO.split('/')[0]}
            """
          }
        }
      }
    }

    stage('Push Docker Image to ECR') {
      steps {
        script {
          sh "docker push $ECR_REPO:$IMAGE_TAG"
        }
      }
    }

    stage('Update Kubernetes Manifest in GitOps Repo') {
      steps {
        sshagent (credentials: ['github-ssh']) {
          script {
            sh """
              git clone $MANIFEST_REPO manifests
              cd manifests

              sed -i "s|image: .*|image: $ECR_REPO:$IMAGE_TAG|" deployment.yaml

              git config user.email "jenkins@example.com"
              git config user.name "Jenkins"

              git add deployment.yaml
              git commit -m "Update image to $IMAGE_TAG"
              git push origin main
            """
          }
        }
      }
    }
  }
}
