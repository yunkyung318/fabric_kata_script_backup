#!/bin/bash


#### k8s init ####
sudo kubeadm reset --cri-socket /var/run/crio/crio.sock
sudo systemctl restart kubelet
sudo kubeadm init --cri-socket /var/run/crio/crio.sock --pod-network-cidr=10.244.0.0/16

### Create k8s config file ###
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
export KUBECONFIG=$HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

### Taint nodes ###
sudo -E kubectl taint nodes oslab node-role.kubernetes.io/master:NoSchedule-

### Apply calico ###
sudo -E kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

### Create runtimeClassName ### 
sudo -E kubectl apply -f runtime.yaml

### Test ###
sudo -E kubectl apply -f nginx-kata.yaml

### Apply fabric_crd & nginx_ingress_controller ###
### Run script/cluster.sh ###
./network cluster init

### Setting ingress controller ###
kubectl label nodes oslab ingress-ready=true
kubectl patch deployments ingress-nginx-controller -n ingress-nginx --patch '{"spec":{"template":{"spec":{"hostNetwork":true}}}}'

### Make pv storage ###
sudo rm -rf /data/org*

for i in $(seq 0 2); do
	echo "sudo mkdir /data/org$i"
done

for i in $(seq 1 3); do
	echo "sudo mkdir /data/org0/node$1"
done

for i in $(seq 1 2); do
	for j in $(seq 1 2); do
		echo "sudo mkdir /data/org$i/peer$j/statedb"
	done
done

### Make pv for peer, orederer, ca ###
kubectl apply -f pv.yaml
kubectl apply -f peer_pv.yaml

### Check pv ###
kubectl get pv

### Apply fabric (ca, peer, orderer) ###
### Run script/test_network.sh ###
./network up

### Add kata runtime for hyperledger fabric pods (test-network) ###
mapfile -t deployments < <(kubectl get deployment -n test-network | awk '$1 != "NAME" && $1 != "fabric-operator" {print $1}')

echo "${deployments[@]}"

for deployment in "${deployments[@]}"; do
	kubectl patch deployment "$deployment" -n test-network --patch '{
	   "spec": {
             "template": {
               "spec": {
                 "runtimeClassName": "kata"
               }
             }
	   }
        }'
	kubectl get deployment "$deployment" -n test-network -o jsonpath='{.spec.template.spec.runtimeClassName}'
done

kubectl get pods -A

: <<'END_COMMENT'
sudo mkdir /data/org0
sudo mkdir /data/org1
sudo mkdir /data/org2

sudo mkdir /data/org0/node1
sudo mkdir /data/org0/node2
sudo mkdir /data/org0/node3

sudo mkdir /data/org1/peer1
sudo mkdir /data/org1/peer1/statedb

sudo mkdir /data/org1/peer2
sudo mkdir /data/org1/peer2/statedb

sudo mkdir /data/org2/peer1
sudo mkdir /data/org2/peer1/statedb

sudo mkdir /data/org2/peer2
sudo mkdir /data/org2/peer2/statedb

kubectl patch deployment org0-ca -n test-network --patch '{
   "spec": {
     "template": {
       "spec": {
         "runtimeClassName": "kata"
       }
     }
   }
 }'
kubectl get deployment org0-ca -n test-network -o jsonpath='{.spec.template.spec.runtimeClassName}'

kubectl patch deployment org1-ca -n test-network --patch '{
   "spec": {
     "template": {
       "spec": {
         "runtimeClassName": "kata"
       }
     }
   }
 }'
kubectl get deployment org1-ca -n test-network -o jsonpath='{.spec.template.spec.runtimeClassName}'


kubectl patch deployment org2-ca -n test-network --patch '{
   "spec": {
     "template": {
       "spec": {
         "runtimeClassName": "kata"
       }
     }
   }
 }'
kubectl get deployment org2-ca -n test-network -o jsonpath='{.spec.template.spec.runtimeClassName}'

kubectl patch deployment org0-orderersnode1 -n test-network --patch '{
  "spec": {
    "template": {
      "spec": {
        "runtimeClassName": "kata"
      }
    }
  }
}'
kubectl get deployment org0-orderersnode1 -n test-network -o jsonpath='{.spec.template.spec.runtimeClassName}'

kubectl patch deployment org0-orderersnode2 -n test-network --patch '{
  "spec": {
    "template": {
      "spec": {
        "runtimeClassName": "kata"
      }
    }
  }
}'
kubectl get deployment org0-orderersnode2 -n test-network -o jsonpath='{.spec.template.spec.runtimeClassName}'

kubectl patch deployment org0-orderersnode3 -n test-network --patch '{
  "spec": {
    "template": {
      "spec": {
        "runtimeClassName": "kata"
      }
    }
  }
}'
kubectl get deployment org0-orderersnode3 -n test-network -o jsonpath='{.spec.template.spec.runtimeClassName}'

kubectl patch deployment org1-peer1 -n test-network --patch '{
  "spec": {
    "template": {
      "spec": {
        "runtimeClassName": "kata"
      }
    }
  }
}'
kubectl get deployment org1-peer1 -n test-network -o jsonpath='{.spec.template.spec.runtimeClassName}'

kubectl patch deployment org1-peer2 -n test-network --patch '{
  "spec": {
    "template": {
      "spec": {
        "runtimeClassName": "kata"
      }
    }
  }
}'
kubectl get deployment org1-peer2 -n test-network -o jsonpath='{.spec.template.spec.runtimeClassName}'

kubectl patch deployment org2-peer1 -n test-network --patch '{
  "spec": {
    "template": {
      "spec": {
        "runtimeClassName": "kata"
      }
    }
  }
}'
kubectl get deployment org2-peer1 -n test-network -o jsonpath='{.spec.template.spec.runtimeClassName}'

kubectl patch deployment org2-peer2 -n test-network --patch '{
  "spec": {
    "template": {
      "spec": {
        "runtimeClassName": "kata"
      }
    }
  }
}'
kubectl get deployment org2-peer2 -n test-network -o jsonpath='{.spec.template.spec.runtimeClassName}'
END_COMMENT
