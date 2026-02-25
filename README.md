# GT3 Cloud
# GT3-Cloud

# GT3 Cloud Infrastructure

## Architecture
- Bootstrap: Creates S3 remote state + DynamoDB locks
- Infrastructure: Main cloud resources

## Setup
1. Run bootstrap first: `cd Terraform\ Bootstrap && terraform apply`
2. Update backend.tf with your S3 bucket details
3. Run infrastructure: `cd Infrastructure && terraform init && terraform apply`

## State Management
- Remote state stored in S3 with DynamoDB locking
- Never commit .tfstate files (added to .gitignore)