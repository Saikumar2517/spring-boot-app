pipeline {
    agent any
    environment {
        DOCKER_REGISTRY = 'saidocker999/java-app'
    }
      tools {
        dockerTool 'docker'
    }


    stages {
        stage('Docker Build') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-password') {
                               def customImage = docker.build("saidocker999/java-app:${env.BUILD_ID}")

                            /* Push the container to the custom Registry */
                            customImage.push()
                    }
                }
            }
        }
        stage('test'){
            steps{
                script{
                    def scannerHome = tool 'sonar';
                    withSonarQubeEnv(credentialsId: 'sonar-pass') {
                        sh "${mvn}/bin/mvn clean verify sonar:sonar -Dsonar.projectKey=java-app -Dsonar.projectName='java-app'"

                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    sshPublisher(publishers: [sshPublisherDesc(configName: 'server-aws', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: "docker pull saidocker999/java-app:${env.BUILD_ID} && docker container rm -f java-app && docker run --name java-app -p 3003:8080 -d saidocker999/java-app:${env.BUILD_ID}", execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
                }
            }
        }

    }
}

