# 🚀 DevOps Full Pipeline - TP4 Project

Complete CI/CD pipeline implementation from code to production monitoring with automated infrastructure provisioning and observability.

## 📚 Project Overview

This project demonstrates a complete DevOps workflow using modern tools:

| Stage | Tools | Purpose |
|-------|-------|---------|
| **Code Quality** | Git, SonarQube, Pytest | Validate code before building |
| **Container Security** | Docker, Trivy | Build secure containers & scan vulnerabilities |
| **Infrastructure** | Terraform, KinD | Automate infrastructure provisioning |
| **Deployment** | Ansible, Kubernetes | Automated configuration & deployment |
| **Observability** | Prometheus, Grafana | Monitor application & infrastructure |
| **Orchestration** | Jenkins | Coordinate entire pipeline |

---

## 📁 Project Structure

```
├── app.py                              # Flask application with metrics endpoints
├── main.py                             # Main entry point
├── test_app.py                         # Unit tests with coverage
├── pyproject.toml                      # Python dependencies (uv)
├── Dockerfile                          # Container image definition
├── Dockerfile.jenkins                  # Jenkins CI/CD container
├── Jenkinsfile                         # Full pipeline definition (7 stages)
├── sonar-project.properties            # SonarQube configuration
│
├── terraform/                          # Infrastructure as Code
│   ├── main.tf                         # KinD cluster provisioning
│   ├── variables.tf                    # Terraform variables
│   └── outputs.tf                      # Cluster outputs (kubeconfig, name)
│
├── ansible/                            # Configuration Management
│   ├── deploy.yml                      # K8s deployment playbook
│   └── inventory.ini                   # Ansible inventory
│
├── k8s/                                # Kubernetes Manifests
│   ├── namespace.yaml                  # Application namespace
│   ├── deployment.yaml                 # Pod deployment with health probes
│   ├── service.yaml                    # NodePort service exposure
│   └── servicemonitor.yaml             # Prometheus metrics collection
│
├── EXERCISE_1_2_VALIDATION.md          # CI/CD validation checklist
├── EXERCISE_3_VALIDATION.md            # Deployment validation checklist
└── README.md                           # This file
```

---

## 🔄 Pipeline Stages (Jenkinsfile)

### Exercise 1: Continuous Integration
- ✅ **Checkout** - Clone repository
- ✅ **Install Dependencies** - `uv sync`
- ✅ **Unit Tests** - Pytest with coverage reporting
- ✅ **SonarQube Analysis** - Static code analysis
- ✅ **Quality Gate** - Block on quality violations

### Exercise 2: Continuous Delivery
- ✅ **Docker Build** - Create container image
- ✅ **Trivy Scan** - Detect container vulnerabilities
- ✅ **Docker Push** - Publish to Docker Hub

### Exercise 3: Complete Deployment
- ✅ **Terraform** - Provision KinD cluster
- ✅ **Ansible Deploy** - Apply K8s manifests
- ✅ **Smoke Test** - Verify application accessibility

### Exercise 4: Observability (In Progress)
- 📊 **Prometheus** - Metrics collection
- 📈 **Grafana** - Dashboard visualization
- 🚨 **AlertManager** - Alert management

---

## 🐍 Application Features

### Endpoints
- `GET /` - Main application (returns `{"status": "ok", "message": "Hello DevOps"}`)
- `GET /health` - Health check for K8s probes
- `GET /metrics` - Prometheus metrics endpoint

### Metrics Tracked
- `http_requests_total` - Total HTTP requests by method/endpoint/status
- `http_request_duration_seconds` - Request latency histogram

### Health Checks
- **Liveness Probe** - Restarts failed containers
- **Readiness Probe** - Prevents traffic to unready pods

---

## 🏗️ Infrastructure Stack

### Terraform (IaC)
- **Provider:** KinD (Kubernetes in Docker)
- **Cluster:** Single control-plane node
- **Port Mapping:** Container 30080 → Host 30080
- **Output:** Kubeconfig for kubectl access

### Kubernetes
- **Namespace:** `myapp` (resource isolation)
- **Deployment:** 1 replica of tp4 application
- **Service:** NodePort type (external access on port 30080)
- **ServiceMonitor:** Prometheus scraping configuration

### Ansible Playbook
- Injects Docker image tag into K8s manifests
- Applies all manifests to cluster
- Waits for deployment rollout (120s timeout)

---

## 📊 Monitoring & Observability

### Prometheus
- Scrapes metrics every 30 seconds from `/metrics` endpoint
- Stores time-series data for analysis
- Integrates with Grafana for visualization

### Grafana Dashboards
- Pod health monitoring (CPU, Memory, Restarts)
- Network traffic visualization
- Application response time metrics

### AlertManager
- Monitors service availability
- Sends alerts if application is down > 2 minutes
- Notification channels: Email, Slack, Logs

---

## 🚀 Getting Started

### Prerequisites
- Jenkins server with necessary credentials/tools configured
- Docker daemon running
- Git repository configured in Jenkins

### Jenkins Configuration Required

**Credentials:**
- `sonar-token` - SonarCloud API token (Secret text)
- `dockerhub-creds` - Docker Hub authentication (Username/password)

**Tools:**
- `sonar-scanner` - SonarQube Scanner v6.2.1+
- `docker` - Docker CLI
- `trivy` - Vulnerability scanner
- `terraform` - IaC provisioning
- `ansible` - Configuration management
- `kubectl` - Kubernetes client

**Servers:**
- `SonarCloud` - SonarQube server connection

### Running the Pipeline

1. **Push code to Git** (triggers webhook)
2. **Jenkins automatically runs** all 7 pipeline stages
3. **Monitor progress** in Jenkins UI
4. **Access deployed application** at `http://172.17.0.1:30080`

---

## ✅ Validation Guides

- **[EXERCISE_1_2_VALIDATION.md](EXERCISE_1_2_VALIDATION.md)** - CI/CD & Container Security
- **[EXERCISE_3_VALIDATION.md](EXERCISE_3_VALIDATION.md)** - Complete Deployment
- **[EXERCISE_4_VALIDATION.md](EXERCISE_4_VALIDATION.md)** - Observability (Coming)

---

## 📝 Application Testing

### Run Locally
```bash
# Install dependencies
uv sync

# Run tests
uv run pytest test_app.py --cov=app --cov=main -v

# Start application
uv run flask run --host=0.0.0.0 --port=5000
```

### Build Docker Image
```bash
docker build -t syrinesmati/tp4:latest .
```

### Test Application Endpoints
```bash
curl http://localhost:5000/           # Main endpoint
curl http://localhost:5000/health     # Health check
curl http://localhost:5000/metrics    # Prometheus metrics
```

---

## 🔒 Security Best Practices

✅ **Implemented:**
- Container vulnerability scanning (Trivy)
- Code quality analysis (SonarQube)
- Health checks & resource limits
- Kubernetes security defaults

⚠️ **To Consider:**
- RBAC policies for Kubernetes
- Network policies for pod communication
- Secret management for sensitive data
- TLS/HTTPS for external communication

---

## 📈 Metrics & Monitoring

### Application Metrics
- HTTP request throughput
- Request latency (p50, p95, p99)
- Error rates by endpoint
- Pod resource utilization

### Infrastructure Metrics
- Cluster health (nodes, etcd, API server)
- Pod CPU and memory usage
- Network bandwidth
- Storage utilization

### Alerts
- Service down > 2 minutes
- High memory usage
- Pod restart loops
- API server unavailable

---

## 🐛 Troubleshooting

### Docker Hub Image Mismatch
**Issue:** Deployment uses `lgritli/tp4` but pipeline pushes to `syrinesmati/tp4`
**Solution:** Update `k8s/deployment.yaml` to match your Docker Hub username

### Kubeconfig IP Translation
**Issue:** Kubectl commands fail with "connection refused"
**Solution:** Verify IP translation (127.0.0.1 → 172.17.0.1) in Jenkinsfile Terraform stage

### Prometheus ServiceMonitor Not Working
**Issue:** Prometheus not scraping metrics
**Solution:** Verify ServiceMonitor matches Service port name (`http`) and namespace (`myapp`)

---

## 📚 Documentation

- **Terraform:** See [terraform/](terraform/) for IaC details
- **Ansible:** See [ansible/](ansible/) for deployment automation
- **Kubernetes:** See [k8s/](k8s/) for manifest definitions
- **Application:** See [app.py](app.py) for Flask implementation

---

## 👥 Author & Contributors

**Project:** Full DevOps Pipeline TP4
**Created:** May 2026
**Status:** ✅ Exercises 1-3 Complete | 🔄 Exercise 4 In Progress

---

## 📝 License & References

This project is for educational purposes as part of a comprehensive DevOps training program.

**Key Technologies:**
- Jenkins - CI/CD Orchestration
- SonarQube - Code Quality
- Docker - Containerization
- Terraform - Infrastructure as Code
- Ansible - Configuration Management
- Kubernetes - Container Orchestration
- Prometheus - Metrics Collection
- Grafana - Visualization