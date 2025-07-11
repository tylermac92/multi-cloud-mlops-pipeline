terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.29"  # or the latest known working version
    }
  }

  required_version = ">= 1.6.0"
}

provider "aws" {
    region = var.aws_region
}

module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "5.5.3"

    name = "mlops-vpc"
    cidr = "10.0.0.0/16"

    azs = ["${var.aws_region}a", "${var.aws_region}b"]
    private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
    public_subnets = ["10.0.101.0/24", "10.0.102.0/24"]

    enable_nat_gateway = true
    single_nat_gateway = true
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Project = "mlflow"
    }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.21.0"

  cluster_name    = "mlops-eks"
  cluster_version = "1.29"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  eks_managed_node_groups = {
    mlops-ng = {
      desired_size = 2 # 2
      max_size     = 3 # 3
      min_size     = 1 # 1

      instance_types = ["t3.medium"]
    }
  }

  cluster_endpoint_public_access = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]

  tags = {
    Environment = "dev"
    Project     = "mlflow"
  }
}
