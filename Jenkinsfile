pipeline {
    agent any

    environment {
        IMAGE_NAME = "sindhu/medicalstore"
        ECR_REPO   = "944731154859.dkr.ecr.us-east-1.amazonaws.com/ecr-repo"
        REGION     = "us-east-1"
        AWS_CLI    = "aws"
        TERRAFORM  = "terraform"
    }

    stages {

        stage('Clone Repository') {
            steps {
                echo '📦 Cloning repository...'
                git branch: 'main', url: 'https://github.com/SindhuManga/MedicalStore.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo '🐳 Building Docker image...'
                sh """
                    docker build -t ${IMAGE_NAME}:latest .
                """
            }
        }

        stage('Push to AWS ECR') {
            steps {
                echo '🚀 Pushing image to AWS ECR...'
                withCredentials([usernamePassword(credentialsId: 'aws-creds',
                                                  usernameVariable: 'AWS_ACCESS_KEY_ID',
                                                  passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {

                    sh """
                        export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
                        export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}

                        ${AWS_CLI} ecr get-login-password --region ${REGION} \
                        | docker login --username AWS --password-stdin ${ECR_REPO}

                        docker tag ${IMAGE_NAME}:latest ${ECR_REPO}:latest
                        docker push ${ECR_REPO}:latest
                    """
                }
            }
        }

        stage('Deploy with Terraform') {
            steps {
                echo '🏗️ Deploying EC2 instance and running Docker container...'
                withCredentials([usernamePassword(credentialsId: 'aws-creds',
                                                  usernameVariable: 'AWS_ACCESS_KEY_ID',
                                                  passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {

                    dir('terraform') {
                        sh """
                            export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
                            export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}

                            ${TERRAFORM} init
                            ${TERRAFORM} apply -auto-approve
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            echo '✅ Docker image pushed, EC2 deployed, and application running!'
        }
        failure {
            echo '❌ Build or deployment failed!'
        }
    }
}
