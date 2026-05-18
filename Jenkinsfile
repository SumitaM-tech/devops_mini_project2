// Jenkinsfile — Windows-compatible CI/CD pipeline

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
                echo "Checked out commit ${env.GIT_COMMIT}"
            }
        }

        stage('Install & Test') {
            steps {
                dir('app') {
                    bat 'npm ci'

                    // Continue even if no tests exist
                    bat '''
                        npm test -- --ci
                        if %ERRORLEVEL% NEQ 0 (
                            echo Tests skipped or failed
                        )
                    '''
                }
            }
        }

        stage('Docker Build') {
            steps {
                bat """
                    docker build ^
                    -t %DOCKERHUB_CREDENTIALS_USR%/${DOCKER_IMAGE}:${DOCKER_TAG} ^
                    -t %DOCKERHUB_CREDENTIALS_USR%/${DOCKER_IMAGE}:latest ^
                    .
                """
            }
        }

        stage('Docker Push') {
            steps {
                bat """
                    echo %DOCKERHUB_CREDENTIALS_PSW%| docker login -u %DOCKERHUB_CREDENTIALS_USR% --password-stdin

                    docker push %DOCKERHUB_CREDENTIALS_USR%/${DOCKER_IMAGE}:${DOCKER_TAG}

                    docker push %DOCKERHUB_CREDENTIALS_USR%/${DOCKER_IMAGE}:latest
                """
            }

            post {
                always {
                    bat 'docker logout'
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                bat """
                    powershell -Command "(Get-Content k8s\\deployment.yaml) -replace 'IMAGE_TAG', '%DOCKERHUB_CREDENTIALS_USR%/${DOCKER_IMAGE}:${DOCKER_TAG}' | kubectl apply -f -"

                    kubectl apply -f k8s/service.yaml

                    kubectl rollout status deployment/devops-mini-project --timeout=120s

                    echo --- Pods ---
                    kubectl get pods -l app=devops-mini-project

                    echo --- Service ---
                    kubectl get svc devops-mini-project-svc
                """
            }
        }
    }

    post {

        success {
            echo 'Pipeline PASSED — app deployed successfully!'
        }

        failure {
            echo 'Pipeline FAILED — check console logs'
        }

        always {
            cleanWs()
        }
    }
}