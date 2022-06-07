pipeline {
    agent any
    environment {
        AWS_ID = credentials('AWS-ID')
        ART_USER = credentials('ART_USER')
        ART_PASS = credentials('ART_PASS')
        ART_URL = credentials('ART_URL')
        ART_MAVEN_REPO = credentials('ART_MAVEN_REPO')
    }
    stages {

        stage('Pull Github repo') {
            steps {
                git url: 'https://github.com/FourSeasons-Smoothstack/aline-underwriter-microservice-tk.git', branch: 'develop', credentialsId: 'github-creds-tk'
            }
        }

        // stage('Scan Sonarqube'){
        //     steps{
        //         withSonarQubeEnv(installationName: 'SQ-TK'){
        //             sh "git submodule update --init --recursive"
        //             sh "mvn clean package sonar:sonar -DskipTests"
        //         }
        //     }
        // }

        // stage('Quality Gate'){
        //     steps{
        //         timeout(time: 2, unit: 'MINUTES'){
        //             waitForQualityGate abortPipeline: true
        //         }
        //     }
        // }

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
                    sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${AWS_ID}.dkr.ecr.us-east-1.amazonaws.com"
                }
            }
        }

        stage('Deploy to AWS ECR'){
            steps{
                script {
                    sh "docker tag aline-underwriter-tk:latest ${AWS_ID}.dkr.ecr.us-east-1.amazonaws.com/aline-underwriter-tk:latest"
                    sh "docker push ${AWS_ID}.dkr.ecr.us-east-1.amazonaws.com/aline-underwriter-tk:latest"
                    sh "docker system prune -af"
                    sh "docker volume prune -f"
                }
            }
        }

        stage('Deploy to Artifactory') {
            steps {
                script {
                    sh "curl -X PUT -u ${ART_USER}:${ART_PASS} -T underwriter-microservice/target/*.jar 'http://ec2-50-18-84-74.us-west-1.compute.amazonaws.com:8081/artifactory/${ART_MAVEN_REPO}/aline-underwriter.jar'"
                    sh "docker login -u ${ART_USER} -p ${ART_PASS} http://ec2-50-18-84-74.us-west-1.compute.amazonaws.com:8081"
                    sh "docker push http://ec2-50-18-84-74.us-west-1.compute.amazonaws.com:8082/docker-local/aline-underwriter:latest"
                }
            }
        }
    }
}

