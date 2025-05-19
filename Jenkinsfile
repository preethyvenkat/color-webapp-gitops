pipeline {
  agent any

  environment {
    ECR_REPO = "your-account-id.dkr.ecr.us-east-1.amazonaws.com/your-repo"  // replace with your ECR repo URL
    IMAGE_TAG = "latest"  // or dynamically set this (e.g. with a build number)
    AWS_REGION = "us-east-1"
    MANIFEST_REPO = "git@github.com:your-org/your-gitops-repo.git"  // your GitOps repo SSH URL
  }

  stages {
    stage('Login to Amazon ECR') {
      steps {
        withCredentials([
          usernamePassword(
            credentialsId: 'aws-creds',
            usernameVariable: 'AWS_ACCESS_KEY_ID',
            passwordVariable: 'AWS_SECRET_ACCESS_KEY'
          )
        ]) {
          sh '''
            mkdir -p ~/.aws
            echo "[default]" > ~/.aws/credentials
            echo "aws_access_key_id=$AWS_ACCESS_KEY_ID" >> ~/.aws/credentials
            echo "aws_secret_access_key=$AWS_SECRET_ACCESS_KEY" >> ~/.aws/credentials
            echo "[default]" > ~/.aws/config
            echo "region=$AWS_REGION" >> ~/.aws/config

            aws ecr get-login-password --region $AWS_REGION | \
              docker login --username AWS --password-stdin ${ECR_REPO%%/*}
          '''
        }
      }
    }

    stage('Build and Push Multi-Arch Docker Image') {
      steps {
        sh '''
          docker buildx create --use --name mybuilder || true
          docker buildx inspect --bootstrap

          docker buildx build \
            --platform linux/amd64,linux/arm64 \
            -t $ECR_REPO:$IMAGE_TAG \
            --push .
        '''
      }
    }

    stage('Update Kubernetes Manifest in GitOps Repo') {
      steps {
        sshagent (credentials: ['github-creds']) {
          sh '''
            set -e
            rm -rf manifests
            git clone $MANIFEST_REPO manifests
            cd manifests

            # Update the image tag in deployment.yaml
            sed -i "s|image: .*|image: $ECR_REPO:$IMAGE_TAG|" deployment.yaml

            git config user.email "jenkins@example.com"
            git config user.name "Jenkins"

            if git diff --quiet; then
              echo "No changes to commit"
            else
              git add deployment.yaml
              git commit -m "Update image to $IMAGE_TAG"
               # Pull remote changes to avoid non-fast-forward error
              git pull --rebase origin main
              git push origin main
            fi
          '''
        }
      }
    }
  }
}
