#!groovy

pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                script {
                    image = docker.build('keycloak')
                }
            }
        }

        stage('Publish') {
            when {
                expression {
                    // If the build is successful and we're not building a PR, publish the build to Nexus
                    COMMIT_HASH = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                    return !env.CHANGE_ID && (currentBuild.result == null || currentBuild.result == 'SUCCESS')
                }
            }
            steps {
                script {
                    docker.withRegistry('https://registry.csh.rit.edu', 'nexus-jenkins') {
                        image.push(COMMIT_HASH)
                    }
                }
            }
        }
    }
}
