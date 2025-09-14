``md
# Flask + EKS Monorepo

Everything in one place: Flask app, Dockerfile, Kubernetes manifests, and Terraform for EKS.

## Quick start

### 1) Run locally
```bash
python -m venv .venv && source .venv/bin/activate  # Windows: .venv\\Scripts\\activate
pip install -r app/requirements.txt
python app/app.py
```

Visit http://127.0.0.1:5000

### 2) Build Docker image
```bash
make docker-build TAG=0.1.0
```

### 3) Push to GitHub Container Registry (GHCR)
- In GitHub repo settings → **Actions** permissions: allow workflows to create/read packages.
- Then run workflow (push to `main`), or manually:
```bash
make docker-push TAG=0.1.0 OWNER=YOUR_GITHUB_USERNAME REPO=flask-eks-monorepo
```

### 4) Deploy to Kubernetes
Assumes you already have `kubectl` context pointing at an EKS cluster.
```bash
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
```

## Terraform (optional – creates an EKS cluster)
```bash
cd terraform
terraform init
terraform apply -auto-approve
```
After apply, update your kubeconfig:
```bash
aws eks update-kubeconfig --name $(terraform output -raw cluster_name) --region $(terraform output -raw region)
```

## CI/CD
GitHub Actions builds and pushes the Docker image to GHCR on pushes to `main` and tag