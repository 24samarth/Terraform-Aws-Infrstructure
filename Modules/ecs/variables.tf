variable "vpc_id" {
  description = "VPC ID"
}
variable "private_subnets" {
  description = "private subnet IDs"
  #type        = list(string)
}
# variable "ecs_instance_type" {
#   description = "EC2 instance type for ECS instances"
# }
# variable "ecs_ami_id" {
#   description = "EC2 AMI ID for ECS instances"

#  }


variable "repo_names" {
  type    = list(string)
}

variable "user_image" {
}
variable "poll_image" {
}
variable "reward_image" {

}
variable "blockchain_image" {}

variable "environment" {
}
