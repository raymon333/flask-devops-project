pipeline {
    agent any

    environment {
        DOCKER_HUB_REPO = "rasheed3/flask-devops-project"
        CONTAINER_NAME = "flask-devops-project"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[url: 'https://github.com/raymon333/flask-devops-project']]
                ])
            }
        }

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
                        pip3 install pytest ;
                        pytest test.py;
                        
                    '
                """
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying application...'
                sh "docker stop $CONTAINER_NAME || true"
                sh "docker rm $CONTAINER_NAME || true"
                sh "docker run -d --name $CONTAINER_NAME -p 5000:5000 $DOCKER_HUB_REPO:latest"
            }
        }
    }
}
