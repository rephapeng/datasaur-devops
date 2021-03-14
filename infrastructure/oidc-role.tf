module "iam_assumable_role_with_oidc" {
    source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
    version = "~> 2.0"

    create_role = true

    role_name = "${var.cluster_name}_role_oidc"

    tags = {
        Role = "role-with-oidc"
    }

    provider_url = module.eks.cluster_oidc_issuer_url

    role_policy_arns = [
        "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    ]
}