pipeline {
  agent any

  environment {
    AWS_REGION = "us-east-1"
    ECR_REPO = "141409473062.dkr.ecr.us-east-1.amazonaws.com/color-webapp"
    IMAGE_TAG = "v${BUILD_NUMBER}"
    MANIFEST_REPO = "git@github.com:preethyvenkat/color-webapp-gitops.git"
  }

  stages {
  /* stage('Install AWS CLI & Docker CLI') {
    steps {
      sh '''
        # Install AWS CLI (ARM64) if not already installed
        if ! command -v aws &> /dev/null; then
          curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
          unzip -q -o awscliv2.zip
          ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli
        else
         echo "AWS CLI already installed. Updating..."
         curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
         unzip -q -o awscliv2.zip
         ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update
        fi

       # Print versions for verification
       aws --version
       docker --version
      '''
    }
   }*/
   stage('Verify Tools') {
     steps {
     sh '''
       echo "Checking CLI tools..."
       echo $PATH && which aws
       docker --version
       kubectl version --client
       eksctl version
     '''
    } 
   }
   stage('Build Docker Image') {
      steps {
        sh 'docker build -t $ECR_REPO:$IMAGE_TAG .'
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

    stage('Push Docker Image to ECR') {
      steps {
        sh 'docker push $ECR_REPO:$IMAGE_TAG'
      }
    }

    stage('Update Kubernetes Manifest in GitOps Repo') {
      steps {
        sshagent (credentials: ['github-ssh']) {
          sh '''
            rm -rf manifests
            git clone $MANIFEST_REPO manifests
            cd manifests

            sed -i "s|image: .*|image: $ECR_REPO:$IMAGE_TAG|" deployment.yaml

            git config user.email "jenkins@example.com"
            git config user.name "Jenkins"

            git add deployment.yaml
            git commit -m "Update image to $IMAGE_TAG"
            git push origin main
          '''
        }
      }
    }
  }
}
