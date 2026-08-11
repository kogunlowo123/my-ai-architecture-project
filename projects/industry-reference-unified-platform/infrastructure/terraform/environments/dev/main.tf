module "networking" {
  source              = "../../modules/networking"
  name                = "aup-${var.env}"
  region              = var.region
  vpc_cidr            = var.vpc_cidr
  azs                 = var.azs
  flow_log_bucket_arn = var.flow_log_bucket_arn
}

module "data_platform" {
  source      = "../../modules/data_platform"
  name        = "aup"
  env         = var.env
  kms_key_arn = var.data_kms_key_arn
}

module "eks" {
  source              = "../../modules/eks_cluster"
  name                = "aup-${var.env}"
  cluster_role_arn    = var.eks_cluster_role_arn
  node_role_arn       = var.eks_node_role_arn
  private_subnet_ids  = module.networking.private_subnet_ids
  secrets_kms_key_arn = var.data_kms_key_arn
  desired_size        = var.node_desired_size
}

module "workload_identity" {
  source               = "../../modules/workload_identity"
  env                  = var.env
  oidc_provider_arn    = var.eks_oidc_provider_arn
  oidc_issuer_hostpath = replace(module.eks.oidc_issuer, "https://", "")
  agents               = var.agents
}

module "bedrock" {
  source           = "../../modules/bedrock_agents"
  name             = "aup-${var.env}"
  env              = var.env
  logs_kms_key_arn = var.data_kms_key_arn
}

module "observability" {
  source            = "../../modules/observability"
  name              = "aup"
  env               = var.env
  pagerduty_sns_arn = var.pagerduty_sns_arn
}
