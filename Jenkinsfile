pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIALS = credentials('djtoler-dockerhub')
    }
    
    stages {
        stage('SetHost') {
            steps {
                sh '''#!/bin/bash
                pwd
                //IP=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=FPJ_Docker_Agent" --query "Reservations[*].Instances[*].PublicIpAddress" --output text)
                //echo $IP
                //cd react/src && sed -i "s|const URL = "";|const URL = 'http://$IP:8000';|" App.js && cat App.js
                //pwd
                //cd service && sed -i "s|const URL = process.env.REACT_APP_BACKEND_URL;|const URL = 'http://$IP:8000';|" api.js
                pwd
                '''
            }
        }
        
        stage('Build') {
            agent { label 'DockerAgent' } 
            steps {
              dir('docker') {
                sh '''#!/bin/bash
                pwd
                docker rmi djtoler/be_final3:latest || true
                docker rmi djtoler/fe_final3:latest || true
                cd /home/ubuntu/docker_agent/workspace/finalproject_main/docker/front && pwd && ls && docker build --no-cache -t djtoler/fe_final3 .
                cd /home/ubuntu/docker_agent/workspace/finalproject_main/docker/back && pwd && ls && docker build --no-cache -t djtoler/be_final3 .
              '''
              }
            }
        }
        
        stage('Login') {
            agent { label 'DockerAgent' } 
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | sudo docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }

        stage('Push') {
            agent { label 'DockerAgent' } 
            steps {
                sh 'sudo docker push djtoler/be_final3'
                sh 'sudo docker push djtoler/fe_final3'
            }
        }

        stage('Compose') {
            agent { label 'DockerAgent' } 
            steps {
                sh 'pwd && ls'
                sh 'cd docker && pwd && ls'
                sh 'cd docker && docker compose up'
            }
        }
    }
}
