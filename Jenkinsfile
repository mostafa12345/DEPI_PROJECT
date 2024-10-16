pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                script {
                    // Build the Docker images using docker-compose
                    sh 'docker-compose build'
                }
            }
        }
        stage('Test') {
            steps {
                script {
                    // Run tests using Docker Compose (fixing app service name to match docker-compose.yml)
                    sh 'docker-compose run --rm my-app npm test'
                }
            }
        }
        stage('Push Images to Docker Hub') {
            steps {
                script {
                    echo "Building the Docker image..."

                    // Use Jenkins credentials for Docker Hub login
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-repo', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        // Log in to Docker Hub
                        sh "echo $PASS | docker login -u $USER --password-stdin"

                        // Push the image to Docker Hub
                        sh "docker-compose push"
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    // Deploy the application using docker-compose
                    sh 'docker-compose up -d'
                }
            }
        }

    }
}
