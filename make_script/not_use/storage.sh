kubectl apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: local-volume-provisioner
  namespace: kube-system
EOF
push_fn "ServiceAccount"

kubectl apply -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: local-volume-provisioner-node-reader
rules:
- apiGroups: [""]
  resources: ["nodes"]
  verbs: ["get", "list", "watch"]
EOF
push_fn "ClusterRole"

kubectl apply -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: local-volume-provisioner-node-reader-binding
subjects:
- kind: ServiceAccount
  name: local-volume-provisioner
  namespace: kube-system
roleRef:
  kind: ClusterRole
  name: local-volume-provisioner-node-reader
  apiGroup: rbac.authorization.k8s.io
EOF
push_fn "ClusterRoleBinding"

kubectl apply -f - <<EOF
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-storage
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer
EOF
push_fn "StorageClass"

kubectl apply -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: local-volume-provisioner
  namespace: kube-system
data:
  storageClassMap: |
    local-storage:
      hostDir: /mnt/disks
      mountDir: /mnt/disks
EOF
push_fn "ConfigMap"

kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: local-volume-provisioner
  namespace: kube-system
spec:
  selector:
    matchLabels:
      app: local-volume-provisioner
  template:
    metadata:
      labels:
        app: local-volume-provisioner
    spec:
      serviceAccountName: local-volume-provisioner
      containers:
      - name: provisioner
        image: quay.io/external_storage/local-volume-provisioner:v2.3.4 # 버전은 상황에 맞게 조정
        env:
        - name: MY_NODE_NAME
          valueFrom:
            fieldRef:
              fieldPath: spec.nodeName
        - name: MY_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
        volumeMounts:
        - name: local-volume-provisioner
          mountPath: /etc/provisioner/config
          readOnly: true
        - name: local-volume-provisioner-hostpath-local-storage
          mountPath: /mnt/disks
      volumes:
      - name: local-volume-provisioner
        configMap:
          name: local-volume-provisioner
      - name: local-volume-provisioner-hostpath-local-storage
        hostPath:
          path: /mnt/disks
EOF
push_fn "DeamonSet"

sudo mkdir -p /mnt/disks/test
sudo chown $(id -u):$(id -g) /mnt/disks/test

kubectl apply -f - <<EOF
apiVersion: v1
kind: PersistentVolume
metadata:
  name: test-pv
spec:
  capacity:
    storage: 100Gi
  volumeMode: Filesystem
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Delete
  storageClassName: local-storage
  local:
    path: /mnt/disks/test
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - taco 
EOF
push_fn "PersistentVolume"

kubectl apply -f - <<EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: test-pvc
  namespace: default
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 100Gi
  storageClassName: local-storage
EOF
push_fn "PersistentVolumeClaim"

kubectl apply -f -  <<EOF
apiVersion: v1
kind: PersistentVolume
metadata:
  name: org0-ca-pv
spec:
  capacity:
    storage: 100Mi
  volumeMode: Filesystem
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: local-storage
  local:
    path: /mnt/disks/org0-ca
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - taco
EOF


kubectl apply -f -  <<EOF
apiVersion: v1
kind: PersistentVolume
metadata:
  name: org1-ca-pv
spec:
  capacity:
    storage: 100Mi
  volumeMode: Filesystem
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: local-storage
  local:
    path: /mnt/disks/org0-ca
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - taco
EOF


kubectl apply -f -  <<EOF
apiVersion: v1
kind: PersistentVolume
metadata:
  name: org2-ca-pv
spec:
  capacity:
    storage: 100Mi
  volumeMode: Filesystem
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: local-storage
  local:
    path: /mnt/disks/org0-ca
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - taco
EOF


