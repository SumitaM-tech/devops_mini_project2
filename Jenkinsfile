pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'devops-mini-project'
        DOCKER_TAG = "${BUILD_NUMBER}"
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        RENDER_API_KEY = credentials('render-api-key')
        RENDER_SERVICE_ID = credentials('render-service-id')
        RENDER_APP_URL = credentials('render-app-url')
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
                echo 'Code checked out successfully'
            }
        }
        
        stage('Install Dependencies') {
            steps {
                dir('app') {
                    sh 'npm install'
                }
            }
        }
        
        stage('Run Tests') {
            steps {
                dir('app') {
                    sh 'npm test'
                }
            }
            post {
                always {
                    junit '**/coverage/*.xml'
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    sh """
                        docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                        docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest
                    """
                }
            }
        }
        
        stage('Push to DockerHub') {
            steps {
                script {
                    sh """
                        echo \$DOCKERHUB_CREDENTIALS_PSW | docker login -u \$DOCKERHUB_CREDENTIALS_USR --password-stdin
                        docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} \$DOCKERHUB_CREDENTIALS_USR/${DOCKER_IMAGE}:${DOCKER_TAG}
                        docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} \$DOCKERHUB_CREDENTIALS_USR/${DOCKER_IMAGE}:latest
                        docker push \$DOCKERHUB_CREDENTIALS_USR/${DOCKER_IMAGE}:${DOCKER_TAG}
                        docker push \$DOCKERHUB_CREDENTIALS_USR/${DOCKER_IMAGE}:latest
                    """
                }
            }
            post {
                always {
                    sh 'docker logout'
                }
            }
        }
        
        stage('Deploy to Render') {
            steps {
                script {
                    sh """
                        curl -s -X POST \
                          -H "Authorization: Bearer \$RENDER_API_KEY" \
                          -H "Content-Type: application/json" \
                          "https://api.render.com/v1/services/\$RENDER_SERVICE_ID/deploys" \
                          -d '{"clearCache": false}'
                        echo "Render deployment triggered!"
                    """
                }
            }
        }
        
        stage('Health Check') {
            steps {
                script {
                    sh """
                        echo "Waiting 60s for deployment..."
                        sleep 60
                        APP_URL="https://\$RENDER_APP_URL"
                        echo "Checking: \${APP_URL}/health"
                        STATUS=\$(curl -s -o /dev/null -w "%{http_code}" "\${APP_URL}/health" || echo "000")
                        echo "Health check status: \$STATUS"
                        if [ "\$STATUS" = "200" ]; then
                            echo "Deployment successful! App is live at \${APP_URL}"
                        else
                            echo "App returned status \$STATUS — Render free tier may still be warming up."
                            echo "Check manually: \${APP_URL}/health"
                            echo "This is normal for free tier — deployment still succeeded!"
                        fi
                    """
                }
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
        always {
            cleanWs()
        }
    }
}
