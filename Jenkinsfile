pipeline {
    agent {
        kubernetes {
            label 'buildah-agent'
            defaultContainer 'buildah'
            yaml '''
            apiVersion: v1
            kind: Pod
            metadata:
              name: buildah-agent
              labels:
                app: jenkins
            spec:
              containers:
                - name: buildah
                  image: quay.io/buildah/stable:latest  # or use your custom Buildah image
                  command:
                    - cat
                  tty: true
                  resources:
                    requests:
                      memory: "2Gi"
                      cpu: "1"
                    limits:
                      memory: "4Gi"
                      cpu: "2"
                  volumeMounts:
                    - name: workspace
                      mountPath: /workspace
              volumes:
                - name: workspace
                  emptyDir: {}
            '''
        }
    }

    environment {
        BUILD_IMAGE_NAME = 'your-image-name'
        BUILD_IMAGE_TAG = 'latest'
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Checkout the source code from your repository
                checkout scm
            }
        }

        stage('Build Container Image with Buildah') {
            steps {
                container('buildah') {
                    // Run Buildah commands inside the Buildah container
                    sh '''
                    cd /workspace
                    buildah bud -t ${BUILD_IMAGE_NAME}:${BUILD_IMAGE_TAG} .
                    '''
                }
            }
        }
    }

    post {
        always {
            // Clean up actions, if necessary
            container('buildah') {
                sh '''
                buildah rmi ${BUILD_IMAGE_NAME}:${BUILD_IMAGE_TAG}
                '''
            }
        }

        success {
            echo 'Buildah build succeeded!'
        }

        failure {
            echo 'Buildah build failed.'
        }
    }
}
