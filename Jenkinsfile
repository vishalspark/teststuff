pipeline {
    agent { dockerfile true }
    environment {
        SPARK_APTIBLE_PASSWORD = credentials('SPARK_APTIBLE_PASSWORD')
    }    
    stages {
        stage('Test') {
            steps {
                sh "./create_backup_db.sh $SPARK_APTIBLE_PASSWORD"
            }
        }
    }
}
