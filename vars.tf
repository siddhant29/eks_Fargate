variable "region" {
  default = "us-east-2"
}

variable "vpc_name" {
  description = "Enter the name of the VPC specific to your env"
  type = string
  default = "eksthreedots"
}
variable "cluster_name"{
  description = "Enter the name of the environment for which the network to be setup"
  default = "eks-clusterk2"

}
variable "env" {
  description = "Enter the name of the environment for which the network to be setup"
  default = "dev"
}

variable "nat_gateway" {
  description = "Whether to create this resource or not?"
  type        = bool
  default     = false
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default = "192.168.0.0/16"
}

variable "public_subnets_cidr1" {
  description = "CIDR blocks for public_subnets_cidr"
  default = "192.168.0.0/19"
}

variable "public_subnets_cidr2" {
  description = "CIDR blocks for public_subnets_cidr"
  default = "192.168.32.0/19"
}

variable "private_subnets_cidr1" {
  description = "CIDR blocks for private_subnets_cidr"
  default = "192.168.64.0/19"
}

variable "private_subnets_cidr2" {
  description = "CIDR blocks for private_subnets_cidr"
  default = "192.168.96.0/19"
}


variable "az1" {
  description = "two Availability zones for VPC"
  default = "us-east-2a"
}
variable "az2" {
  description = "two Availability zones for VPC"
  default =  "us-east-2b"
}