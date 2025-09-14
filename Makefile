OWNER?=TiffanyChristman
REPO?=flask-eks-monorepo
IMAGE=ghcr.io/$(OWNER)/$(REPO)
TAG?=dev

.PHONY: docker-build docker-push tf-init tf-apply tf-destroy kube-apply kube-delete

docker-build:
	docker build -t $(IMAGE):$(TAG) .

docker-push:

echo $$GHCR_TOKEN | docker login ghcr.io -u $(OWNER) --password-stdin
	docker push $(IMAGE):$(TAG)

tf-init:
	cd terraform && terraform init

tf-apply:
	cd terraform && terraform apply -auto-approve

tf-destroy:
	cd terraform && terraform destroy -auto-approve

kube-apply:
	kubectl apply -f k8s/namespace.yaml
	kubectl apply -f k8s/deployment.yaml
	kubectl apply -f k8s/service.yaml

kube-delete:
	kubectl delete -f k8s/service.yaml --ignore-not-found
	kubectl delete -f k8s/deployment.yaml --ignore-not-found
	kubectl delete -f k8s/namespace.yaml --ignore-not-found
```

