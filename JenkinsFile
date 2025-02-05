pipeline {
    agent {
        docker {
            image 'ubuntu:latest'
        }
    }
    stages {
        stage('Build') {
            steps {
                sh 'echo "Running inside Ubuntu container!"'
                sh 'uname -a'
            }
        }
    }
}
