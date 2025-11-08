module "vpc" {
  source = "./modules/vpc-core"

  vpc_name   = "smlim-test-dev-vpc"
  cidr_block = "100.71.0.0/24"

  enable_dns_hostnames = true
  enable_dns_support   = true

  # Feature flags
  enable_igw      = true
  enable_flow_log = false

  # Optional: Uncomment to enable flow logs
  # enable_flow_log = true
  # flow_log_retention_days = 30

  tags = {
    Environment = "dev"
    Project     = "test"
  }
}
