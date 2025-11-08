# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Terraform module repository. The repository follows standard Terraform module conventions.

## Repository Structure

Terraform modules typically follow this structure:
- Root-level `.tf` files define the module's main resources
- `variables.tf` - Input variable declarations
- `outputs.tf` - Output value declarations
- `main.tf` - Primary resource definitions
- `versions.tf` - Terraform and provider version constraints
- `examples/` directory - Example usage of the module
- `modules/` directory - Nested sub-modules (if applicable)

## Common Commands

### Terraform Operations
```bash
# Initialize the module (download providers and modules)
terraform init

# Validate configuration syntax
terraform validate

# Format code to canonical style
terraform fmt -recursive

# Plan infrastructure changes
terraform plan

# Apply infrastructure changes
terraform apply

# Destroy infrastructure
terraform destroy
```

### Development Workflow
```bash
# Format all Terraform files
terraform fmt -recursive

# Validate configuration
terraform validate

# Run static analysis (if tflint is installed)
tflint
```

### Testing
If examples are present, test the module by:
```bash
cd examples/<example-name>
terraform init
terraform plan
```

## Development Guidelines

### Terraform Best Practices
- Use semantic versioning for provider and Terraform version constraints
- Declare all variables in `variables.tf` with descriptions and types
- Export useful values via `outputs.tf` with descriptions
- Use consistent naming conventions (snake_case for resources and variables)
- Tag resources appropriately for organization and cost tracking
- Avoid hardcoded values; use variables instead
- Use data sources for dynamic lookups rather than hardcoded values
- **Do not use deprecated features** according to the official Terraform documentation

### Resource Naming Conventions
- Use `this` as the resource identifier consistently throughout the project
- Only use identifiers other than `this` when distinction is absolutely necessary
- This applies to all resource types: `resource "aws_vpc" "this"`, `resource "aws_s3_bucket" "this"`, etc.
- Resource type differentiation happens at the Terraform resource level, not the identifier level

Example:
```hcl
# Good - Use 'this' consistently
resource "aws_vpc" "this" { }
resource "aws_internet_gateway" "this" { }
resource "aws_s3_bucket" "this" { }

# Avoid - Only use descriptive names when absolutely necessary for distinction
resource "aws_vpc" "main" { }          # Not preferred
resource "aws_s3_bucket" "flow_logs" { # Not preferred
```

### File Organization
- Keep `variables.tf`, `outputs.tf`, and `versions.tf` separate from resource definitions
- Group related resources together in the same `.tf` file or use separate files for clarity
- Use meaningful file names that reflect the resources they contain
