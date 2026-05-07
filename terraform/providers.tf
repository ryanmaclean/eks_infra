#
# Providers
#

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {}

# Not required: currently used with a curl to checkip.amazonaws.com
# in order to determine the external IP from the location TF is run
# to open the EC2 Security Group access to the EKS cluster.
# See workstation-external-ip.tf for additional information.
provider "http" {}
