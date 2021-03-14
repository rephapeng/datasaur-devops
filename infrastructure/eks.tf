#create eks cluster
module "eks" {
    source          = "git::https://github.com/terraform-aws-modules/terraform-aws-eks.git?ref=v12.1.0"
    cluster_name    = var.cluster_name
    cluster_version = "1.17"
    subnets         = module.vpc.public_subnets

    tags = {
        Environment = "uat"
        GithubRepo  = "terraform-aws-eks"
        GithubOrg   = "terraform-aws-modules"
    }

    vpc_id = module.vpc.vpc_id
    
    node_groups_defaults = {
        ami_type  = "AL2_x86_64"
        disk_size = 70
    }

    node_groups = {
        worker1 = {
            name        = "${var.cluster_name}-${random_string.suffix.result}-app"

            max_capacity     = 3
            min_capacity     = 1
            desired_capacity = 1
            key_name    = var.cluster_name
            source_security_group_ids = [module.eks.cluster_security_group_id]

            instance_type = "t3.medium"
            
            k8s_labels = {
                Environment = "uat"
            }
            additional_tags = {
                ExtraTag = "uat"
            }
        }
    }
    enable_irsa = true
    map_roles                            = var.map_roles
    map_users                            = var.map_users
    map_accounts                         = var.map_accounts

}