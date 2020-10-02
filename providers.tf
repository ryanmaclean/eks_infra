#
# Providers
#

terraform {
  required_version = ">= 0.12"
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
