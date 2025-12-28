# Terraform + AWS

## Day 3: EC2 Creation Using Existing VPC Data Source

This project demonstrates how to use Terraform variables, outputs, and data sources in a real-world scenario.

### Objective:

- Use an existing VPC with 2 public subnets, an Internet Gateway (IGW), and a route table. (Created manually via AWS console or using aws-cli)
  
- Create an EC2 instance with a key pair, security group, and user data using Terraform.
  
- Leverage data sources to read existing AWS resources without creating them.
  
- Make the Terraform code reusable using variables.
  
- Expose important information using outputs.

**This pattern is very common in real companies where:**
- Network is managed by one team
- Compute (EC2/ECS/EKS) is managed by another team

---

## 🔑 Prerequisites

Before running this project, ensure you have:

- An AWS account
- AWS CLI installed
- Terraform installed

## Project Folder Structure

```bash
ec2-data-source-project/
│
├── providers.tf       # AWS provider configuration
├── variables.tf      # Variables for reusable inputs
├── data.tf           # Data sources to read existing VPC, subnets
├── main.tf           # EC2 resource definition
├── outputs.tf        # Outputs for useful values
└── terraform.tfvars  # Variable values
```
## Steps:

### Step 1: Configure Variables

- Variables make the code configurable and reusable without changing the main Terraform files.

### Step 2: Read Existing AWS Resources Using Data Sources

- Terraform can read existing infra without creating it.
- Ensures the EC2 instance is attached to the correct VPC, subnet.
- Avoids hardcoding values like subnet IDs.

### Step 3: Create EC2 Instance

- subnet_id is dynamically read from data sources.
- Instance type and name are configured via variables.

### Step 4: Add Outputs

- Provides useful information after Terraform applies.
- Can be used as input for other Terraform projects or scripts.

## Data Sources: Tags & Filters

When using Terraform data sources to read existing AWS resources, you can narrow down results using tags and filters.

### 1️⃣ tags Block
```bash
data "aws_vpc" "example" {
  tags = {
    Name = "my-existing-vpc"
  }
}
```
- Purpose: Select resources based on AWS tags.
- How it works: Matches resources where the tag key/value equals what you specify (Name = my-existing-vpc).
- When to use: Simple lookups based purely on tags.

### 2️⃣ filter Block
```bash
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.example.id]
  }
}
```
- Purpose: Filter resources using any AWS attribute (like VPC ID, instance type, name, etc.)
- name → AWS resource field/attribute you want to filter on (e.g., vpc-id, group-name, tag:Name).
- values → List of acceptable values for that attribute. Terraform matches resources where the field equals any of the values.
- When to use: More flexible lookups beyond tags or when multiple conditions are needed.

## ✅ Key Differences

```bash
| Aspect          | `tags`              | `filter`                             |
| --------------- | ------------------- | ------------------------------------ |
| What it filters | AWS tags only       | Any AWS resource attribute           |
| Syntax          | Simple key-value    | `name` + `values` array              |
| Use case        | Quick lookup by tag | Complex or multiple criteria lookups |
```

## Using AWS-Provided AMIs with Data Sources

Instead of hardcoding AMI IDs, we use Terraform data sources to dynamically fetch the latest AWS-provided AMIs. This ensures the EC2 instance always launches with the most recent and official image.

**Ubuntu 24.04 Example**
```bash
data "aws_ami" "ubuntu_24_04" {
  most_recent = true
  owners      = ["099720109477"]  # Official Canonical (Ubuntu) owner

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-24.04-*-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
```

Explanation:

- owners → Limits results to official AMIs only.
- most_recent = true → Always selects the latest version.
- filter name="name" → Pattern match the desired OS/version.
- filter name="virtualization-type" → Ensures correct virtualization for EC2.

## Benefits:

- No hardcoding → Terraform automatically fetches the latest AMI.
- Secure & official → Only uses images from trusted owners.
- Reusable across regions → Update filters as needed without changing code.

## How to Find Owner & Filter Values

- Owners: Check AWS Console → EC2 → AMIs → Owner or official docs (e.g., Canonical owner for Ubuntu).
- Filters: Copy the Name pattern from AMI search in AWS Console or use official naming conventions.
  
## 🚀 Terraform Execution Steps

### Step 1: Initialize Terraform
```bash
terraform init
```
### Step 2: Format the Code
```bash
terraform fmt
```
### Step 3: Validate Configuration
```bash
terraform validate
```
### Step 4: Review Execution Plan
```bash
terraform plan
```
### Step 5: Apply Configuration
```bash
terraform apply
```
Type yes when prompted.

### Step 6: Verify outputs
```bash
terraform output
```

## 🌐 Verify Deployment
- The EC2 instance is bootstrapped using the user_data script to install and start Nginx automatically.
- After Terraform apply, access the EC2 public IP in a browser to confirm Nginx default page is running.
- This ensures that the instance is fully configured immediately after creation without manual intervention.
- In the AWS Console, select the EC2 instance and go to the Networking section.
- You can verify the VPC ID and Subnet ID to ensure it matches the data sources used in Terraform.

## 🧹 Cleanup (Important)

To avoid AWS charges:
```bash
terraform destroy
```

## Key Learnings

- Data Sources: Access existing AWS infrastructure without creating it.
- Variables: Make code configurable and reusable.
- Outputs: Expose useful information for monitoring, CI/CD, or other Terraform modules.
- Terraform Best Practice: Read existing infra first, then provision new resources in the same VPC.

## 🚫 Files Not to be Committed to GitHub

The following files and directories are intentionally excluded using `.gitignore`:

- **`terraform.tfstate`**
- **`terraform.tfstate.backup`**
- **`.terraform/` directory**

### ❓ Why are these excluded?

- These files contain **sensitive infrastructure details** such as resource IDs, IP addresses, and metadata(security risk).
- They are **auto-generated by Terraform** during `terraform init` and `terraform apply`.
- Terraform can **recreate them locally**, so committing them is unnecessary and unsafe.


## ⭐ Author

**Shobhit Batra** <br>
**Learning Terraform & Cloud | DevOps Enthusiast**