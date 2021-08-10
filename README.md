# Konveyor Forklift Operator

Konveyor Forklift Operator installs a suite of migration tools that facilitate the migration of VM workloads to OpenShift Virtualization.

## Prerequisites

* __OCP 4.7+__

## Konveyor Forklift Operator Installation

Konveyor Forklift Operator is installable on OpenShift 4 via OperatorHub.

### Installing _released versions_

1. Visit the OpenShift Web Console.
1. Navigate to _Operators => OperatorHub_.
1. Search for _Konveyor Forklift Operator_.
1. Install the desired _Konveyor Forklift Operator_ version.

### Installing _latest_

Installing latest is almost an identical procedure to released versions but requires creating a new catalog source.

1. `oc create -f forklift-operator-catalog.yaml`
1. Follow the same procedure as released versions until the Search for _Konveyor Forklift Operator_ step.
1. There should be two _Konveyor Forklift Operator_ available for installation now.
1. Select the _Konveyor Forklift Operator_ without the _community_ tag.
1. Proceed to install latest.

**Note:** Installing _Latest_ will also include OLM channels for released versions.

### Installing _latest_ on Kubernetes

See [k8s.md](./docs/k8s.md) for details.

## ForkliftController CR Creation

1. Visit OpenShift Web Console, navigate to _Operators => Installed Operators_.
1. Select _Konveyor Forklift Operator_.
1. Locate _ForkliftController_ on the top menu and click on it.
1. Adjust settings if desired and click Create instance.

## Customize Settings

Custom settings can be applied by editing the `ForkliftController` CR.

`oc edit forkliftcontroller -n konveyor-forklift`

## Forklift Documentation

See the [Konveyor Forklift Documentation](https://forklift-docs.konveyor.io/) for detailed installation instructions as well as how to use Konveyor Forklift.
