# Nestjs apps with EKS cluster
## Setup the infrastructure
we need to setup kubernetes cluster on EKS using terraform, infrastructure consist of EKS cluster, VPC, route53 role, OIDC-role and autoscaler-role.
```sh
cd infrastructure
terraform plan
terraform apply
```
after finish setup cluster using terraform we can add supporting tools such as nginx ingress, external-dns atoscaler for kubernetes, and cert manager using letsencryp.
```sh
cd infrastructure
sh support.sh
```

# initial nestjs image on public docker hub
we use public container registry (dockerhub) to store the image. 
1. first step is login using docker hub account.
2. build initial image and push to the repository.

```sh
cd nextjs-app
sh initial-image.sh
```

# Deploy nestjs-app on kubernetes
DEploy nestjs-app on kubernetes using kubernetes manifest 
```sh
cd nestjs-kubernetes-manifest
kubectl apply -f .
```

# Github Workflow
we use github workflow for CI/CD. github workflow wavaliable on 
```sh
nestjs-app/.github/workflow/rollout.yml'
```
for utilize that we can sparate the nestjs-app on specific single repository 
github workflow file also available on .github/workflow/main.yml
