# ⚡ Quick Reference Card - DevOps TP4

## 🎯 One-Page Summary

**Project:** Complete DevOps Pipeline Implementation (4 Exercises)
**Status:** ✅ 100% COMPLETE - Ready for screenshot & report phase
**Time to Complete:** 3-4 hours

---

## 📋 The 27 Screenshots You Need

### Exercise 1 (4 screenshots)
1. Jenkins pipeline stages completed
2. SonarCloud dashboard
3. Quality gate passed
4. Unit test results

### Exercise 2 (5 screenshots)
5. Docker build stage
6. Trivy scan passed
7. Docker push stage
8. Docker Hub repository
9. Image tags list

### Exercise 3 (7 screenshots)
10. Terraform stage
11. Ansible deploy stage
12. Smoke test passed
13. K8s pods running
14. `/health` endpoint response
15. `/metrics` endpoint response
16. `/` endpoint response

### Exercise 4 (9 screenshots)
17. Monitoring namespace pods
18. Prometheus targets UP
19. Grafana dashboard full view
20. Grafana request metrics
21. Grafana performance metrics
22. Grafana panel configuration
23. AlertManager UI
24. Prometheus alert rules
25. Alert fired state
26. Alert recovery
27. Final validation

---

## ⚡ Quick Commands

### Setup & Deployment
```bash
# Setup screenshot directories
chmod +x screenshots-setup.sh
./screenshots-setup.sh

# Deploy monitoring stack
chmod +x monitoring/deploy-monitoring.sh
./monitoring/deploy-monitoring.sh monitoring

# Trigger Jenkins pipeline
# (Manual or via webhook)
```

### Port Forwarding (Run each in separate terminal)
```bash
# Prometheus
kubectl port-forward -n monitoring svc/prometheus-operated 9090:9090

# Grafana
kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80

# AlertManager
kubectl port-forward -n monitoring svc/prometheus-alertmanager 9093:9093
```

### Verification Commands
```bash
# Check monitoring pods
kubectl get pods -n monitoring

# Check application pod
kubectl get pods -n myapp

# Get deployment status
kubectl get deployment -n myapp

# Check service
kubectl get svc -n myapp

# View pod logs
kubectl logs -n myapp deployment/tp4

# Test application
curl http://172.17.0.1:30080/
curl http://172.17.0.1:30080/health
curl http://172.17.0.1:30080/metrics
```

### Git Operations
```bash
# Stage all changes
git add .

# Review changes
git status

# Commit
git commit -m "Final DevOps TP4 submission: All exercises complete"

# Push
git push origin main

# Verify
git log --oneline -n 5
```

---

## 🌐 Dashboard Access

| Service | URL | Credentials |
|---------|-----|-------------|
| Grafana | http://localhost:3000 | admin/admin |
| Prometheus | http://localhost:9090 | - |
| AlertManager | http://localhost:9093 | - |
| Jenkins | http://your-jenkins | - |
| SonarCloud | https://sonarcloud.io | - |
| Docker Hub | https://hub.docker.com | your credentials |

---

## 📁 Key Files Location

```
README.md                          ← Start here
IMPLEMENTATION_SUMMARY.md          ← This project's summary
COMPLETION_CHECKLIST.md           ← Phase-by-phase execution plan
FINAL_DOCUMENTATION_GUIDE.md      ← Screenshot capture guide

EXERCISE_1_2_VALIDATION.md        ← CI/CD details
EXERCISE_3_VALIDATION.md          ← Deployment details
EXERCISE_4_VALIDATION.md          ← Observability details

Jenkinsfile                        ← CI/CD pipeline
app.py                             ← Flask application
Dockerfile                         ← Container image
terraform/main.tf                  ← Infrastructure
ansible/deploy.yml                ← Deployment automation
k8s/deployment.yaml               ← K8s pod spec
monitoring/prometheus-values.yaml  ← Observability config
```

---

## ✅ Pre-Flight Checklist

Before running pipeline:
- [ ] Jenkins configured with credentials
- [ ] SonarCloud token configured
- [ ] Docker Hub credentials ready
- [ ] Terraform & Ansible installed
- [ ] kubectl available
- [ ] Docker daemon running
- [ ] Git repository ready

---

## 📊 Expected Results

### After Pipeline (Exercises 1-3)
✅ Code quality validated (SonarQube)
✅ Container security scanned (Trivy)
✅ Image published (Docker Hub)
✅ Cluster provisioned (Terraform)
✅ Application deployed (Ansible)
✅ Service accessible (http://172.17.0.1:30080)

### After Monitoring Deployment (Exercise 4)
✅ Prometheus collecting metrics
✅ Grafana dashboard live
✅ AlertManager active
✅ 6 alert rules configured
✅ All endpoints responsive

---

## 🎬 Screenshot Capture Flow

1. **Setup:** Run `screenshots-setup.sh`
2. **Exercise 1:** Capture Jenkins + SonarCloud (4 images)
3. **Exercise 2:** Capture Docker + Hub (5 images)
4. **Exercise 3:** Capture K8s + App (7 images)
5. **Exercise 4:** Capture Monitoring (9 images)
6. **Report:** Use template in FINAL_DOCUMENTATION_GUIDE.md
7. **Commit:** `git add . && git commit && git push`

---

## ⏱️ Time Budget

| Task | Duration |
|------|----------|
| Setup | 15 min |
| Pipeline run | 30-45 min |
| Ex 1 screenshots | 20 min |
| Ex 2 screenshots | 20 min |
| Ex 3 screenshots | 15 min |
| Ex 4 screenshots | 40 min |
| Report creation | 30 min |
| Git commit | 5 min |
| **TOTAL** | **~3-4 hours** |

---

## 🚨 Quick Troubleshooting

| Problem | Solution |
|---------|----------|
| Docker Build fails | Check Docker credentials in Jenkins |
| Quality Gate fails | Review SonarQube rules in project |
| Terraform fails | Ensure terraform & kind installed |
| Pods not running | Check `kubectl logs` for errors |
| Metrics not showing | Verify ServiceMonitor, check /metrics endpoint |
| Grafana empty | Verify Prometheus data source configured |

---

## 📋 Final Report Template Quick Items

```markdown
# DevOps TP4 - Final Report

## Executive Summary
[2-3 paragraphs describing project]

## Exercise 1: CI & Quality
[Overview + 4 screenshots + validation results]

## Exercise 2: CD & Security
[Overview + 5 screenshots + validation results]

## Exercise 3: Deployment
[Overview + 7 screenshots + validation results]

## Exercise 4: Observability
[Overview + 9 screenshots + validation results]

## Completion Summary
[Table with metrics and status]

## Conclusion
[Lessons learned + achievements]
```

---

## 🎯 Success = All These ✅

- [ ] Jenkins pipeline: All 7+ stages passing
- [ ] Code quality: SonarQube gate PASSED
- [ ] Container security: Trivy PASSED (no CRITICAL)
- [ ] Image published: On Docker Hub with tags
- [ ] Infrastructure: KinD cluster running
- [ ] Deployment: Application pods Running
- [ ] Application: Accessible via HTTP
- [ ] Monitoring: Prometheus collecting data
- [ ] Dashboard: Grafana showing metrics
- [ ] Alerts: AlertManager configured
- [ ] Documentation: All guides complete
- [ ] Screenshots: All 27 captured
- [ ] Report: Final report created
- [ ] Submitted: Everything committed to Git

---

## 🔗 Important Links

**In This Repository:**
- [README.md](README.md) - Project overview
- [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md) - Complete details
- [COMPLETION_CHECKLIST.md](COMPLETION_CHECKLIST.md) - Execution plan
- [FINAL_DOCUMENTATION_GUIDE.md](FINAL_DOCUMENTATION_GUIDE.md) - Screenshot guide

**External Services:**
- [SonarCloud](https://sonarcloud.io) - Code quality
- [Docker Hub](https://hub.docker.com) - Container registry
- [Kubernetes Docs](https://kubernetes.io/docs) - K8s reference
- [Prometheus Docs](https://prometheus.io/docs) - Metrics docs
- [Grafana Docs](https://grafana.com/docs) - Dashboard docs

---

## 💡 Pro Tips

1. **Screenshot Organization:** Keep screenshots in subdirectories by exercise for easy reference

2. **Naming Convention:** Use descriptive names like `ex1_sonarcloud_dashboard.png` not `screenshot1.png`

3. **Full Page Screenshots:** When capturing dashboards, scroll to show all data

4. **Clear Labels:** Make sure all UI elements are clearly visible in screenshots

5. **Browser Zoom:** Use 100% zoom for consistent screenshots

6. **Terminal Width:** Make terminal wide enough to show full commands and output

7. **Timestamps:** Include timestamps in alert/monitoring screenshots to prove real-time capture

8. **Multiple Angles:** Show both success states and configuration details

---

## 🎉 You're Almost Done!

All the hard infrastructure work is complete. Now just:

1. ✅ Run the pipeline (it's automated)
2. ✅ Capture 27 screenshots (follow the guide)
3. ✅ Create the final report (use template)
4. ✅ Commit to Git (one command)

**Estimated time: 3-4 hours**

**Good luck! 🚀**

---

**Created:** May 8, 2026
**Status:** Ready for Final Phase
**Next:** Execute [COMPLETION_CHECKLIST.md](COMPLETION_CHECKLIST.md)
