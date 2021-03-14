resource "aws_iam_policy" "eks-route53" {
    name = "${var.cluster_name}-k8s-route53-dns-controller"
    policy = file("${path.module}/data/iam_route53_policy.json")
}
resource "aws_iam_role_policy_attachment" "route53-attach-policy" {
    role = module.iam_assumable_role_with_oidc.this_iam_role_name
    policy_arn = aws_iam_policy.eks-route53.arn
}
resource "aws_iam_role_policy_attachment" "route53-attach-worker" {
    role = module.eks.worker_iam_role_name
    policy_arn = aws_iam_policy.eks-route53.arn
}