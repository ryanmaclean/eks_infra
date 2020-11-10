# EKS Infrastructure for Demo

Terraform code based on https://github.com/terraform-providers/terraform-provider-aws/tree/master/examples/eks-getting-started

Cloudformation code based on https://github.com/aws-quickstart/quickstart-amazon-eks/blob/main/templates/amazon-eks.template.yaml

## Getting Started

Ensure you have your AWS env vars setup.

Run `cd terraform && terraform init`

Then run `terraform apply`:

```bash
terraform apply \
 -var='cluster-name=terraform-eks-demo'
```

Retrieve the kubeconfig with:

```bash
aws eks \
 --region us-east-1 update-kubeconfig \
 --name terraform-eks-demo
```

Check out the cluster:
```bash
kubectl get po -A
```

You should see something similar to:
```
NAMESPACE     NAME                       READY   STATUS    RESTARTS   AGE
kube-system   aws-node-v9hkw             1/1     Running   0          3m4s
kube-system   coredns-75b44cb5b4-7bqnj   1/1     Running   0          6m45s
kube-system   coredns-75b44cb5b4-8j78j   1/1     Running   0          6m45s
kube-system   kube-proxy-tlmbv           1/1     Running   0          3m4s
```
## Datadog Install

### Add Helm Repository

```bash
helm repo add datadog https://helm.datadoghq.com
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo update
```

### Ensure Datadog Keys Are Exported

```bash
export DD_API_KEY=
export DD_APP_KEY=
```

### Deploy Datadog Helm Chart 

```bash
helm install datadogagent \
 --set datadog.apiKey=$DD_API_KEY \
 --set datadog.appKey=$DD_APP_KEY \
 -f helm/values.yaml datadog/datadog
```

Then visit https://app.datadoghq.com/screen/integration/86/kubernetes-overview
to check on the cluster stats. 

## Deploy Storedog

```bash
kubectl apply -f storedog/
```
