export VERSION=2.3.0
PREVIOUS_VERSION=2.2.0
export DEFAULT_CHANNEL=release-v2.3
export CHANNELS=release-v2.3
export IMG=quay.io/konveyor/forklift-operator

# Build CSV and CRDs from config
make bundle
# Build forklift-k8s.yaml example file
make subscription
# Build and push operator image
make docker-build docker-push
# Build and push bundle image
make bundle-build bundle-push
# Build and push to old index image
CATALOG_BASE_IMG=quay.io/konveyor/forklift-operator-index:release-v$PREVIOUS_VERSION make catalog-build bundle-push
# Build and push latest bundle to the new index
CATALOG_BASE_IMG=quay.io/konveyor/forklift-operator-index:release-v$VERSION TAG=latest make catalog-build catalog-push
