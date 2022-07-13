# Konveyor Forklift k8s Installation Instructions

## Pre-requisites

- **Kubernetes cluster or Minikube v1.17+**
- **Operator Lifecycle Manager (OLM)**

Additionally you need to configure Kubernetes API acces control. On minikube you can use ABAC authorization allowing unauthenticated access to API by creating a policy file

```
$ echo '{"apiVersion": "abac.authorization.kubernetes.io/v1beta1", "kind": "Policy", "spec": {"group": "system:unauthenticated", "namespace": "*", "resource": "*", "apiGroup": "*", "nonResourcePath": "*"}}' > ~/.minikube/files/etc/ca-certificates/abac.json
```

and enabling ABAC authorization by initializing minikube with

`$ minikube start --extra-config=apiserver.authorization-mode=Node,RBAC,ABAC --extra-config=apiserver.authorization-policy-file=/etc/ca-certificates/abac.json`

and setting _feature_auth_required_ to false in _ForkliftController_ CR

### Installing OLM support

We strongly suggest OLM support for Forklift deployments, in some production kubernetes clusters OLM might already be present, if not, see the following examples in how to add OLM support to minikube or standard kubernetes clusters below:

#### Minikube:
`$ minikube addons enable olm`

#### Kubernetes:
`$ kubectl apply -f https://raw.githubusercontent.com/operator-framework/operator-lifecycle-manager/master/deploy/upstream/quickstart/crds.yaml`

`$ kubectl apply -f https://raw.githubusercontent.com/operator-framework/operator-lifecycle-manager/master/deploy/upstream/quickstart/olm.yaml`

For details and official instructions in how to add OLM support to kubernetes and customize your installation see [here](https://github.com/operator-framework/operator-lifecycle-manager/blob/master/doc/install/install.md)

**Note:** Please wait a few minutes for OLM support to become available if this is a new deployment.

### Installing _latest_

Deploy Forklift using manifest:

`$ kubectl apply -f https://raw.githubusercontent.com/konveyor/forklift-operator/main/forklift-k8s.yaml`

### Creating a _ForkliftController_ CR (SSL/TLS disabled)
```
$ cat << EOF | kubectl apply -f -
apiVersion: forklift.konveyor.io/v1beta1
kind: ForkliftController
metadata:
  name: forklift-controller
  namespace: konveyor-forklift
spec:
  feature_ui: false
  feature_validation: true
  inventory_tls_enabled: false
  validation_tls_enabled: false
  must_gather_api_tls_enabled: false
  ui_tls_enabled: false
EOF
```

### Creating a _ForkliftController_ CR (SSL/TLS disabled) on minikube with UI
```
$ cat << EOF | kubectl apply -f -
apiVersion: forklift.konveyor.io/v1beta1
kind: ForkliftController
metadata:
  name: forklift-controller
  namespace: konveyor-forklift
spec:
  feature_ui: true
  feature_auth_required: false
  feature_validation: true
  inventory_tls_enabled: false
  validation_tls_enabled: false
  must_gather_api_tls_enabled: false
  ui_tls_enabled: false
EOF
```
