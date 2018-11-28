pipeline {
    agent { dockerfile true }
    environment {
        SPARK_APTIBLE_PASSWORD = credentials('SPARK_APTIBLE_PASSWORD')
    }    
    stages {
        stage('Test') {
            steps {
                script {
                    /* Log in to aptible using the Spark-E user */
                    sh "HOME=. aptible login --email support@trialspark.com --password \"${SPARK_APTIBLE_PASSWORD}\" --lifetime \"1 day\""

                    /* Extract the latest backup ID */
                    def backup_id = sh (returnStdout: true, script: "APTIBLE_ACCESS_TOKEN=./.aptible/tokens.json aptible backup:list spark-staging-1 | head -n 1 | awk '{ print \$1; }' | sed 's/:\$//'")

                    /* Make handle name */
                    def backup_handle = "REMOVE_ME_spark-staging-1"

                    /* Restore the latest backup */
                    sh "echo \"Restoring backup ${backup_id} to ${backup_handle}\""
                    sh "APTIBLE_ACCESS_TOKEN=./.aptible/tokens.json aptible backup:restore ${backup_id} --handle=${backup_handle}"
                }
            }
        }
    }
}
