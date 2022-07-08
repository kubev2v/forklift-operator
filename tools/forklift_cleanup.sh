#!/bin/bash
# Cleanup Forklift in kubernetes and ocp, a valid user session to cluster is required.

OC_BINARY=`which oc`
KUBE_BINARY=`which kubectl`
NAMESPACE="konveyor-forklift"
CATSOURCE="konveyor-forklift"
CRDS="forkliftcontrollers.forklift.konveyor.io hooks.forklift.konveyor.io hosts.forklift.konveyor.io migrations.forklift.konveyor.io networkmaps.forklift.konveyor.io plans.forklift.konveyor.io providers.forklift.konveyor.io storagemaps.forklift.konveyor.io"

function usage () {
echo "Valid options for $(basename $0): "
echo -e "\t-o : OpenShift cleanup"
echo -e "\t-k : Kubernetes cleanup"
echo -e "\t-h : Print help"
}

if [ $# -eq 0 ]; then
  usage
  exit 1
fi

while getopts 'okh' opt; do
  case "$opt" in

    o)
      TYPE=openshift
      ;;

    k)
      TYPE=kubernetes
      ;;

    h)
      usage
      exit 0
      ;;

    ?)
      usage
      exit 1
      ;;
  esac
done

if [ ${TYPE} == "openshift" ]; then

  ${OC_BINARY} -n openshift-marketplace delete catalogsource ${CATSOURCE}
  ${OC_BINARY} delete project ${NAMESPACE}
  ${OC_BINARY} delete crd ${CRDS}
  ${OC_BINARY} delete oauthclient forklift-ui

elif [ ${TYPE} == "kubernetes" ]; then

  ${KUBE_BINARY} -n ${NAMESPACE} delete catalogsource ${CATSOURCE}
  ${KUBE_BINARY} delete namespace ${NAMESPACE}
  ${KUBE_BINARY} delete crd ${CRDS}
fi
