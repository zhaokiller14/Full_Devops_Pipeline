# Exercise 1 & 2 Validation Checklist

## 📋 Exercise 1: Continuous Integration (CI) & Code Quality

### ✅ Code Requirements (Verified)
- [x] `app.py` - Flask application with endpoints
- [x] `test_app.py` - Unit tests with pytest fixtures
- [x] `pyproject.toml` - Project dependencies configured
- [x] `sonar-project.properties` - SonarQube configuration

### ✅ Jenkinsfile Stages (Verified)
- [x] **Checkout** - Code retrieval from Git
- [x] **Install Dependencies** - `uv sync` command
- [x] **Unit Tests** - pytest with coverage reporting
  - Coverage formats: XML and JUnit
  - Coverage includes: app, main modules
- [x] **SonarQube Analysis** - Scanner configured
- [x] **Quality Gate** - Waiting for SonarQube quality gate with 5-min timeout

### ⚙️ Jenkins Configuration Required
**Credentials (Must be created in Jenkins):**
- [ ] `sonar-token` - SonarCloud API token
  - Obtain from: https://sonarcloud.io/account/security
  - Scope: Full access to sonarcloud API
  - Store as: **Secret text** credential

**Tools (Must be installed in Jenkins):**
- [ ] `sonar-scanner` - SonarQube Scanner v6.2.1+
  - Install in Jenkins: Manage Jenkins → Tools → SonarQube Scanner
  - Name: `sonar-scanner`

**SonarQube Environment (Must be configured in Jenkins):**
- [ ] `SonarCloud` - Server connection
  - Configure in: Manage Jenkins → Configure System → SonarQube servers
  - Server URL: https://sonarcloud.io
  - Auth token: Select `sonar-token` credential

### 📊 Test Coverage Metrics
- **Application files:** `app.py`, `main.py`
- **Exclusions:** `test_*.py`, `.venv/**`, `uv.lock`
- **Output formats:**
  - `coverage.xml` - SonarQube coverage report
  - `test-results/results.xml` - JUnit test results

---

## 🐳 Exercise 2: Continuous Delivery (CD) & Container Security

### ✅ Dockerfile Requirements (Verified)
- [x] Base image: Python 3.13-slim
- [x] Installs `uv` package manager
- [x] Runs `uv sync --no-dev` for reproducible builds
- [x] Exposes port 5000
- [x] Runs Flask app with `uv run flask run`

### ✅ Jenkinsfile Stages (Verified)
- [x] **Docker Build** - Builds image with tag `${IMAGE}:${BUILD_NUMBER}`
  - Image: `syrinesmati/tp4`
  - Tags: `${BUILD_NUMBER}` and `latest`
- [x] **Trivy Scan** - Vulnerability scanning
  - Exit code 1 on CRITICAL severity issues
  - Command: `trivy image --exit-code 1 --severity CRITICAL`
- [x] **Docker Push** - Publishes to Docker Hub
  - Registry: `registry.hub.docker.com`
  - Credentials: `dockerhub-creds`

### ⚙️ Jenkins Configuration Required
**Credentials (Must be created in Jenkins):**
- [ ] `dockerhub-creds` - Docker Hub authentication
  - Type: **Username with password**
  - Username: Your Docker Hub username (syrinesmati)
  - Password: Docker Hub personal access token (or password)
  - Scope: Global
  - Store in Jenkins credential store

**Tools (Must be installed in Jenkins):**
- [ ] `docker` - Docker CLI
  - Installed on Jenkins agent running the pipeline
  - Docker daemon must be accessible

- [ ] `trivy` - Trivy vulnerability scanner
  - Install in Jenkins agent or system
  - Must be in PATH or specify full path
  - Version: v0.50.0+ recommended

**Docker Configuration:**
- [ ] Docker daemon running and accessible to Jenkins user
- [ ] Jenkins user added to `docker` group (on Linux agents)
- [ ] Docker Hub credentials configured for push operations

### 🔐 Security Scanning
- **Scanner:** Aqua Trivy
- **Severity Filter:** CRITICAL only
- **Pipeline Failure:** On CRITICAL vulnerabilities detected
- **Output:** Scan results in Jenkins console

---

## ✨ Status Summary

### Exercises 1 & 2 Code: ✅ **READY**
All application code, tests, Docker configuration, and SonarQube setup are complete and validated.

### Exercises 1 & 2 Pipeline: ⚠️ **REQUIRES JENKINS SETUP**
To run the full pipeline, configure the following in Jenkins:

**Priority 1 (Critical):**
1. [ ] Create `sonar-token` credential
2. [ ] Create `dockerhub-creds` credential
3. [ ] Configure SonarCloud server connection

**Priority 2 (Required):**
4. [ ] Install `sonar-scanner` tool
5. [ ] Ensure Docker is available on agents
6. [ ] Install/verify `trivy` scanner

---

## 🚀 How to Validate When Jenkins is Ready

### Step 1: Run Exercise 1 stages
```
1. Checkout code
2. Install dependencies (uv sync)
3. Run unit tests (pytest with coverage)
4. SonarQube analysis
5. Quality gate validation
```

### Step 2: Run Exercise 2 stages
```
6. Build Docker image
7. Scan with Trivy (verify no CRITICAL issues)
8. Push to Docker Hub registry
```

### Step 3: Verify Outputs
- ✅ Test results in Jenkins (JUnit plugin)
- ✅ Coverage report in SonarCloud dashboard
- ✅ Image published to `syrinesmati/tp4:${BUILD_NUMBER}` on Docker Hub
- ✅ Image also tagged as `syrinesmati/tp4:latest`

---

## 📝 Next Steps
1. **Setup Jenkins** with credentials and tools listed above
2. **Trigger full pipeline** from Git webhook or manual run
3. **Monitor Exercises 3-4** deployment and observability stages
