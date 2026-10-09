pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = 'docker.io'
        DOCKER_IMAGE = 'studentapp'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
        KUBECONFIG = credentials('kubeconfig')
        AWS_REGION = 'us-west-2'
        EKS_CLUSTER_NAME = 'studentapp-eks-cluster'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Application') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Unit Tests') {
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                }
            }
        }

        stage('Tag Docker Image') {
            steps {
                sh "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest"
            }
        }

        stage('Push Docker Image') {
            when {
                anyOf {
                    branch 'main'
                    branch 'master'
                }
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-registry-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin ${DOCKER_REGISTRY}
                        docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                        docker push ${DOCKER_IMAGE}:latest
                        docker logout
                    """
                }
            }
        }

        stage('Configure kubectl') {
            when {
                anyOf {
                    branch 'main'
                    branch 'master'
                }
            }
            steps {
                sh """
                    aws eks update-kubeconfig --name ${EKS_CLUSTER_NAME} --region ${AWS_REGION}
                    kubectl get nodes
                """
            }
        }

        stage('Deploy to Kubernetes') {
            when {
                anyOf {
                    branch 'main'
                    branch 'master'
                }
            }
            steps {
                sh """
                    kubectl apply -f k8s/namespace.yaml
                    kubectl apply -f k8s/mysql-secret.yaml
                    kubectl apply -f k8s/mysql-configmap.yaml
                    kubectl apply -f k8s/mysql-init-configmap.yaml
                    kubectl apply -f k8s/mysql-deployment.yaml
                    kubectl apply -f k8s/studentapp-configmap.yaml
                    kubectl set image deployment/studentapp studentapp=${DOCKER_IMAGE}:${DOCKER_TAG} -n studentapp || kubectl apply -f k8s/studentapp-deployment.yaml
                """
            }
        }

        stage('Verify Deployment') {
            when {
                anyOf {
                    branch 'main'
                    branch 'master'
                }
            }
            steps {
                sh """
                    sleep 30
                    kubectl get pods -n studentapp
                    kubectl get svc -n studentapp
                """
            }
        }
    }

    post {
        success {
            echo 'Pipeline succeeded!'
            emailext (
                subject: "Jenkins Build Success: ${env.JOB_NAME} - Build #${env.BUILD_NUMBER}",
                body: """
                    <p>Build successful!</p>
                    <p>Job: ${env.JOB_NAME}</p>
                    <p>Build Number: ${env.BUILD_NUMBER}</p>
                    <p>Build URL: ${env.BUILD_URL}</p>
                    <p>Docker Image: ${DOCKER_IMAGE}:${DOCKER_TAG}</p>
                """,
                to: '${env.CHANGE_AUTHOR_EMAIL}',
                mimeType: 'text/html'
            )
        }
        failure {
            echo 'Pipeline failed!'
            emailext (
                subject: "Jenkins Build Failed: ${env.JOB_NAME} - Build #${env.BUILD_NUMBER}",
                body: """
                    <p>Build failed!</p>
                    <p>Job: ${env.JOB_NAME}</p>
                    <p>Build Number: ${env.BUILD_NUMBER}</p>
                    <p>Build URL: ${env.BUILD_URL}</p>
                    <p>Please check the logs for details.</p>
                """,
                to: '${env.CHANGE_AUTHOR_EMAIL}',
                mimeType: 'text/html'
            )
        }
        always {
            cleanWs()
        }
    }
}
