# Multi-Cloud ML Model Deployment Pipeline

This project builds a full MLOps CI/CD pipeline that trains, validates, and deploys machine learning models across AWS, GCP, and Azure using:
- Terraform
- GitHub Actions
- Docker
- Kubernetes (EKS, GKE, AKS)
- MLflow
- Prometheus + Grafana

## Running locally with Docker
```bash
docker build -t ml-train-pipeline .
docker run --rm ml-train-pipeline
```
Or use the convenience script:
```bash
./scripts/build-and-run.sh
```