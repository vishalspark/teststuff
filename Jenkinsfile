pipeline {
    agent { dockerfile true }
    environment {
        SPARK_APTIBLE_PASSWORD = credentials('SPARK_APTIBLE_PASSWORD')
    }    
    stages {
        stage('Test') {
            steps {
                chmod +x ./create_backup_db.sh
                sh "./create_backup_db.sh $SPARK_APTIBLE_PASSWORD"
            }
        }
    }
}
