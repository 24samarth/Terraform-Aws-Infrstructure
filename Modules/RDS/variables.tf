variable "allocated_storage" {
  description = "The amount of storage to allocate to the RDS instance (in GB)"
  type        = number
}

variable "engine" {
  description = "The database engine to use for the RDS instance"
  type        = string
}

variable "engine_version" {
  description = "The version of the database engine to use for the RDS instance"
  type        = string
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
}

variable "db_username" {
  description = "The username for the RDS database"
  type        = string
}

variable "db_password" {
  description = "The password for the RDS database"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "private_subnets" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "environment" {}