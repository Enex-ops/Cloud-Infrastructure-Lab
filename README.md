# GT3 Cloud
# GT3-Cloud

# GT3 Terraform Infrastructure

## Overview

This diagram represents the AWS infrastructure deployed via Terraform for the GT3 project.  
All resources are **Terraform-managed**—no CDK or manual resources remain.

---

## Infrastructure Diagram (ASCII)

      +---------------------+
      |       Client        |
      +---------+-----------+
                |
                v
      +---------------------+
      |    Route 53 DNS     |
      +---------+-----------+
                |
                v
      +---------------------+
      |    CloudFront CDN   |
      +---------+-----------+
                |
                v
      +---------------------+
      |      S3 Bucket      | <- Static assets / website files
      +---------+-----------+
                ^
                |
      +---------------------+
      |   Application LB    |
      +---------+-----------+
                |
      +---------+---------+
      |       VPC         |
      |------------------|
      | Public Subnets    |
      | Private Subnets   |
      +------------------+
      | Security Groups   |
      +------------------+
      | Lambda Functions  |
      +---------+--------+
                |
                v
      +---------------------+
      |   API Gateway       |
      +---------+-----------+
                |
                v
      +---------------------+
      |    DynamoDB Table   |
      +---------------------+
                ^
                |
      +---------------------+
      | CloudWatch Metrics  |
      +---------------------+


---

## Notes

- **VPC** contains compute resources (Lambda, API Gateway via private subnets)  
- **S3 + CloudFront** handle public-facing static content  
- **Route 53** points the domain to CloudFront  
- **Lambda** connects through API Gateway to **DynamoDB**  
- **CloudWatch** monitors Lambda, API Gateway, and DynamoDB  
- **Security Groups** protect public and private resources  

---

## Terraform State Management

The following resources **manage Terraform itself** (not part of application runtime):

- **S3 bucket:** `terraform-state-145023112872` → stores remote state  
- **DynamoDB table:** `terraform-locks` → prevents concurrent Terraform runs  

> **Tip:** All infrastructure should now be fully Terraform-managed.  
> No legacy CDK/CloudFormation stacks or buckets remain in the account.


