pipeline {
    agent any

    stages {

        stage('Pull Github repo') {
            steps {
                git url: 'https://github.com/FourSeasons-Smoothstack/aline-underwriter-microservice-tk.git', branch: 'develop', credentialsId: 'github-creds-tk'
            }
        }

        stage('Scan Sonarqube'){
            steps{
                withSonarQubeEnv(installationName: 'SQ-dw'){
                    sh "git submodule update --init --recursive"
                    sh "mvn clean package sonar:sonar -DskipTests"
                }
            }
        }

        stage('Quality Gate'){
            steps{
                timeout(time: 2, unit: 'MINUTES'){
                    waitForQualityGate abortPipeline: true
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
                    sh "docker system prune -af"
                    sh "docker volume prune -f"
                }
            }
        }
    }
}

