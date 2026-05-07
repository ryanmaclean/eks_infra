# EKS Infrastructure Demo

Lightweight examples for provisioning an Amazon EKS cluster and deploying Datadog.

This repository includes three cluster provisioning paths:

- `eksctl` (quick start): [eksctl/script.sh](eksctl/script.sh)
- CloudFormation template: [cloudformation/amazon-eks-template.yaml](cloudformation/amazon-eks-template.yaml)
- Terraform configuration: [terraform/](terraform/)

## Prerequisites

- AWS CLI v2 configured (`aws configure` or equivalent SSO profile)
- `kubectl`
- One of: `eksctl`, `terraform`, or AWS CloudFormation console access
- `helm` (for Datadog Helm install)
- Datadog API key (required), Datadog APP key (optional; needed for specific cluster-agent features)

Verify AWS identity before provisioning:

```bash
aws sts get-caller-identity
```

## 1) Provision an EKS Cluster

Choose one method below.

### Option A: eksctl (fastest path)

```bash
./eksctl/script.sh
```

The script uses explicit defaults for cluster name, region, Kubernetes version, and managed nodegroup sizing, and can be overridden with environment variables.

### Option B: CloudFormation

Open the CloudFormation create-stack flow and upload [cloudformation/amazon-eks-template.yaml](cloudformation/amazon-eks-template.yaml):

https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/template

The template defaults to `ProvisionBastionHost=Disabled` and a modern Lambda runtime for generated cluster names.

Minimum required CloudFormation inputs include `KeyPairName`, `RemoteAccessCIDR`, `VPCID`, and `PrivateSubnet1ID`.

Ingress controller behavior for this template:

- `ProvisionALBIngressController` is a legacy toggle and is `Disabled` by default.
- Enabling it creates the `ALBIngressStack` nested stack from `templates/amazon-eks-alb-ingress.template.yaml`.
- This path is separate from the modern AWS Load Balancer Controller.

Minimal-risk migration path in this repository:

1. **Safe now (no/low-code)**: keep `ProvisionALBIngressController=Disabled`, document that setting clearly in deployment runbooks, and install AWS Load Balancer Controller as a separate post-cluster step.
2. **Deferred larger migration**: replace `ProvisionALBIngressController`/`ALBIngressStack` wiring in the CloudFormation template with a dedicated AWS Load Balancer Controller install path (IRSA, IAM policy updates, and rollout validation).

### Option C: Terraform

```bash
cd terraform
terraform init
terraform apply -var='cluster-name=terraform-eks-demo'
```

## 2) Configure kubectl Access

After cluster creation, update kubeconfig:

```bash
export AWS_REGION="<your-region>"
export EKS_CLUSTER_NAME="<your-cluster-name>"
aws eks --region "$AWS_REGION" update-kubeconfig --name "$EKS_CLUSTER_NAME"
```

If you used CloudFormation and left `EKSClusterName` blank, fetch the generated cluster name from stack outputs:

```bash
aws cloudformation describe-stacks \
  --stack-name "<your-stack-name>" \
  --region "$AWS_REGION" \
  --query "Stacks[0].Outputs[?OutputKey=='EKSClusterName'].OutputValue" \
  --output text
```

Validate access:

```bash
kubectl get nodes
kubectl get pods -A
```

## 3) Install Datadog on EKS

Set keys in your current shell (avoid committing keys to files):

```bash
export DD_API_KEY="<your-api-key>"
export DD_APP_KEY="<your-app-key>" # optional
```

### Recommended: Helm install

```bash
helm repo add datadog https://helm.datadoghq.com
helm repo update
helm upgrade --install datadogagent datadog/datadog \
  -f helm/values.yaml \
  --set datadog.apiKey="$DD_API_KEY" \
  --set datadog.appKey="$DD_APP_KEY"
```

Notes:

- The legacy `stable` Helm repository is deprecated and not required.
- `helm upgrade --install` is idempotent and safer for repeat runs.

### Operator install (legacy path in this repo)

```bash
bash ./operator/operator_deploy.sh
```

Use this only if you specifically want the operator flow in this repository.

## 4) Deploy Demo App

```bash
kubectl apply -f storedog/
```

## 5) Validate in Datadog

- Kubernetes Overview: https://app.datadoghq.com/screen/integration/86/kubernetes-overview

## Cleanup

If you created resources with Terraform:

```bash
cd terraform
terraform destroy -var='cluster-name=terraform-eks-demo'
```
