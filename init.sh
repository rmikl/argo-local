#!/bin/bash

# Cluster Restoration Script

# Usage:
# ./init.sh <DOPPLER_API_TOKEN>

# Check if the token is provided
if [ -z "$1" ]; then
    echo "Error: Doppler API token is required. Usage: $0 <DOPPLER_API_TOKEN>"
    exit 1
fi

DOPPLER_TOKEN=$1

# Ensure kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "kubectl could not be found. Please ensure kubectl is installed and in your PATH."
    exit 1
fi

# Verify cluster access
kubectl get nodes -o name > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Failed to connect to the cluster. Please check your kubeconfig or cluster access."
    exit 1
fi

# Add Flannel CNI to cluster
kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml

# Create Doppler Authentication Secret and annotate 
kubectl create ns cluster-operators
kubectl create secret generic -n cluster-operators doppler-token-auth-api \
    --from-literal=dopplerToken=$DOPPLER_TOKEN
kubectl annotate secret doppler-token-auth-api -n cluster-operators \
  reflector.v1.k8s.emberstack.com/reflection-allowed="true" \
  reflector.v1.k8s.emberstack.com/reflection-allowed-namespaces=".*" \
  reflector.v1.k8s.emberstack.com/reflection-auto-enabled="true" \
  reflector.v1.k8s.emberstack.com/reflection-auto-namespaces=".*" \
  --overwrite

if [ $? -eq 0 ]; then
    echo "Doppler Authentication Secret created successfully."
else
    echo "Failed to create Doppler Authentication Secret. Please check your permissions."
    exit 1
fi