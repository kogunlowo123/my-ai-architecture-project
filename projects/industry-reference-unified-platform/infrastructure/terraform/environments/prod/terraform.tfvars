env               = "prod"
vpc_cidr          = "10.30.0.0/16"
node_desired_size = 4
# ARNs below are placeholders — populate from global outputs / your account.
flow_log_bucket_arn   = "arn:aws:s3:::aup-flowlogs-prod"
data_kms_key_arn      = "arn:aws:kms:us-east-1:111111111111:key/PLACEHOLDER"
eks_cluster_role_arn  = "arn:aws:iam::111111111111:role/aup-eks-cluster"
eks_node_role_arn     = "arn:aws:iam::111111111111:role/aup-eks-node"
eks_oidc_provider_arn = "arn:aws:iam::111111111111:oidc-provider/PLACEHOLDER"
pagerduty_sns_arn     = "arn:aws:sns:us-east-1:111111111111:aup-oncall"
