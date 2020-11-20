# Konveyor Operator for VMs

Konveyor Operator for VMs (virt-operator) installs a suite of migration tools that facilitate the migration of VM workloads to OpenShift Virtualization.

## Prerequisites

1. OCP 4.6+

## Konveyor for VMs Operator Installation

Konveyor operator for VMs is installable on OpenShift 4 via OperatorHub.

### Installing _released versions_

1. Visit the OpenShift Web Console.
1. Navigate to _Operators => OperatorHub_.
1. Search for _Konveyor Operator for VMs_.
1. Install the desired _Konveyor Operator for VMs_ version.

### Installing _latest_

Installing latest is almost an identical procedure to released versions but requires creating a new catalog source

1. `oc create -f virt-operator-bundle.yaml`
1. Follow the same procedure as released versions until the Search for _Konveyor Operator for VMs_ step
1. There should be two _Konveyor Operator for VMs_ available for installation now
1. Select the _Konveyor Operator for VMs_ without the _community_ tag
1. Proceed to install latest

## VirtController CR Creation

1. Visit OpenShift Web Console, navigate to _Operators => Installed Operators_
1. Select _Konveyor Operator for VMs_
1. Locate _VirtController_ on the top menu and click on it
1. Adjust settings if desired and click Create instance

## Customize Settings

Custom settings can be applied by editing the `VirtController` CR.

```
oc edit virtcontroller -n openshift-migration
```
