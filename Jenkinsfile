import java.text.SimpleDateFormat

pipeline {
    agent { dockerfile true }
    environment {
        SPARK_APTIBLE_PASSWORD = credentials('SPARK_APTIBLE_PASSWORD')
    }    
    stages {
        stage('Aptible Login') {
            steps {
                script {
                    /* Log in to aptible using the Spark-E user */
                    sh "HOME=. aptible login --email support@trialspark.com --password \"${SPARK_APTIBLE_PASSWORD}\" --lifetime \"1 day\""
                    def fileContents = readFile './.aptible/tokens.json'
                    aptibleToken = fileContents.split('"')[3]
                }
            }
        }
        stage('Generate Timestamp') {
            steps {
                script {
                    def date = new Date()
                    sdf = new SimpleDateFormat("MMddyyyyHHmmss")
                    timestamp = sdf.format(date)
                }
            }
        }
        stage('Update Staging') {
            steps {
                script {
                    /* Extract the latest backup ID */
                    def backup_id = sh (returnStdout: true, script: "APTIBLE_ACCESS_TOKEN=${aptibleToken} aptible backup:list spark-staging-1 | head -n 1 | awk '{ print \$1; }' | sed 's/:\$//'")
                    backup_id = backup_id.trim()

                    /* Make handle name */
                    def backup_handle = "${timestamp}_spark-staging-1"

                    /* Restore the latest backup */
                    sh "echo \"Restoring backup ${backup_id} to ${backup_handle}\""
                    def backup_db = sh (returnStdout: true, script: "HOME=. APTIBLE_ACCESS_TOKEN=${aptibleToken} aptible backup:restore ${backup_id} --handle=${backup_handle} | grep 'postgresql://'")
                    backup_db = backup_db.trim()

                    /* Set the environment variables in deepthought */
                    sh "echo \"Got backup DB ${backup_db}\""
                    sh "APTIBLE_ACCESS_TOKEN=${aptibleToken} aptible config:set --app deepthought-staging REDSHIFT_SOURCE_POSTGRESQL_URL=${backup_db} REDSHIFT_SOURCE_POSTGRESQL_HANDLE=${backup_handle}"
                }
            }
        }
        stage('Update Prod') {
            steps {
                script {
                    /* Extract the latest backup ID */
                    def backup_id = sh (returnStdout: true, script: "APTIBLE_ACCESS_TOKEN=${aptibleToken} aptible backup:list spark-production-replica | head -n 1 | awk '{ print \$1; }' | sed 's/:\$//'")
                    backup_id = backup_id.trim()

                    /* Make handle name */
                    def backup_handle = "${timestamp}_spark-production-replica"

                    /* Restore the latest backup */
                    sh "echo \"Restoring backup ${backup_id} to ${backup_handle}\""
                    def backup_db = sh (returnStdout: true, script: "HOME=. APTIBLE_ACCESS_TOKEN=${aptibleToken} aptible backup:restore ${backup_id} --handle=${backup_handle} | grep 'postgresql://'")
                    backup_db = backup_db.trim()

                    /* Set the environment variables in deepthought */
                    sh "echo \"Got backup DB ${backup_db}\""
                    sh "APTIBLE_ACCESS_TOKEN=${aptibleToken} aptible config:set --app deepthought-prod REDSHIFT_SOURCE_POSTGRESQL_URL=${backup_db} REDSHIFT_SOURCE_POSTGRESQL_HANDLE=${backup_handle}"
                }
            }
        }
    }
}
