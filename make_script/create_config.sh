sudo kubeadm reset --cri-socket /var/run/crio/crio.sock
sudo systemctl restart kubelet
sudo kubeadm init --cri-socket /var/run/crio/crio.sock --pod-network-cidr=10.244.0.0/16

sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
export KUBECONFIG=$HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

sudo -E kubectl taint nodes oslab node-role.kubernetes.io/master:NoSchedule-
sudo -E kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

sudo -E kubectl apply -f runtime.yaml
sudo -E kubectl apply -f nginx-kata.yaml

./network cluster init
kubectl label nodes oslab ingress-ready=true
kubectl patch deployments ingress-nginx-controller -n ingress-nginx --patch '{"spec":{"template":{"spec":{"hostNetwork":true}}}}'

