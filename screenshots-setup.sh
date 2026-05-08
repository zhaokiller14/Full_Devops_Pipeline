#!/bin/bash
# Screenshot Collection Automation Script
# Helps organize and prepare screenshot directories
# Usage: chmod +x screenshots-setup.sh && ./screenshots-setup.sh

echo "📸 Setting up screenshot collection structure..."
echo ""

# Create directory structure
mkdir -p screenshots/{exercise_1,exercise_2,exercise_3,exercise_4}

echo "✅ Created directories:"
echo "   screenshots/exercise_1/"
echo "   screenshots/exercise_2/"
echo "   screenshots/exercise_3/"
echo "   screenshots/exercise_4/"
echo ""

# Create README for each exercise
for exercise in 1 2 3 4; do
  cat > "screenshots/exercise_${exercise}/README.md" << EOF
# Exercise ${exercise} Screenshots

Place screenshots for Exercise ${exercise} in this directory.

## Files to Capture

EOF
  case $exercise in
    1)
      cat >> "screenshots/exercise_${exercise}/README.md" << 'EOF'
- ex1_jenkins_stages.png - Jenkins pipeline stages 1-5 completed
- ex1_sonarcloud_dashboard.png - SonarCloud project dashboard
- ex1_quality_gate.png - Quality gate PASSED status
- ex1_unit_tests.png - Unit test results (2/2 passed)
EOF
      ;;
    2)
      cat >> "screenshots/exercise_${exercise}/README.md" << 'EOF'
- ex2_docker_build.png - Docker build stage PASSED
- ex2_trivy_scan.png - Trivy scan PASSED (no CRITICAL)
- ex2_docker_push.png - Docker push to Docker Hub PASSED
- ex2_docker_hub.png - Docker Hub repository page
- ex2_docker_tags.png - Image tags (numbered + latest)
EOF
      ;;
    3)
      cat >> "screenshots/exercise_${exercise}/README.md" << 'EOF'
- ex3_terraform_stage.png - Terraform cluster creation
- ex3_ansible_deploy.png - Ansible playbook execution
- ex3_smoke_test.png - Smoke test PASSED
- ex3_k8s_pods.png - kubectl get pods output (Running)
- ex3_health_check.png - /health endpoint response
- ex3_metrics_endpoint.png - /metrics endpoint response
- ex3_app_endpoint.png - / endpoint response
EOF
      ;;
    4)
      cat >> "screenshots/exercise_${exercise}/README.md" << 'EOF'
- ex4_monitoring_pods.png - kubectl get pods -n monitoring
- ex4_prometheus_targets.png - Prometheus targets UP
- ex4_grafana_dashboard.png - Full dashboard overview
- ex4_grafana_requests.png - Request metrics panels
- ex4_grafana_performance.png - Performance panels
- ex4_grafana_panel_config.png - Panel query configuration
- ex4_alertmanager_page.png - AlertManager UI
- ex4_prometheus_rules.png - Prometheus alert rules
- ex4_alert_fired.png - Alert in FIRING state
EOF
      ;;
  esac
  echo "   ✅ Created README in exercise_${exercise}/"
done

echo ""
echo "=========================================="
echo "✅ Screenshot collection setup complete!"
echo "=========================================="
echo ""
echo "📝 Next Steps:"
echo "1. Capture all screenshots and place in appropriate directories"
echo "2. Create FINAL_REPORT.md using the template provided"
echo "3. Insert screenshots into your report"
echo "4. Commit everything to Git"
echo ""
echo "📸 Quick Commands:"
echo ""
echo "View directory structure:"
echo "  tree screenshots/"
echo ""
echo "Count screenshots:"
echo "  ls -R screenshots/ | grep '.png' | wc -l"
echo ""
echo "Example: Capture screenshot (Linux/WSL):"
echo "  scrot screenshots/exercise_1/ex1_jenkins_stages.png"
echo ""
echo "Example: Capture screenshot (Windows):"
echo "  Press: Windows + Shift + S"
echo "  Then paste into Paint and save"
