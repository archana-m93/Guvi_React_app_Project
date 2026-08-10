pipeline {
    agent any

    parameters {
        choice(
            name: 'ENVIRONMENT',
            choices: ['DEV', 'PROD'],
            description: 'Select the environment to build and deploy'
        )
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    if (params.ENVIRONMENT == 'DEV') {
                        sh 'docker build -t archanamr/dev:v1 .'
                    } else {
                        sh 'docker build -t archanamr/prod:v1 .'
                    }
                }
            }
        }

        stage('Docker Hub Login') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-creds',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )
                ]) {
                    sh '''
                        echo "$DOCKER_PASSWORD" | docker login \
                        -u "$DOCKER_USER" \
                        --password-stdin
                    '''
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    if (params.ENVIRONMENT == 'DEV') {
                        sh 'docker push archanamr/dev:v1'
                    } else {
                        sh 'docker push archanamr/prod:v1'
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {

                    if (params.ENVIRONMENT == 'DEV') {

                        sh '''
                            docker compose pull dev
                            docker rm -f devops-app 2>/dev/null || true
                            docker compose up -d dev
                        '''

                    } else {

                        sh '''
                            docker compose pull prod
                            docker rm -f devops2-app 2>/dev/null || true
                            docker compose up -d prod
                        '''

                    }
                }
            }
        }
    }

    post {
        success {
            echo "Deployment to ${params.ENVIRONMENT} completed successfully!"
        }

        failure {
            echo "Deployment to ${params.ENVIRONMENT} failed."
        }
    }
}

