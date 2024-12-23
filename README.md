## Step-by-Step Restoration Process

1. **Access the Environment**  
Ensure you are in the correct context:
```bash
kubectl config use-context <your-cluster-context>
```

2. **Run Initialization Script**  
Run:
```bash
./init.sh <DOPPLER_API_TOKEN>
```
This will set api doppler secret and install CNI for cluster.

3. **Set Environment Variables**  
```bash
export GIT_REPO=https://github.com/rmikl/argo-local
export GIT_TOKEN=github_pat_xxx  # Replace with your GitHub PAT
```
- `GIT_REPO`: URL of the repo containing Argo CD applications.  
- `GIT_TOKEN`: A PAT with repo scope.

4. **Bootstrap Argo CD with argocd-autopilot**  
```bash
argocd-autopilot repo bootstrap --repo $GIT_REPO --recover
```
This sets up Argo CD configuration from your repo.
Instructions how to install argocd-autopilot: 
https://argocd-autopilot.readthedocs.io/en/stable/Installation-Guide/