# Konveyor for VMs Operator

## Operator Installation on OpenShift 4 with OLM
1. `oc create -f virt-operator-source.yaml`
2. Login to OpenShift console and search for Konveyor Operator for VMs
3. Install the desired version

## Operator Installation on OpenShift 3 without OLM
The same versions are available for use without OLM. Run the command corresponding to the version you wish to use:
1. `oc create -f deploy/non-olm/latest/operator.yaml`
