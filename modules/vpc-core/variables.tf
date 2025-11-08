variable "vpc_name" {
  description = "VPC name in format: <Servicegroup>-<projectID>-<Env>-vpc"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+-[a-z0-9]+-[a-z0-9]+-vpc$", var.vpc_name))
    error_message = "VPC name must follow the format: <Servicegroup>-<projectID>-<Env>-vpc (e.g., myservice-proj01-dev-vpc). Only lowercase letters, numbers, and hyphens are allowed."
  }
}

variable "cidr_block" {
  description = "CIDR block for VPC"
  type        = string

  validation {
    condition     = can(cidrhost(var.cidr_block, 0))
    error_message = "CIDR block must be a valid IPv4 CIDR notation (e.g., 10.0.0.0/16)."
  }
}

variable "secondary_cidr_blocks" {
  description = "List of secondary CIDR blocks to associate with the VPC"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for cidr in var.secondary_cidr_blocks : can(cidrhost(cidr, 0))
    ])
    error_message = "All secondary CIDR blocks must be valid IPv4 CIDR notation (e.g., 10.1.0.0/16)."
  }
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "enable_flow_log" {
  description = "Enable VPC Flow Logs"
  type        = bool
  default     = false
}

variable "enable_igw" {
  description = "Enable Internet Gateway"
  type        = bool
  default     = false
}

variable "flow_log_retention_days" {
  description = "Number of days to retain flow logs in S3"
  type        = number
  default     = 30

  validation {
    condition     = var.flow_log_retention_days > 0
    error_message = "Flow log retention days must be greater than 0."
  }
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
