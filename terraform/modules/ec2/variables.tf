variable "instance_type" {
  type        = string
  description = "The EC2 instance type to use for the bastion host (e.g., t2.micro)."
}

variable "ami_id" {
  type        = string
  description = "The AMI ID to use for the bastion EC2 instance. Must include the SSM agent."
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where the bastion host will be deployed."
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet where the bastion EC2 instance will be deployed."
}

variable "name_prefix" {
  type        = string
  description = "Prefix to use for naming AWS resources like security group, instance, IAM roles."
}

variable "allowed_cidr_block" {
  type        = string
  description = "Prefix to use for naming AWS resources like security group, instance, IAM roles."
  default     = "0.0.0.0/0"
}

variable "allocated_storage" {
  type        = number
  description = "Allocated storage"
  default     = 20
}