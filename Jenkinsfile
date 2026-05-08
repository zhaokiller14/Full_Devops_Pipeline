pipeline {
    agent any
    environment {
        SONAR_TOKEN = credentials('sonar-token')
        KUBECONFIG  = "/var/jenkins_home/.kube/tp4-cluster.yaml"
        IMAGE       = "zhaokiller/tp4"
    }
    stages {
        stage('Checkout') {
            steps { checkout scm }
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
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarCloud') {
                    script {
                        def scannerHome = tool 'sonar-scanner'
                        sh "${scannerHome}/bin/sonar-scanner -Dsonar.token=${SONAR_TOKEN}"
                    }
                }
            }
        }
        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        stage('Docker Build') {
            steps {
                script { dockerImage = docker.build("${IMAGE}:${BUILD_NUMBER}") }
            }
        }
        stage('Trivy Scan') {
            steps {
                sh "trivy image --exit-code 1 --severity CRITICAL ${IMAGE}:${BUILD_NUMBER}"
            }
        }
        stage('Docker Push') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-creds') {
                        dockerImage.push("${BUILD_NUMBER}")
                        dockerImage.push("latest")
                    }
                }
            }
        }
        stage('Terraform') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                    sh 'rm -f terraform.tfstate terraform.tfstate.backup'
                    sh 'terraform apply -auto-approve'
                    sh "terraform output -raw kubeconfig > ${KUBECONFIG}"
                    sh "sed -i 's/127.0.0.1/172.17.0.1/g' ${KUBECONFIG}"
                }
            }
        }
        stage('Ansible Deploy') {
            steps {
                sh "ansible-playbook ansible/deploy.yml -i ansible/inventory.ini -e image_tag=${BUILD_NUMBER}"
            }
        }
        stage('Smoke Test') {
            steps {
                sh '''
                    sleep 15
                    curl -f http://172.17.0.1:30080/ || (echo "Smoke test FAILED" && exit 1)
                    echo "Smoke test PASSED ✅"
                '''
            }
        }
    }
    post {
        success { echo "✅ Pipeline completed successfully!" }
        failure  { echo "❌ Pipeline failed. Check logs above." }
    }
}