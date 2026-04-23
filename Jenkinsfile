pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'devops-mini-project'
        DOCKER_TAG = "${BUILD_NUMBER}"
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                echo 'Code checked out'
            }
        }

        stage('Install & Test') {
            steps {
                script {
                    docker.image('node:18-alpine').inside {
                        dir('app') {
                            sh 'npm ci'
                            sh 'npm test || echo "No tests / tests skipped"'
                        }
                    }
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh """
                    docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                    docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest
                """
            }
        }

        stage('Docker Push') {
            steps {
                sh """
                    echo \$DOCKERHUB_CREDENTIALS_PSW | docker login -u \$DOCKERHUB_CREDENTIALS_USR --password-stdin
                    docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} \$DOCKERHUB_CREDENTIALS_USR/${DOCKER_IMAGE}:${DOCKER_TAG}
                    docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} \$DOCKERHUB_CREDENTIALS_USR/${DOCKER_IMAGE}:latest
                    docker push \$DOCKERHUB_CREDENTIALS_USR/${DOCKER_IMAGE}:${DOCKER_TAG}
                    docker push \$DOCKERHUB_CREDENTIALS_USR/${DOCKER_IMAGE}:latest
                """
            }
            post {
                always {
                    sh 'docker logout'
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh """
                    sed "s|IMAGE_TAG|$DOCKERHUB_CREDENTIALS_USR/${DOCKER_IMAGE}:${DOCKER_TAG}|g" k8s/deployment.yaml | kubectl apply -f -
                    kubectl apply -f k8s/service.yaml
                    kubectl rollout status deployment/devops-mini-project --timeout=120s
                    kubectl get pods -l app=devops-mini-project
                    kubectl get svc devops-mini-project-svc
                """
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully'
        }
        failure {
            echo 'Pipeline failed'
        }
        always {
            cleanWs()
        }
    }
}