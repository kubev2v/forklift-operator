# Konveyor for VMs Operator

## Prerequisites

1. OCP 4.5+ for OLM based deployments

## Operator Installation on OpenShift 4 with OLM
1. `oc create -f virt-operator-bundle.yaml`
1. Login to OpenShift console and search for Konveyor Operator for VMs
1. Install the desired version

## Operator Installation on OpenShift 4 without OLM
The same versions are available for use without OLM. Run the command corresponding to the version you wish to use:
1. `oc create -f deploy/non-olm/latest/operator.yaml`

## VirtController CR Creation
#### OpenShift 4 with OLM
1. In the OpenShift console navigate to Operators>Installed Operators
1. Click on Konveyor Operator for VMs
1. Locate VirtController on the top menu and click on it
1. Adjust settings if desired and click Create instance

#### OpenShift 4 without OLM
1. Retrieve controller.yml sample file in the `deploy/nom-olm/latest` (or desired version directories)
1. Adjust default settings if needed
1. Execute `oc create -f deploy/nom-olm/latest/controller.yml`

## Cleanup
```
oc delete namespace openshift-migration
oc delete crd virtcontrollers.virt.konveyor.io migrations.virt.konveyor.io plans.virt.konveyor.io providers.virt.konveyor.io hosts.virt.konveyor.io networkmaps.virt.konveyor.io storagemaps.virt.konveyor.io
oc delete clusterrole virt-controller
oc delete clusterrolebindings virt-operator virt-controller
oc delete oauthclient migration
```
