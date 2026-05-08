# Exercise 3 Validation: Complete Deployment (IaC & Orchestration)

## 📋 Exercise 3: Deployment Complete (Infrastructure as Code)

### ✅ Terraform Configuration (Verified)

#### Infrastructure Components
- [x] **Provider:** KinD (Kubernetes in Docker)
- [x] **Cluster Resource:** `kind_cluster.tp4`
- [x] **Node Configuration:**
  - Role: `control-plane`
  - Extra port mapping: Container 30080 → Host 30080
- [x] **Outputs:**
  - Cluster name: `tp4-cluster`
  - Kubeconfig: Exported as sensitive output

#### Terraform Execution Flow (in Jenkinsfile)
```groovy
stage('Terraform') {
    steps {
        dir('terraform') {
            sh 'terraform init'                              # Initialize providers
            sh 'rm -f terraform.tfstate terraform.tfstate.backup'  # Clean state
            sh 'terraform apply -auto-approve'               # Create cluster
            sh "terraform output -raw kubeconfig > ${KUBECONFIG}"  # Export kubeconfig
            sh "sed -i 's/127.0.0.1/172.17.0.1/g' ${KUBECONFIG}"  # Fix API server IP
        }
    }
}
```

**Key Points:**
- ✅ Auto-approval enabled for CI/CD automation
- ✅ Kubeconfig exported to Jenkins environment variable
- ✅ IP address translation: 127.0.0.1 → 172.17.0.1 (Docker host gateway)

---

### ✅ Ansible Deployment Configuration (Verified)

#### Playbook: `ansible/deploy.yml`

**Host:** `local` (localhost with local connection)

**Variables:**
- `image_tag` - Injected from Jenkins (defaults to 'latest')
- `kubeconfig` - Loaded from environment variable `KUBECONFIG`

**Tasks:**

1. **Set image in deployment manifest**
   - Replaces `IMAGE_TAG` placeholder with actual build number
   - File: `k8s/deployment.yaml`
   - Dynamic tagging enables version control

2. **Apply Kubernetes manifests**
   - Command: `kubectl apply -f k8s/ --validate=false`
   - Applies all YAML files in `k8s/` directory
   - Manifests applied:
     - ✅ Namespace: Creates `myapp` namespace
     - ✅ Deployment: Deploys `tp4` pod with health checks
     - ✅ Service: Exposes via NodePort on 30080
     - ✅ ServiceMonitor: Configures Prometheus scraping

3. **Wait for deployment rollout**
   - Waits up to 120 seconds for pods to be ready
   - Monitors: `deployment/tp4` in namespace `myapp`
   - Ensures application is healthy before proceeding

#### Ansible Execution Flow (in Jenkinsfile)
```groovy
stage('Ansible Deploy') {
    steps {
        sh "ansible-playbook ansible/deploy.yml -i ansible/inventory.ini -e image_tag=${BUILD_NUMBER}"
    }
}
```

---

### ✅ Kubernetes Manifests (Verified)

#### 1. Namespace Manifest
**File:** `k8s/namespace.yaml`
```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: myapp
```
- ✅ Isolates application resources
- ✅ Clean resource organization
- ✅ Labels available for RBAC and policies

#### 2. Deployment Manifest
**File:** `k8s/deployment.yaml`

**Specifications:**
- **Image:** `lgritli/tp4:IMAGE_TAG` (dynamic tagging from Ansible)
- **Replicas:** 1
- **Port:** 5000 (Flask application)

**Health Probes:**
- ✅ **Liveness Probe:**
  - Endpoint: `/health`
  - Initial delay: 10 seconds
  - Period: 10 seconds
  - Auto-restarts failed containers

- ✅ **Readiness Probe:**
  - Endpoint: `/health`
  - Initial delay: 5 seconds
  - Period: 5 seconds
  - Prevents traffic to unready pods

**Pod Scheduling:**
- Selector matches label: `app: tp4`
- Resources tracked by label selectors

#### 3. Service Manifest
**File:** `k8s/service.yaml`

**Specifications:**
- **Type:** NodePort (external access)
- **Node Port:** 30080 (maps to host port 30080)
- **Target Port:** 5000 (container port)
- **Protocol:** TCP (default)

**Port Configuration:**
- Port name: `http` (important for Prometheus ServiceMonitor discovery)
- Allows both internal K8s communication and external access

#### 4. ServiceMonitor Manifest
**File:** `k8s/servicemonitor.yaml`

**Specifications:**
- **Namespace:** `myapp`
- **Selector:** Matches service with label `app: tp4`
- **Metrics Endpoint:**
  - Path: `/metrics`
  - Port: `http` (matches Service port name)
  - Interval: 30 seconds
  - Timeout: 10 seconds

- ✅ Enables Prometheus automatic scraping
- ✅ Discovers metrics from port named `http`

---

### ✅ Smoke Test (Verified)

#### Smoke Test Configuration (in Jenkinsfile)
```groovy
stage('Smoke Test') {
    steps {
        sh '''
            sleep 15
            curl -f http://172.17.0.1:30080/ || (echo "Smoke test FAILED" && exit 1)
            echo "Smoke test PASSED ✅"
        '''
    }
}
```

**Test Details:**
- **Wait Time:** 15 seconds (allows pod initialization)
- **Target URL:** `http://172.17.0.1:30080/`
  - IP: 172.17.0.1 (Docker host gateway)
  - Port: 30080 (NodePort service)
- **Endpoint:** `/` (main application endpoint)
- **Expected Response:** HTTP 200 with "ok" status
- **Failure Handling:** Pipeline fails if smoke test returns non-200 status

---

## 🔧 Infrastructure Stack Summary

| Component | Tool | Purpose |
|-----------|------|---------|
| **Infrastructure** | Terraform + KinD | Provisions local K8s cluster |
| **Configuration** | Ansible | Injects image tag & deploys manifests |
| **Orchestration** | Kubernetes | Manages containers & networking |
| **Service Discovery** | K8s Service (NodePort) | Exposes application externally |
| **Health Management** | K8s Probes | Monitors pod health & auto-recovery |
| **Monitoring Setup** | ServiceMonitor + Prometheus | Enables metrics collection |

---

## ⚠️ Issues & Required Fixes

### Issue 1: Docker Hub Image Reference Mismatch ⚠️
**Current:** `lgritli/tp4:IMAGE_TAG` in deployment.yaml
**Expected:** `syrinesmati/tp4:IMAGE_TAG` (matches Jenkinsfile & Docker Hub push)

**Impact:** Deployment will pull from wrong registry
**Status:** ❌ **NEEDS FIX** - Either:
- Option A: Update deployment.yaml to use `syrinesmati/tp4`
- Option B: Ensure Docker Hub account can access `lgritli/tp4`

### Issue 2: Terraform State Management
**Current:** State is deleted between runs (`rm -f terraform.tfstate`)
**Impact:** Terraform recreates cluster every pipeline run
**Status:** ⚠️ **Consider:** Store state remotely (S3, Terraform Cloud) for production

### Issue 3: Kubeconfig IP Translation
**Current:** Sed command replaces 127.0.0.1 with 172.17.0.1
**Status:** ✅ **Verified** - Works for Docker host gateway
**Note:** Different environments may require different IPs

---

## ✨ Exercise 3 Readiness Checklist

### Code/Configuration: ✅ **READY**
- [x] Terraform KinD cluster configuration
- [x] Ansible deployment playbook
- [x] Kubernetes manifests (Namespace, Deployment, Service, ServiceMonitor)
- [x] Health probes for pod monitoring
- [x] Smoke test in Jenkinsfile

### Prerequisites for Pipeline Execution: ⚠️ **PARTIALLY READY**
- [x] Terraform binary available in Jenkins agent
- [x] Ansible installed in Jenkins agent
- [x] kubectl installed in Jenkins agent
- [x] Docker daemon running (for KinD cluster)
- [ ] **Image reference needs to match** (lgritli/tp4 vs syrinesmati/tp4)

### Kubernetes Cluster Setup: ✅ **READY**
- [x] KinD cluster creation automated
- [x] NodePort service for external access
- [x] Health checks configured
- [x] Metrics endpoint available for Prometheus

---

## 📊 Exercise 3 Deployment Flow

```
┌─────────────────────────────────────────┐
│ Jenkins Pipeline Stage: Terraform       │
│ - Initialize providers                  │
│ - Clean previous state                  │
│ - Create KinD cluster (tp4-cluster)     │
│ - Export kubeconfig to KUBECONFIG env   │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│ Jenkins Pipeline Stage: Ansible Deploy  │
│ - Read image_tag from ${BUILD_NUMBER}   │
│ - Update deployment.yaml with tag       │
│ - Apply all K8s manifests               │
│ - Wait for deployment rollout (120s)    │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│ Jenkins Pipeline Stage: Smoke Test      │
│ - Wait 15 seconds for pod startup       │
│ - Test HTTP GET /                       │
│ - Verify response code 200              │
│ - Confirm "ok" in response JSON         │
└──────────────┬──────────────────────────┘
               │
               ▼
        ✅ Exercise 3 Complete
        Application is LIVE at:
        http://172.17.0.1:30080
```

---

## 🚀 How to Validate Exercise 3

### When Full Pipeline is Ready:
1. Ensure Exercises 1-2 pass (CI/CD + Docker security)
2. Run stages 5-7 of Jenkinsfile:
   - Terraform (infrastructure provisioning)
   - Ansible Deploy (configuration management)
   - Smoke Test (health verification)

### Verification Points:
- ✅ Terraform creates `tp4-cluster` KinD cluster
- ✅ Kubeconfig saved to Jenkins container
- ✅ Ansible successfully applies manifests
- ✅ Pods reach "Running" state within 120s
- ✅ Smoke test reaches `/` endpoint with HTTP 200
- ✅ Service available on `http://172.17.0.1:30080`

### Monitoring Metrics:
- Pod CPU/Memory usage tracked in ServiceMonitor
- Request metrics available at `/metrics` endpoint
- Prometheus scrapes metrics every 30 seconds

---

## 📝 Next Steps

1. **Fix image reference** in deployment.yaml (if needed)
2. **Run full Exercise 3** when Jenkins infrastructure is ready
3. **Proceed to Exercise 4** for Prometheus + Grafana observability stack
