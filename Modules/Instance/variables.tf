variable "key_name" {
}

variable "AWS_REGION" {
}

variable "instance_type" {
  type        = string
}

variable "ami" {
}

variable "ebs_block_device_size" {
}


variable "PATH_TO_PRIVATE_KEY" {
}

variable "PATH_TO_PUBLIC_KEY" {
}

variable "INSTANCE_USERNAME" {
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "public_subnets" {
  description = "public subnet IDs"
  type        = list(string)
}
variable "environment" {}