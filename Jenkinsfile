pipeline {
    agent {
        label 'tp4'
    }

    options {
        skipDefaultCheckout true
    }

    environment {
        SONAR_TOKEN = credentials('sonar-token')
        KUBECONFIG  = "/var/jenkins_home/.kube/tp4-cluster.yaml"
        IMAGE       = "zhaokiller/tp4"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', 
                    credentialsId: 'dockerhub-creds',
                    url: 'https://github.com/zhaokiller14/Full_Devops_Pipeline'
            }
        }

        stage('Install Dependencies') {
            steps { sh 'uv sync' }
        }

        stage('Unit Tests') {
            steps {
                sh 'mkdir -p test-results'
                sh '''
                    uv run pytest test_app.py \
                        --cov=app --cov=main \
                        --cov-report=xml:coverage.xml \
                        --junitxml=test-results/results.xml -v
                '''
            }
            post {
                always { junit 'test-results/results.xml' }
            }
        }

        // Add the rest of your stages here later...
    }

    post {
        success { echo "✅ Pipeline completed successfully!" }
        failure { echo "❌ Pipeline failed. Check logs above." }
    }
}