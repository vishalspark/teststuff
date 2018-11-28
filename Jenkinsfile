import java.text.SimpleDateFormat

def makeBackup(aptibleToken, sourceDb, backupHandle, deepthoughtApp) {
    def prevHandle = sh (returnStdout: true, script: "APTIBLE_ACCESS_TOKEN=${aptibleToken} aptible config --app ${deepthoughtApp} | grep REDSHIFT_SOURCE_POSTGRESQL_HANDLE || true")
    prevHandle = prevHandle.trim()

    if (prevHandle.length() > 0) {
        /* Clean up the previously used backup */
        prevHandle = prevHandle.split('=')[1]
        sh "APTIBLE_ACCESS_TOKEN=${aptibleToken} aptible db:deprovision ${prevHandle}"
    }

    /* Extract the latest backup ID */
    def backupId = sh (returnStdout: true, script: "APTIBLE_ACCESS_TOKEN=${aptibleToken} aptible backup:list ${sourceDb} | head -n 1 | awk '{ print \$1; }' | sed 's/:\$//'")
    backupId = backupId.trim()

    /* Restore the latest backup */
    sh "echo \"Restoring backup ${backupId} to ${backupHandle}\""
    def backupDb = sh (returnStdout: true, script: "HOME=. APTIBLE_ACCESS_TOKEN=${aptibleToken} aptible backup:restore ${backupId} --handle=${backupHandle} | grep 'postgresql://'")
    backupDb = backupDb.trim()

    /* Set the environment variables in deepthought */
    sh "echo \"Got backup DB ${backupDb}\""
    sh "APTIBLE_ACCESS_TOKEN=${aptibleToken} aptible config:set --app ${deepthoughtApp} REDSHIFT_SOURCE_POSTGRESQL_URL=${backupDb} REDSHIFT_SOURCE_POSTGRESQL_HANDLE=${backupHandle}"
}

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
                    makeBackup(aptibleToken, "spark-staging-1", "${timestamp}_spark-staging", "deepthought-staging")
                }
            }
        }
        stage('Update Prod') {
            steps {
                script {
                    makeBackup(aptibleToken, "spark-production-replica", "${timestamp}_spark-production-replica", "deepthought-prod")
                }
            }
        }
    }
}
