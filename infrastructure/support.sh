#!/bin/bash

# install helm-char autoscaller
helm install auto-scaler stable/cluster-autoscaler --values=data/cluster-autoscaler.yml


# install helm-chart external-dns
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install external-dns bitnami/external-dns \
    --set provider=aws \
    --set policy=sync \
    --set registry=txt \
    --set interval=1m \
    --set rbac.create=true \
    --set rbac.serviceAccountName=external-dns \
    --set rbac.serviceAccountAnnotations.eks\.amazonaws\.com/role-arn="role oidc assumable role arn" \
    --namespace kube-system

# install nginx ingress controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-0.32.0/deploy/static/provider/aws/deploy.yaml


#install cert-manager
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.16.1/cert-manager.yaml
