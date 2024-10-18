pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                script {
                    sh 'docker-compose build'
                }
            }
        }
        stage('Test') {
            steps {
                script {
                    sh 'docker-compose run --rm my-app npm test'
                }
            }
        }
        stage('Push Images to Docker Hub') {
            steps {
                script {
                    echo "Building the Docker image..."
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-repo', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        sh "echo $PASS | docker login -u $USER --password-stdin"
                        sh "docker-compose push"
                    }
                }
            }
        }
        stage('Approval') {
            steps {
                script {
                    // Manual approval step
                    input message: 'Do you want to proceed with deployment?', ok: 'Deploy'
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    withCredentials([sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'SSH_KEY_PATH', usernameVariable: 'SSH_USER')]) {
                        sh '''
                            ansible-playbook -i inventory \
                            --private-key $SSH_KEY_PATH \
                            playbook.yml
                        '''
                    }
                }
            }
        }
    }
}
