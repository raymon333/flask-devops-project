pipeline {
    agent any

    environment {
        DOCKER_HUB_REPO = "rasheed3/flask-devops-project"
        CONTAINER_NAME = "flask-devops-project"
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
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
        withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
            sh 'echo "$PASSWORD" | docker login -u "$USERNAME" --password-stdin'
            sh "docker push $DOCKER_HUB_REPO:latest"
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
