variable "region" {
  type = string
  default = "us-east-1"
}

variable "ami_id" {
  type = string
}

variable "project" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "name_prefix" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "subnet_a_cidr" {
  type = string
}

variable "subnet_b_cidr" {
  type = string
}