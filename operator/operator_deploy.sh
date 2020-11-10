#! /usr/bin/env bash

CLUSTER_TOKEN="$((base64 /dev/urandom | tr -d '/+' | head -c 32) 2>/dev/null)"
FW_VER="0.15.1"

# INSTALL OLM
curl -sL https://github.com/operator-framework/operator-lifecycle-manager/releases/download/"$FW_VER"/install.sh | bash -s "$FW_VER"
kubectl create -f https://operatorhub.io/install/datadog-operator.yaml
kubectl get csv -n operators

# ADD DD CLUSTER TOKEN TO CLUSTER
kubectl create secret generic datadog-auth-token --from-literal=token="$CLUSTER_TOKEN"

# Update Cluster Agent Manifest with API Key
sed "s/<YOUR_API_KEY>/$DD_API/g;" cluster-agent.yaml > updated-cluster-agent.yaml

# Apply both DD manifests
kubectl apply -f datadog-cluster-agent_service.yaml
kubectl apply -f updated-cluster-agent.yaml
