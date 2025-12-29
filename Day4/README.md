# Terraform + AWS

## Day 4: AWS IAM Users, Policies & Access Management

This project demonstrates how to manage **AWS IAM users and policies using Terraform**.  
It covers **console access, programmatic access, managed policies, customer-managed policies, and inline policies**.

---

## 📌 What This Project Creates

### 👤 IAM Users
- 2 IAM users:
  - `ec2-user`
  - `vpc-user`

---

### 🔐 Console Access
- Console login enabled for both users
- Auto-generated passwords using Terraform
- Passwords marked as **sensitive outputs**

---

### 🔑 Programmatic Access
- Access keys created for both users:
  - Access Key ID
  - Secret Access Key (sensitive)

---

### 📜 Policies Attached

#### 1️⃣ AWS Managed Policies
| User | Policy |
|----|----|
| `ec2-user` | AmazonEC2FullAccess |
| `vpc-user` | AmazonVPCFullAccess |

---

#### 2️⃣ Customer Managed Policy (IAM User 1)
Attached to: **`ec2-user`**

Permissions:
- List all S3 buckets
- List objects inside buckets (object names only)

```json
{
  "Effect": "Allow",
  "Action": [
    "s3:ListAllMyBuckets",
    "s3:ListBucket"
  ],
  "Resource": "*"
}
```

#### 3️⃣ Inline Policy (IAM User 2)
Attached to: vpc-user

Permissions:
  - Full EC2 access (ec2:*)
  - Applies to all EC2 resources in the account

```json
{
  "Effect": "Allow",
  "Action": "ec2:*",
  "Resource": "*"
}
```
---

## Project Folder Structure

```bash
├── data.tf
├── main.tf
├── outputs.tf
├── provider.tf
├── README.md
├── terraform.tfvars
└── variables.tf
```
---

## ⚙️ Variables Used

```bash
| Variable                             | Description                     |
| ------------------------------------ | ------------------------------- |
| `region`                             | AWS region                      |
| `profile`                            | AWS CLI profile                 |
| `iam_user_1`                         | First IAM user                  |
| `iam_user_2`                         | Second IAM user                 |
| `policy_arn_iam_user_1`              | AWS managed policy for user 1   |
| `policy_arn_iam_user_2`              | AWS managed policy for user 2   |
| `customer_managed_policy_iam_user_1` | Name of customer-managed policy |
```

---

## 📤 Outputs

- AWS account alias
- Console passwords (sensitive)
- Access Key IDs
- Secret Access Keys (sensitive)

---

## 🧪 Testing IAM Policies (Policy Simulator)
- IAM policies do not require logging in as the IAM user to test them.
- IAM policies are **evaluated centrally by AWS**
- Simulator evaluates policy logic, not user sessions
- This is exactly how:
  - Security teams
  - Cloud engineers
  - Auditors  
test policies in real companies.

### How to Test:

1) Login to AWS Console using root or admin account
2) Go to IAM → Policy Simulator
3) Select the IAM user
4) Choose AWS services & actions
5) Simulate and verify Allow / Deny behavior

### 📍 Path:
```bash
AWS Console → IAM → Policy Simulator
```
**✔ This is the recommended AWS way to validate policies safely.**

---

## 🚀 How to Run

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
After terraform apply, verify:

- ✅ Go to AWS Console → IAM → Users → User Name
- ✅ Check Permissions tab → confirm managed, customer-managed, or inline policies are attached
- ✅ Check Security credentials tab → access keys & console access exist (or check this via selecting user and scrolling right for aws attributes)

(Optional)

- Use IAM Policy Simulator to validate permissions safely

## 🧹 Cleanup (Important)

To avoid AWS charges:
```bash
terraform destroy
```

## Why jsonencode()? 

- jsonencode() converts(encodes) Terraform HCL maps/lists into valid JSON
- AWS IAM APIs only accept JSON policy documents
- It avoids manual JSON formatting errors (quotes, commas, escaping)

👉 We write Terraform-style code, AWS receives pure JSON

## HCL vs JSON Comment Clarification 

- The policy block is written in HCL, so // comments are valid
- JSON does NOT allow comments, but Terraform removes them before converting via jsonencode()

👉 Result: Valid JSON is sent to AWS, comments never reach AWS

## 📌 Next Steps (Planned)

- IAM Groups
- IAM Roles
- Assume Role scenarios
- Best practices using groups instead of direct user policies

## 🏁 Summary

This project demonstrates:

- Real-world IAM user management
- Difference between managed, customer-managed & inline policies
- Secure handling of credentials in Terraform
- Policy testing without user login


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