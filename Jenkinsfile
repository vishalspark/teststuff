pipeline {
    agent {
        docker { image 'aptible/debian' }
    }
    stages {
        stage('Test') {
            steps {
                sh 'echo $OSTYPE'
                sh 'aptible login'
            }
        }
    }
}
