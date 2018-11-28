import java.text.SimpleDateFormat

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

                    def fileContents = readFile './.aptible/tokens.json'
                    def token = fileContents.split('"')[3]

                    /* Extract the latest backup ID */
                    def backup_id = sh (returnStdout: true, script: "APTIBLE_ACCESS_TOKEN=${token} aptible backup:list spark-staging-1 | head -n 1 | awk '{ print \$1; }' | sed 's/:\$//'")
                    backup_id = backup_id.trim()

                    /* Make handle name */
                    def date = new Date()
                    sdf = new SimpleDateFormat("MMddyyyyHHmmss")
                    def backup_handle = sdf.format(date) + "_spark-staging-1"

                    /* Restore the latest backup */
                    sh "echo \"Restoring backup ${backup_id} to ${backup_handle}\""
                    sh "HOME=. APTIBLE_ACCESS_TOKEN=${token} aptible backup:restore ${backup_id} --handle=${backup_handle}"
                }
            }
        }
    }
}
