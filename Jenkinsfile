pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh "git submodule update --init --recursive"
                sh "mvn clean package -DskipTests"
                sh "docker build . -t aline-banking-tk:aline-underwriter"
            }
        }
        
        stage('Logging into AWS ECR') {
            steps {
                withAWS(credentials: 'AWS-TK', region: 'us-west-1') {
                    sh "aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/c0j0y9o1"
                }
            }
        }

        stage('Deploy to AWS ECR'){
            steps{
                script {
                    sh "docker tag aline-banking-tk:aline-underwriter public.ecr.aws/c0j0y9o1/aline-banking-tk:aline-underwriter"
                    sh "docker push public.ecr.aws/c0j0y9o1/aline-banking-tk:aline-underwriter"
                }
            }
        }
    }
}

