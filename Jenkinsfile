pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'johnsonbv/ecommerce-app'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
    }

    stages {
        stage('Clone Repo') {
            steps {
                git branch: 'main', url: 'https://github.com/JohnsonBV/Java-E-commerce-Backend.git'
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE:$IMAGE_TAG .'
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'johnsonbv-creds-id',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {
                    sh """
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push $DOCKER_IMAGE:$IMAGE_TAG
                    """
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    sh """
                        aws eks update-kubeconfig --region us-east-2 --name ecommerce-eks
                        kubectl set image deployment/ecommerce-app ecommerce-container=$DOCKER_IMAGE:$IMAGE_TAG
                    """
                }
            }
        }

        stage('Test kubectl') {
            steps {
                sh 'kubectl get nodes'
            }
        }
    }

    post {
        success {
            echo "✅ Deployed successfully to EKS!"
        }
        failure {
            echo "❌ Deployment failed."
        }
    }
}
