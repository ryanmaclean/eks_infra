# EKS Infrastructure for Demo

`eksctl` script (one-liner) taken from the docs: https://eksctl.io/usage/creating-and-managing-clusters/

Terraform code based on https://github.com/terraform-providers/terraform-provider-aws/tree/master/examples/eks-getting-started

Cloudformation code based on https://github.com/aws-quickstart/quickstart-amazon-eks/blob/main/templates/amazon-eks.template.yaml

## Getting Started

There are three ways presented in this repo that will help you to get a cluster up and running:

* eksctl - great for getting started quickly, will also generate Cloudformation templates
* Cloudformation - a good way to present a menu to end users
* Terraform - good for when you're managing more than just AWS resources

### eksctl

Run the eksctl script: 

```bash
./eksctl/script.sh
```

### Cloudformation

Visit the Cloudformation site and upload the `cloudformation/amazon-eks-template.yaml` file in order to walk through the form. https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/template

You can also click this [deploy to AWS](https://console.aws.amazon.com/cloudformation/home?region=us-east-2#/stacks/new?stackName=First-EKS&templateURL=https://s3-external-1.amazonaws.com/cf-templates-k7u92ie5gn4v-us-east-1/2020315G2I-amazon-eks.template.yaml) link to simply load a snapshot of the template and get started!

> Note: if you use ekctl to create a cluster and want to create more, grab the two files in the cloudfomation bucket here: https://s3.console.aws.amazon.com/s3/home?region=us-east-1# (look for  bucket that starts with `cf-templates`)

### Terraform

Ensure you have your AWS env vars setup.

Run `cd terraform && terraform init`

Then run `terraform apply`:

```bash
terraform apply -var='cluster-name=terraform-eks-demo'
```

Retrieve the kubeconfig with:

```bash
aws eks --region us-east-1 update-kubeconfig --name terraform-eks-demo
```

Check out the cluster:
```bash
kubectl get pods -A
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
