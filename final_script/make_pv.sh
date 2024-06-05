sudo rm -rf /data/org*

sudo mkdir /data/org0
sudo mkdir /data/org1
sudo mkdir /data/org2

kubectl apply -f pv.yaml

kubectl get pv
