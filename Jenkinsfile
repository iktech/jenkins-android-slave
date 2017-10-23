pipeline {
    environment {
      VERSION = '1.0.9'
    }

    agent {
        label 'gcloud && docker && kubectl'
    }

    stages {
        stage('Build Image') {
            steps {
                sh 'docker login -u oauth2accesstoken -p $(gcloud auth print-access-token) https://eu.gcr.io'
                sh 'docker build -t jenkins-android-slave .'
            }
        }

        stage('Tag Image') {
            steps {
                sh "docker tag jenkins-android-slave eu.gcr.io/track-my-trip-1314/jenkins-android-slave:${VERSION}.${env.BUILD_NUMBER}"
                sh 'docker tag jenkins-android-slave eu.gcr.io/track-my-trip-1314/jenkins-android-slave:latest'
            }
        }

        stage('Push Image') {
            steps {
                sh 'docker login -u oauth2accesstoken -p $(gcloud auth print-access-token) https://eu.gcr.io'
                sh "docker push eu.gcr.io/track-my-trip-1314/jenkins-android-slave:${VERSION}.${env.BUILD_NUMBER}"
                sh 'docker push eu.gcr.io/track-my-trip-1314/jenkins-android-slave:latest'
            }
        }
    }
}

