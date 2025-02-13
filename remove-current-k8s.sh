# Reset kubeadm (run this on all nodes if you have a multi-node cluster)
sudo kubeadm reset -f

# Remove any remaining Kubernetes configuration/files
sudo rm -rf /etc/cni/net.d
sudo rm -rf $HOME/.kube/config
sudo rm -rf /etc/kubernetes

# Clean up CNI interfaces and iptables rules (optional but recommended)
sudo ip link delete cni0
sudo ip link delete flannel.1
sudo iptables -F
sudo iptables -t nat -F
sudo iptables -t mangle -F
sudo iptables -X

# Remove Kubernetes packages (optional)
sudo apt-get purge kubeadm kubelet kubectl -y
sudo apt-get autoremove -y

# Reinstall Kubernetes tools (if needed)
sudo apt-get install -y kubeadm kubelet kubectl


sudo docker system prune -af || sudo crictl rmi --prune
