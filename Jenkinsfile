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
        stage('Fetch EC2 Public IP') {
            steps {
                script {
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding', 
                        credentialsId: 'aws-credentials'
                    ]]) {
                        // Fetch the public IP from Terraform output
                        env.EC2_PUBLIC_IP = sh(script: 'terraform output -raw ec2_public_ip', returnStdout: true).trim()
                        echo "EC2 Public IP: ${env.EC2_PUBLIC_IP}"
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
        stage('Approval') {
            steps {
                script {
                    input message: 'Do you want to proceed with deployment?', ok: 'Deploy'
                }
            }
        }
        stage('Deploy with Ansible') {
            steps {
                script {
                    withCredentials([sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'SSH_KEY_PATH', usernameVariable: 'SSH_USER')]) {
                        sh '''
                           echo "[docker_server]" > inventory
                           echo "${EC2_PUBLIC_IP}" >> inventory
                           ansible-playbook -i inventory \
                           --private-key "$SSH_KEY_PATH" \
                           playbook.yml
                        '''
                    }
                }
            }
        }
        stage('Destroy Infrastructure Approval') {
            steps {
                script {
                    input message: 'Do you want to destroy the infrastructure?', ok: 'Destroy'
                }
            }
        }
        stage('Destroy Infrastructure') {
            steps {
                script {
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
    }
}
