# Cloud Terraform Infrastructure on AWS Lab

## Overview

This Lab is a project with the purpose of demonstrating and applying knowledge to create an AWS infrastructure using Terraform.

All resources are **Terraform-managed** no manual resources remain.

---

## Notes

## Done:

- **Core folder setup** although subject to change current folder structure allows for a clean vision of cloud infrastructure.
- **IaM user** IaM user setup so that Terraform deployments don't come from the root user (more user roles to be created for demonstration) 
- **VPC**
- **Security Groups** protect public and private resources 
- **Terraform Infrastructure as Code**
- **AWS networking concepts**
- **DNS management**
- **ACM certificate automation**
- **CloudFront CDN deployment**
- **multi-region Terraform providers**

## To do:
 
- **S3 + CloudFront** handle public-facing static content  
- **Route 53** points the domain to CloudFront  
- **Lambda** connects through API Gateway to **DynamoDB**  
- **CloudWatch** monitors Lambda, API Gateway, and DynamoDB  
 
---

## Terraform State Management (Complete)

The following resources **manage Terraform itself** (not part of application runtime):

- **S3 bucket:** `terraform-state-145023112872` → stores remote state  
- **DynamoDB table:** `terraform-locks` → prevents concurrent Terraform runs  



