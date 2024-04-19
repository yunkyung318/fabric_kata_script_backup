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
