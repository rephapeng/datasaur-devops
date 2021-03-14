resource "aws_iam_role_policy_attachment" "alb-attach-policy" {
    role = module.iam_assumable_role_with_oidc.this_iam_role_name
    policy_arn = aws_iam_policy.k8s-alb-ingress-controller.arn
}

resource "aws_iam_policy" "k8s-alb-ingress-controller" {
    name = "${var.cluster_name}-k8s-alb-ingress-controller"

    policy = jsonencode({
        Version = "2012-10-17"

        Statement = [
        {
            Effect   = "Allow"
            Resource = "*"

            Action = [
                "acm:DescribeCertificate",
                "acm:ListCertificates",
                "acm:GetCertificate",
            ]
        },
        {
            Effect   = "Allow"
            Resource = "*"

            Action = [
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:CreateSecurityGroup",
                "ec2:CreateTags",
                "ec2:DeleteTags",
                "ec2:DeleteSecurityGroup",
                "ec2:DescribeAccountAttributes",
                "ec2:DescribeAddresses",
                "ec2:DescribeInstances",
                "ec2:DescribeInstanceStatus",
                "ec2:DescribeInternetGateways",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeTags",
                "ec2:DescribeVpcs",
                "ec2:ModifyInstanceAttribute",
                "ec2:ModifyNetworkInterfaceAttribute",
                "ec2:RevokeSecurityGroupIngress",
            ]
        },
        {
            Effect   = "Allow"
            Resource = "*"

            Action = [
                "elasticloadbalancing:AddListenerCertificates",
                "elasticloadbalancing:AddTags",
                "elasticloadbalancing:CreateListener",
                "elasticloadbalancing:CreateLoadBalancer",
                "elasticloadbalancing:CreateRule",
                "elasticloadbalancing:CreateTargetGroup",
                "elasticloadbalancing:DeleteListener",
                "elasticloadbalancing:DeleteLoadBalancer",
                "elasticloadbalancing:DeleteRule",
                "elasticloadbalancing:DeleteTargetGroup",
                "elasticloadbalancing:DeregisterTargets",
                "elasticloadbalancing:DescribeListenerCertificates",
                "elasticloadbalancing:DescribeListeners",
                "elasticloadbalancing:DescribeLoadBalancers",
                "elasticloadbalancing:DescribeLoadBalancerAttributes",
                "elasticloadbalancing:DescribeRules",
                "elasticloadbalancing:DescribeSSLPolicies",
                "elasticloadbalancing:DescribeTags",
                "elasticloadbalancing:DescribeTargetGroups",
                "elasticloadbalancing:DescribeTargetGroupAttributes",
                "elasticloadbalancing:DescribeTargetHealth",
                "elasticloadbalancing:ModifyListener",
                "elasticloadbalancing:ModifyLoadBalancerAttributes",
                "elasticloadbalancing:ModifyRule",
                "elasticloadbalancing:ModifyTargetGroup",
                "elasticloadbalancing:ModifyTargetGroupAttributes",
                "elasticloadbalancing:RegisterTargets",
                "elasticloadbalancing:RemoveListenerCertificates",
                "elasticloadbalancing:RemoveTags",
                "elasticloadbalancing:SetIpAddressType",
                "elasticloadbalancing:SetSecurityGroups",
                "elasticloadbalancing:SetSubnets",
                "elasticloadbalancing:SetWebACL",
            ]
        },
        {
            Effect   = "Allow"
            Resource = "*"

            Action = [
                "iam:CreateServiceLinkedRole",
                "iam:GetServerCertificate",
                "iam:ListServerCertificates",
            ]
        },
        {
            Effect   = "Allow"
            Resource = "*"

            Action = [
                "cognito-idp:DescribeUserPoolClient",
            ]
        },
        {
            Effect   = "Allow"
            Resource = "*"

            Action = [
                "waf-regional:GetWebACLForResource",
                "waf-regional:GetWebACL",
                "waf-regional:AssociateWebACL",
                "waf-regional:DisassociateWebACL",
                "wafv2:GetWebACLForResource",
                "wafv2:GetWebACL",
                "wafv2:GetWebACLForResource",
                "wafv2:AssociateWebACL",
                "wafv2:DisassociateWebACL",
            ]
        },
        {
            Effect   = "Allow"
            Resource = "*"

            Action = [
                "tag:GetResources",
                "tag:TagResources",
            ]
        },
        {
            Effect   = "Allow"
            Resource = "*"

            Action = [
                "waf:GetWebACL"
            ]
        },
        ]
    })
}

resource "kubernetes_service_account" "alb-ingress-controller" {
    metadata {
        name      = "alb-ingress-controller"
        namespace = "kube-system"

        labels = {
            "app.kubernetes.io/name" = "alb-ingress-controller"
        }

        annotations = {
            "eks.amazonaws.com/role-arn" = module.iam_assumable_role_with_oidc.this_iam_role_arn
            # "eks.amazonaws.com/role-arn" = aws_iam_role.alb_ingress_role.arn
        }
    }
}
resource "kubernetes_cluster_role" "alb-ingress-controller" {
    metadata {
        name = "alb-ingress-controller"

        labels = {
            "app.kubernetes.io/name" : "alb-ingress-controller"
        }
    }

    rule {
        api_groups = [
            "",
            "extensions",
        ]
        resources = [
            "configmaps",
            "endpoints",
            "events",
            "ingresses",
            "ingresses/status",
            "services",
        ]
        verbs = [
            "create",
            "get",
            "list",
            "update",
            "watch",
            "patch",
        ]
    }

    rule {
        api_groups = [
            "",
            "extensions",
        ]
        resources = [
            "nodes",
            "pods",
            "secrets",
            "services",
            "namespaces",
        ]
        verbs = [
            "get",
            "list",
            "watch",
        ]
    }
}

resource "kubernetes_cluster_role_binding" "alb-ingress-controller" {
    metadata {
        name = "alb-ingress-controller"

        labels = {
            "app.kubernetes.io/name" = "alb-ingress-controller"
        }
    }

    role_ref {
        api_group = "rbac.authorization.k8s.io"
        kind      = "ClusterRole"
        name      = kubernetes_cluster_role.alb-ingress-controller.metadata[0].name
    }

    subject {
        kind      = "ServiceAccount"
        name      = kubernetes_service_account.alb-ingress-controller.metadata[0].name
        namespace = "kube-system"
    }
}
