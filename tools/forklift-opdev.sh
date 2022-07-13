#!/bin/bash

PROJECT_ROOT="../"
REQ_BINS="opm oc docker podman operator-sdk"
OPERATOR_REPO="forklift-operator"
BUNDLE_REPO="forklift-operator-bundle"
INDEX_REPO="forklift-operator-index"
CATALOG_NS="openshift-marketplace"
TAG="latest"
NAME="Forklift"

function usage () {
echo
echo "Valid arguments for $(basename $0):"
echo
echo -e "\t-n : Quay ORG used for ${NAME} development repos (required)"
echo -e "\t-o : Build and push operator image"
echo -e "\t-b : Build and push bundle image"
echo -e "\t-i : Build and push index image"
echo -e "\t-c : Create custom ${NAME} catalogsource"
echo -e "\t-d : Deploy development ${NAME} for testing"
echo
echo "$(basename $0) helps a developer test a ${NAME} operator in a Kubernetes or OpenShift environment. The script uses operator-sdk to build and publish operator, bundle and index images to Quay. Once this is done, developers can deploy and test and validate using a custom catalog source."
echo
exit 1
}

if [ $# -eq 0 ]; then
  usage
fi

# Parse options and set run conditions
while getopts 'n:obicdh' opt
do
    case $opt in
        n)
            QUAY_NS="${OPTARG}"
            ;;
        b)
	    RUN_BUNDLE=true
            ;;
        i)
            RUN_INDEX=true
            ;;
        o)
            RUN_OPERATOR=true
            ;;
        c)
            RUN_CATALOG=true
	    ;;
        d)
            RUN_DEPLOYMENT=true
	    ;;
        h)
            usage
            ;;
        *)  usage
            ;;
    esac
done

#
# Sanity checks
#

echo
echo "##### Sanity Checks #####"
echo
for bin in $REQ_BINS; do
        which $bin &>/dev/null
        if [ $? -ne 0 ]; then
                echo "Required $bin missing in path, exiting..."
                echo
                exit 1
        fi
done

# Safety check if QUAY_NS set to konveyor, NEVER build/push to upstream production repos

if [ "${QUAY_NS}" == "konveyor" ]; then
       echo "${NAME} Quay production repos (quay.io/${QUAY_NS}) should NEVER be used for development/testing, exiting..."
       echo
       exit 1
fi

echo "All requirements Ok"

# CWD is project root
pushd ${PROJECT_ROOT} 1>/dev/null

# Must process options passed in correct sequence regardless of positional getopts args

if [ ! -z ${RUN_OPERATOR} ]; then
	echo
	echo "##### Building and pushing Operator #####"
	echo
	make docker-build docker-push IMG=quay.io/${QUAY_NS}/${OPERATOR_REPO}:${TAG}
fi

if [ ! -z ${RUN_BUNDLE} ]; then
	echo
	echo "##### Building and pushing Bundle #####"
	echo
	# Must patch bundle CSV with target custom operator image first
	sed -i "s/quay.io\/konveyor\/forklift-operator:latest/quay.io\/${QUAY_NS}\/forklift-operator:latest/" bundle/manifests/forklift-operator.clusterserviceversion.yaml
	operator-sdk bundle validate ./bundle && make bundle-build bundle-push BUNDLE_IMG=quay.io/${QUAY_NS}/${BUNDLE_REPO}:${TAG}
fi

if [ ! -z ${RUN_INDEX} ]; then
	echo
	echo "##### Building and pushing Index #####"
	echo
	opm index add --bundles quay.io/${QUAY_NS}/${BUNDLE_REPO}:${TAG} --tag quay.io/${QUAY_NS}/${INDEX_REPO}:${TAG} && podman push quay.io/${QUAY_NS}/${INDEX_REPO}:${TAG}
fi

if [ ! -z  ${RUN_CATALOG} ]; then
	echo
	echo "##### Creating custom Catalog #####"
	echo
        oc create namespace konveyor-forklift
	cat << EOF | oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: konveyor-forklift
  namespace: konveyor-forklift
spec:
  displayName: Forklift Development
  publisher: Konveyor
  sourceType: grpc
  image: quay.io/${QUAY_NS}/${INDEX_REPO}:${TAG}
EOF
fi

if [ ! -z ${RUN_DEPLOYMENT} ]; then
	echo
	echo "##### Deploying Forklift #####"
	echo
	oc apply -f forklift-k8s-dev.yaml
fi
