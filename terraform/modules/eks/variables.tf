variable "aws_region" {
  description = "AWS region to deploy EKS cluster"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "k8s_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.29"
}

variable "vpc_id" {
  description = "VPC ID to deploy EKS into"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs (preferably private)"
  type        = list(string)
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "project" {
  description = "Project identifier"
  type        = string
}
