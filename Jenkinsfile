pipeline {
    agent { label 'DockerAgent' } 
    environment {
        DOCKERHUB_CREDENTIALS = credentials('djtoler-dockerhub')
        PATH = "/home/ubuntu/.nvm/versions/node/v10.24.1/bin:$PATH"
    }
    
    stages {
        stage('Build') {
            steps {
              dir('Dep9/frontend') {
                sh 'pwd'
                sh 'docker rmi djtoler/be_final3:latest'
                sh 'docker rmi djtoler/fe_final3:latest'
                sh 'docker build --no-cache -t djtoler/be_final3 .'
                sh 'docker build --no-cache -t djtoler/fe_final3 .'
              }
            }
        }
        
        stage('Login') {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | sudo docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }
        
        stage('Push') {
            steps {
              dir('Dep9/frontend') {
                sh 'sudo docker push djtoler/be_final3d'
                sh 'sudo docker push djtoler/fe_final3d'
              }
            }
        }

        stage('Compose') {
            steps {
              dir('Dep9/frontend') {
                sh 'sudo docker compose up'
              }
            }
        }
    }
