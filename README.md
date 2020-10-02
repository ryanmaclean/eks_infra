# eks_infra

Terraform code based on https://github.com/terraform-providers/terraform-provider-aws/tree/master/examples/eks-getting-started

## Getting Started

Ensure you have you're AWS env vars setup.

Run `terraform init`

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
