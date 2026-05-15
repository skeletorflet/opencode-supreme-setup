---
name: terraform
description: HCL syntax, resources/data-sources, state management, modules, workspaces, plan/apply workflow, providers, remote backends.
---

## terraform

Infrastructure as code with Terraform.

### HCL syntax
- Blocks: resource, data, variable, output, provider
- Expressions: interpolation, functions, for_each, count
- Type constraints: string, number, bool, list, map, object

### State management
- Remote backends: S3, GCS, AzureRM, Terraform Cloud
- State locking with DynamoDB or consul
- terraform state commands for inspection
- Workspaces for environment isolation

### Modules
- Root module vs child modules
- Input variables and output values
- Module registry (public and private)
- Version constraints in required_providers

### Workflow
- terraform init, validate, plan, apply, destroy
- Plan output review before apply
- Terraform Cloud / Enterprise runs
- Policy as Code (Sentinel / OPA)
