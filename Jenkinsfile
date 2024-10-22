pipeline {
    agent any
    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker-compose build'
                }
            }
        }

        stage('Terraform Init and Apply') {
            steps {
                script {
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding', 
                        credentialsId: 'aws-credentials'
                    ]]) {
                        sh '''
                            terraform init
                            terraform apply -auto-approve
                        '''
                    }
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

        stage('Destroy Infrastructure') {
            steps {
                script {
                    input message: 'Do you want to destroy the infrastructure?', ok: 'Destroy'
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding', 
                        credentialsId: 'aws-credentials'
                    ]]) {
                        sh '''
                            terraform destroy -auto-approve
                        '''
                    }
                }
            }
        }

        stage('Deploy with Ansible') {
            steps {
                script {
                    withCredentials([sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'SSH_KEY_PATH', usernameVariable: 'SSH_USER')]) {
                        sh '''
                            ansible-playbook -i inventory \
                            --private-key "$SSH_KEY_PATH" \
                            playbook.yml
                        '''
                    }
                }
            }
        }

        stage('Approval') {
            steps {
                script {
                    input message: 'Do you want to proceed with further actions?', ok: 'Proceed'
                }
            }
        }
    }
}
