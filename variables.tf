#
# Variables - those not defined here need to be in a .tfvars file
#

variable "aws_region" {
  default = "us-east-1"
}

variable "cluster-name" {
  default = "terraform-eks-demo"
  type    = string
}
