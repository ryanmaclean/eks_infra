#!/usr/bin/env bash

set -euo pipefail

CLUSTER_NAME="${CLUSTER_NAME:-eksctl-eks-demo}"
AWS_REGION="${AWS_REGION:-us-east-1}"
K8S_VERSION="${K8S_VERSION:-1.29}"
NODEGROUP_NAME="${NODEGROUP_NAME:-standard-workers}"
NODE_TYPE="${NODE_TYPE:-t3.medium}"
NODES_MIN="${NODES_MIN:-2}"
NODES_MAX="${NODES_MAX:-3}"

eksctl create cluster \
  --managed \
  --name "${CLUSTER_NAME}" \
  --region "${AWS_REGION}" \
  --version "${K8S_VERSION}" \
  --nodegroup-name "${NODEGROUP_NAME}" \
  --node-type "${NODE_TYPE}" \
  --nodes-min "${NODES_MIN}" \
  --nodes-max "${NODES_MAX}"
