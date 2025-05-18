pipeline {
    agent any

    environment {
        DOCKER_HUB_REPO = "rasheed3/flask-devops-project"
        CONTAINER_NAME = "flask-devops-project"
    }

    stages {
        stage('Build') {
            steps {
                echo 'Building Docker image...'
                sh "docker build -t $DOCKER_HUB_REPO:latest ."
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
                sh "docker stop $CONTAINER_NAME || true"
                sh "docker rm $CONTAINER_NAME || true"
                sh """
                    docker run --rm --name $CONTAINER_NAME $DOCKER_HUB_REPO:latest /bin/bash -c '
                        which python3 || (apt update && apt install -y python3 python3-pip);
                        pip3 install pytest;
                        pytest test.py;
                    '
                """
            }
        }

        stage('Push') {
            steps {
                echo 'Pushing image to Docker Hub...'
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                        def image = docker.image("$DOCKER_HUB_REPO:latest")
                        image.push()
                    }
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                echo 'Deploying to Kubernetes (Minikube)...'
                sh """
                    kubectl delete deployment $CONTAINER_NAME --ignore-not-found
                    kubectl apply -f k8s-deployment.yaml
                """
            }
        }
    }
}
