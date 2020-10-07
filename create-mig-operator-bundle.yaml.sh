#!/bin/bash

# CatalogSource imagePullPolicy is IfNotPresent and can't be changed
# https://github.com/operator-framework/operator-lifecycle-manager/issues/903
# The image will not get repulled even if the CatalogSource is recreated
# So we'll pull latest, get the sha, and use that instead

export BUNDLEDIGEST=$(docker pull quay.io/konveyor/virt-operator-index:latest | grep Digest | awk '{ print $2 }')

sed "s/:latest/@$BUNDLEDIGEST/" virt-operator-bundle.yaml | oc create -f -
