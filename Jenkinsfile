pipeline {
    agent any

    stages {

        stage('SonarQube Analysis') {
            steps{
                script{
                    withSonarQubeEnv('sonarqube') {
                    sh "mvn clean verify sonar:sonar -Dsonar.projectKey=Jenkins -Dmaven.test.skip=true "
                    }
                }
            }
        }

        stage('Build') {
            steps {
                sh "git submodule update --init --recursive"
                sh "mvn clean package -DskipTests"
                sh "docker build -t aline-underwriter-tk ."
            }
        }
        
        stage('Logging into AWS ECR') {
            steps {
                withAWS(credentials: 'AWS-TK', region: 'us-west-1') {
                    sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 032797834308.dkr.ecr.us-east-1.amazonaws.com"
                }
            }
        }

        stage('Deploy to AWS ECR'){
            steps{
                script {
                    sh "docker tag aline-underwriter-tk:latest 032797834308.dkr.ecr.us-east-1.amazonaws.com/aline-underwriter-tk:latest"
                    sh "docker push 032797834308.dkr.ecr.us-east-1.amazonaws.com/aline-underwriter-tk:latest"
                }
            }
        }
    }
}

