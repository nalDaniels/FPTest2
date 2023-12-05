pipeline {
    agent { label 'DockerAgent' } 
    environment {
        DOCKERHUB_CREDENTIALS = credentials('djtoler-dockerhub')
        PATH = "/home/ubuntu/.nvm/versions/node/v10.24.1/bin:$PATH"
    }
    
    stages {

        stage('TestFrontend') {
            steps {
                sh '''#!/bin/bash
                  docker images -f "dangling=true" -q | xargs docker rmi
                  rm -rf Deployment9
                  npx kill-port 3000
                  git clone https://github.com/djtoler/Deployment9
                  cd Dep9/frontend
                  npm install --save-dev @babel/plugin-proposal-private-property-in-object
                  npm ci
                  nohup npm start > frontend_start.txt &
                  sleep 30
                  grep "Compiled successfully!" frontend_start.txt
              '''
            }
        }

        stage('BuildFrontend') {
            steps {
              dir('Dep9/frontend') {
                sh 'pwd'
                sh 'docker build --no-cache -t djtoler/dp9frontend .'
              }
            }
        }

        stage('BuildTestBackend') {
            steps {
              dir('Dep9/backend') {
                sh '''#!/bin/bash
                docker stop be_test || true
                docker rm be_test || true
                sudo docker build --no-cache -t djtoler/dp9backend .
                docker run -d -p 8000:8000 --name be_test djtoler/dp9backend
                IP=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=DP9_Docker_Instance" --query "Reservations[*].Instances[*].PublicIpAddress" --output text)
                export IP
                echo "IP is $IP"
                curl -f http://$IP:8000/api/products/
                docker stop be_test
                docker rm be_test
              '''
              }
            }
        }
        
        stage('DockerHubLogin') {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | sudo docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }
        
        stage('PushFrontendDockerHub') {
            steps {
              dir('Dep9/frontend') {
                sh 'sudo docker push djtoler/dp9frontend'
                sh 'docker rmi djtoler/dp9frontend:latest'
              }
            }
        }

        stage('PushBackendDockerHub') {
            steps {
              dir('Dep9/backend') {
                sh 'sudo docker push djtoler/dp9backend'
                sh 'docker rmi djtoler/dp9backend:latest'
              }
            }
        }
        
    }
