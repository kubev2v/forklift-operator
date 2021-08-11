# Konveyor Forklift k8s Installation Instructions

## Pre-requisites

- **Kubernetes cluster or Minikube v1.17+**
- **Operator Lifecycle Manager (OLM)**

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

1. Create Namespace
`$ kubectl create namespace konveyor-forklift`
2. Create Catalog Source
```
$ cat << EOF | kubectl apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: konveyor-forklift
  namespace: konveyor-forklift
spec:
  displayName: Konveyor Forklift Operator
  publisher: Red Hat
  sourceType: grpc
  image: quay.io/konveyor/forklift-operator-index:latest
EOF
```
3. Create Operator Group
```
$ cat << EOF | kubectl apply -f -
apiVersion: operators.coreos.com/v1
kind: OperatorGroup
metadata:
  name: migration
  namespace: konveyor-forklift
spec:
  targetNamespaces:
    - konveyor-forklift
EOF
```
4. Create Subscription
```
$ cat << EOF | kubectl apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: forklift-operator
  namespace: konveyor-forklift
spec:
  channel: development
  installPlanApproval: Automatic
  name: forklift-operator
  source: konveyor-forklift
  sourceNamespace: konveyor-forklift
EOF
```
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
  ui_tls_enabled: false
EOF
```
