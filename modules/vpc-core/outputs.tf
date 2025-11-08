output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = aws_vpc.this.arn
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}

output "vpc_secondary_cidr_blocks" {
  description = "List of secondary CIDR blocks associated with the VPC"
  value       = [for assoc in aws_vpc_ipv4_cidr_block_association.this : assoc.cidr_block]
}

output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = var.enable_igw ? aws_internet_gateway.this[0].id : null
}

output "igw_arn" {
  description = "The ARN of the Internet Gateway"
  value       = var.enable_igw ? aws_internet_gateway.this[0].arn : null
}

output "flow_log_id" {
  description = "The ID of the VPC Flow Log"
  value       = var.enable_flow_log ? aws_flow_log.this[0].id : null
}

output "flow_log_s3_bucket_name" {
  description = "The name of the S3 bucket for VPC Flow Logs"
  value       = var.enable_flow_log ? aws_s3_bucket.this[0].id : null
}

output "flow_log_s3_bucket_arn" {
  description = "The ARN of the S3 bucket for VPC Flow Logs"
  value       = var.enable_flow_log ? aws_s3_bucket.this[0].arn : null
}
