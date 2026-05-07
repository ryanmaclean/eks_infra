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

variable "workstation_external_cidr" {
  description = "Optional CIDR block allowed to access the EKS API endpoint."
  type        = string
  default     = null
}
