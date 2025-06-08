pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'your-dockerhub-username/ecommerce-app'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        AWS_REGION = 'us-east-2'
        EKS_CLUSTER = 'ecommerce-eks'
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/your-username/ecommerce-app.git', branch: 'main'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE:$IMAGE_TAG .'
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'johnsonbv-creds-id',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push $DOCKER_IMAGE:$IMAGE_TAG
                    '''
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'aws-lambda-creds',
                    usernameVariable: 'AWS_ACCESS_KEY_ID',
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                )]) {
                    sh '''
                        export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                        export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                        aws eks update-kubeconfig --region $AWS_REGION --name $EKS_CLUSTER

                        kubectl set image deployment/ecommerce-app ecommerce-container=$DOCKER_IMAGE:$IMAGE_TAG
                    '''
                }
            }
        }

        stage('Test kubectl') {
            steps {
                sh 'kubectl get pods -n default'
            }
        }
    }

    post {
        failure {
            echo "❌ Deployment failed."
        }
        success {
            echo "✅ Deployment succeeded."
        }
    }
}
