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
                    git credentialsID: "github",
                    url: "https://github.com/anhminhle007/gitopsci",
                    branch: "main"
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
        stage("Updating Kubernetes Deployment File") {
            steps {
                script {
                    sh """
                        cat deployment.yml
                        sed -i 's/${APP_NAME}.*/${APP_NAME}:${IMAGE_TAG}/g' deployment
                        cat deployment.yml
                    """
                }
            }
        }
    }
}

// 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