.PHONY: up

up:
	kind create cluster --name beyla

down:
	kind delete cluster --name beyla

deploy-app:
	docker build -t beyla-app-apple:v1 ./services/apple -f services/apple/Dockerfile
	docker build -t beyla-app-banana:v1 ./services/banana -f services/apple/Dockerfile
	kind load docker-image beyla-app-apple:v1 --name beyla
	kind load docker-image beyla-app-banana:v1 --name beyla
	kubectl create namespace beyla-target-app --dry-run=client -o yaml | kubectl apply -f -
	kubectl apply -f services/apple/k8s-manifests.yaml
	kubectl apply -f services/banana/k8s-manifests.yaml
	kubectl delete pod --all -n beyla-target-app
	kubectl port-forward svc/apple 9000:9000 -n beyla-target-app

deploy-beyla:
	kubectl create namespace beyla --dry-run=client -o yaml | kubectl apply -f -
	docker pull grafana/beyla:latest
	kind load docker-image grafana/beyla:latest --name beyla
	kubectl apply -f beyla/k8s-manifests.yaml

deploy-agent:
	helm repo add grafana https://grafana.github.io/helm-charts
	helm repo update
	kubectl create namespace grafana --dry-run=client -o yaml | kubectl apply -f -
	helm upgrade --install ga grafana/grafana-agent --namespace grafana \
		--values agent-values.yaml
