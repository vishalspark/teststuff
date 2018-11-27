pipeline {
    agent {
        docker { image 'node:7-alpine' }
    }
    stages {
        stage('Test') {
            steps {
                sh 'echo $OSTYPE'
                sh 'sudo apk add --update openssl'
                sh 'wget -O aptible-cli.deb "https://omnibus-aptible-toolbelt.s3.amazonaws.com/aptible/omnibus-aptible-toolbelt/master/176/pkg/aptible-toolbelt_0.16.1%2B20180730142041%7Eubuntu.14.04-1_amd64.deb"'
                sh 'sudo dpkg -i aptible-cli.deb'
                sh 'sudo apt-get update'
                sh 'sudo apt-get install -f'
            }
        }
    }
}
