pipeline {
    agent { dockerfile true }
    environment {
        SPARK_APTIBLE_PASSWORD = credentials('SPARK_APTIBLE_PASSWORD')
    }    
    stages {
        stage('Test') {
            steps {
                /* Log in to aptible using the Spark-E user */
                sh 'aptible login --email support@trialspark.com --password $SPARK_APTIBLE_PASSWORD --lifetime "1 day"'

                /* Extract the latest backup ID */
                sh 'backup_id=$(aptible backup:list spark-staging-1 | head -n 1 | awk \'{ print $1; }\' | sed \'s/:$//\')'

                /* Make handle name */
                sh 'backup_handle=$(date +"%Y%m%d%H%M%S")'
                sh 'backup_handle+="_spark-staging-1"'

                /* Restore the latest backup */
                sh 'echo "Restoring backup $backup_id to $backup_handle"'
                sh 'aptible backup:restore $backup_id --handle=$backup_handle'
            }
        }
    }
}
