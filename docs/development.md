# development.md

The following guide attempts to aid developers in working and testing Forklift operator changes.

## Development environment setup

Before you begin, the following tools need to be installed in your dev system:

* [__k8s v1.22+__](https://kubernetes.io/) or [__OpenShift 4.9+__](https://www.openshift.com/)
* [__Operator SDK__](https://sdk.operatorframework.io/docs/installation/)
* [__Operator Lifecycle Manager (OLM) support__](https://olm.operatorframework.io/) (minikube/k8s clusters)
* [__OPM__](https://github.com/operator-framework/operator-registry/)
* __Podman__ and __Docker__

At a very minimum you will need three Quay repos to host images related to operator development:

* forklift-operator repo , stores dev operator images
* forklift-operator-bundle repo , stores operator dev bundle images
* forklift-operator-index repo , stores index images and serves custom catalogs

These repos must be publicly accessible and you must have enough permissions to push images with your Quay credentials. In most cases, your own organization (username) in Quay (i.e quay.io/<username>/<repo-name>) is sufficient and recommended.

## Opdev script

The opdev script automates the process of building and publishing operator development builds. It simplifies the most common tasks that would be otherwise manually done using operator-sdk and rest of tooling needed to build and publish operators for testing purposes. It can also deploy a development Forklift instance if desired.

Usage:

```
./forklift-opdev.sh -h

Valid arguments for forklift-opdev.sh:

	-n : Quay ORG used for Forklift development repos (required)
	-o : Build and push operator image
	-b : Build and push bundle image
	-i : Build and push index image
	-c : Create custom Forklift catalogsource
	-d : Deploy development Forklift for testing

```

The opdev script is resides in the tools directory of the operator repo. The only required option is -n , which is your Quay organization that hosts your operator development repos. You must be logged in to your cluster (as admin) and quay account prior attempting to run.

If you need more details regarding these procedures please the [Operator SDK ansible tutorial](https://sdk.operatorframework.io/docs/building-operators/ansible/tutorial/).

## Development flow

The usual dev order flow for operator is as follows:

* Create and make changes to your operator branch
* Run opdev script to build and publish your changes
* Deploy from a custom catalogsource and validate changes
* Commit changes and submit PR to forklift-operator repo

**Note**: Please use forks when submitting your PR, we want to avoid rogue branches in base repo

## How do I push and test my Forklift operator changes?

|Where is your change?|You changed|To test your changes|
|---|---|---|
|`./roles`| Operator roles content |[Build and push a development operator image](#build-and-push-a-development-operator-container-image) |
|`./bundle`| Operator OLM metadata | [Build and push a development bundle and index image](#build-and-push-a-development-operator-bundle-and-index-image) |
|`both` | Operator OLM metadata and roles content | [Build and push operator including OLM metadata](#build-and-push-all)

## Build and push all

This is recommended as a first time run using opdev, as it will initialize all repos and also will create a custom catalog source 

```
./forklift-opdev.sh -n <your-quay-org> -obic
```

## Build and push a development operator container image

```
./forklift-opdev.sh -n <your-quay-org> -o
```

## Build and push a development operator bundle and index image

```
./forklift-opdev.sh -n <your-quay-org> -bic
```

## Testing a development operator using a deployment

First, ensure the existance and health of the catalog:

```
oc -n konveyor-forklift get catalogsource
NAME                DISPLAY                TYPE   PUBLISHER   AGE
konveyor-forklift   Forklift Development   grpc   Konveyor    3m29s
```

### Deploy

```
./forklift-opdev.sh -n <your-quay-org> -d
```

### Check operator health:

```
oc get pods
NAME                                                              READY   STATUS      RESTARTS   AGE
7d2fe094ec9e26dfc42f576c46f4b73a432595ecef29ebd9d1b00d78732nzgw   0/1     Completed   0          5m27s
forklift-operator-5979d986b7-4lj5h                                1/1     Running     0          5m11s
konveyor-forklift-fzztn                                           1/1     Running     0          5m52s
```

### Create a _ForkliftController_ CR

Please customize the CR spec as needed, example:

```
cat << EOF | oc apply -f -
apiVersion: forklift.konveyor.io/v1beta1
kind: ForkliftController
metadata:
  name: forklift-controller
  namespace: konveyor-forklift
spec:
  feature_ui: true
  feature_validation: true
EOF
```

### Check status of _ForkliftController_ CR

The operator watches ForkliftController and uses managed status, we can check the health of each reconcile cycle by inspecting the CR:

```
oc describe forkliftcontrollers
...
Status:
  Conditions:
    Last Transition Time:  2022-07-13T03:12:17Z
    Message:               
    Reason:                
    Status:                False
    Type:                  Failure
    Ansible Result:
      Changed:             0
      Completion:          2022-07-13T03:13:04.477987
      Failures:            0
      Ok:                  25
      Skipped:             10
    Last Transition Time:  2022-07-13T03:11:48Z
    Message:               Awaiting next reconciliation
    Reason:                Successful
    Status:                True
    Type:                  Running
    Last Transition Time:  2022-07-13T03:13:04Z
    Message:               Last reconciliation succeeded
    Reason:                Successful
    Status:                True
    Type:                  Successful
Events:                    <none>
```

Any errors encountered during reconcile will be reported, for further info the operator pod logs can be inspected.
