# Add-on install (after AKS credentials)

Gateway API CRDs and NGINX Gateway Fabric:

```bash
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.0/standard-install.yaml
helm upgrade --install ngf oci://ghcr.io/nginxinc/charts/nginx-gateway-fabric -n gateway-system --create-namespace
```

Argo CD and Argo Rollouts:

```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm upgrade --install argo-cd argo/argo-cd -n argocd --create-namespace
helm upgrade --install argo-rollouts argo/argo-rollouts -n argo-rollouts --create-namespace
kubectl apply -f gitops/argocd/
```

Observability:

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack -n observability --create-namespace
helm upgrade --install tempo grafana/tempo -n observability
helm upgrade --install loki grafana/loki -n observability
```

Policy and DR:

```bash
helm repo add kyverno https://kyverno.github.io/kyverno
helm upgrade --install kyverno kyverno/kyverno -n kyverno --create-namespace
helm repo add vmware-tanzu https://vmware-tanzu.github.io/helm-charts
helm upgrade --install velero vmware-tanzu/velero -n velero --create-namespace
```
