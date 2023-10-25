pipeline {
    agent any
    environment {
        DOCKERHUB_USERNAME = "0856014248"
        APP_NAME = "gitops"
        IMAGE_TAG = "${BUILD_NUMBER}"
        IMAGE_NAME = "${DOCKERHUB_USERNAME}" + "/" + "${APP_NAME}"
        REGISTRY_CREDS = "dockerhub"
    }
    stages {
        stage("Cleanup Workspace") {
            steps {
                script {
                    cleanWs(deleteDirs:true, disableDeferredWipeout: true)
                }
            }
        }
        stage("Checkout SCM") {
            steps {
                script {
                    git branch: "main",
                        credentialsID: "github",
                        url: "https://github.com/anhminhle007/gitopsci.git",
                }
            }
        }
        stage("Build Docker Image") {
            steps {
                script {
                    docker_image = docker.build "${IMAGE_NAME}"
                    docker_image.tag("${IMAGE_TAG}")
                }
            }
        }
        stage("Push Docker Image") {
            steps {
                script {
                    docker.withRegistry("", REGISTRY_CREDS) {
                        docker_image.push("${BUILD_NUMBER}")
                        docker_image.push("latest")
                    }
                }
            }
        }
        stage("Delete Docker Images") {
            steps {
                script {
                    sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker rmi ${IMAGE_NAME}:latest"
                }
            }
        }
        stage("Trigger Config Change Pipeline") {
            steps {
                script {
                    sh "curl -v -k --user 'admin:1172ca2bcfe9d6d1c2caf48f909fdc5b18' -X POST -H 'cache-control: no-cache' -H 'content-type: application/x-www-form-urlencoded' --data 'IMAGE_TAG=${IMAGE_TAG}' 'http://44.211.157.90:8080/job/gitopscd/buildWithParameters?token=gitops-config'"
                }
            }
        }
    }
}