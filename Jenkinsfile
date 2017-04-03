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
                    return !env.CHANGE_ID && (currentBuild.result == null || currentBuild.result == 'SUCCESS')
                }
            }
            steps {
                script {
                    COMMIT_HASH = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()

                    docker.withRegistry('https://registry.csh.rit.edu', 'nexus-jenkins') {
                        if (env.BRANCH_NAME == 'master') {
                            image.push('latest')
                        } else {
                            image.push(env.BRANCH_NAME)
                        }

                        image.push(COMMIT_HASH)
                    }
                }
            }
        }

        stage('Deploy') {
            when {
                expression {
                    // If we're not building a PR, the build is successful, and we're on the master branch, deploy to OpenShift
                    return !env.CHANGE_ID && (env.BRANCH_NAME == 'master') &&
                        (currentBuild.result == null || currentBuild.result == 'SUCCESS')
                }
            }
            steps {
                script {
                    openshift.withCluster('csh') {
                        openshift.withProject('keycloak') {
                            openshift.doAs('os-sa-keycloak') {
                                openshift.tag("registry.csh.rit.edu/keycloak:${COMMIT_HASH}", 'keycloak/keycloak:latest')
                                openshift.selector('dc', [app: 'keycloak']).deploy()
                            }
                        }
                    }
                }
            }
        }
    }
}
