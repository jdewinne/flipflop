#!/bin/bash

# Download Helm Chart containing CRD + Operator
helm repo add postgres-operator-charts https://opensource.zalando.com/postgres-operator/charts/postgres-operator
helm pull postgres-operator-charts/postgres-operator -d manifests

cat > manifests/postgres-operator.yaml << EOF
apiVersion: kots.io/v1beta1
kind: HelmChart
metadata:
   name: postgres-operator
spec:
   chart:
      name: postgres-operator
      chartVersion: 1.9.0
   helmVersion: v3
   useHelmInstall: true

   # values maps user-provided values with the Helm chart values.yaml file.
   # You can leave the values attribute empty for this procedure.
   values: {}

   # builder values are used to create air gap packages.
   # You can leave the builder attribute empty for this procedure.
   builder: {}
EOF

# Package pginstances in Helm Chart
mkdir -p /tmp/pginstances/templates
cp pginstances/* /tmp/pginstances/templates

cat > /tmp/pginstances/Chart.yaml<< EOF
apiVersion: v2
name: pginstances
description: A Helm chart for pginstances
type: application
version: 0.1.0
appVersion: "1.0.0"
EOF

cat > /tmp/pginstances/values.yaml<< EOF
# Default values for pginstances.
replicaCount: 1
EOF

helm package -u /tmp/pginstances -d manifests

cat > manifests/pginstances.yaml << EOF
apiVersion: kots.io/v1beta1
kind: HelmChart
metadata:
   name: pginstances
spec:
   chart:
      name: pginstances
      chartVersion: 0.1.0
   helmVersion: v3
   useHelmInstall: true

   # values maps user-provided values with the Helm chart values.yaml file.
   # You can leave the values attribute empty for this procedure.
   values: {}

   # builder values are used to create air gap packages.
   # You can leave the builder attribute empty for this procedure.
   builder: {}
EOF