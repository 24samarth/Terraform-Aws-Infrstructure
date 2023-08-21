# variables.tf

variable "cidr_value" {
  description = "The CIDR block for the VPC."
  type        = string 
}

variable "az_names" {
  description = "A list of availability zone names."
  type        = list(string)
} 

variable "public_subnet_values" {
  description = "A list of public subnet CIDR blocks."
  type        = list(string)
}

variable "private_subnet_values" {
  description = "A list of private subnet CIDR blocks."
  type        = list(string)
}

variable "environment" {}
