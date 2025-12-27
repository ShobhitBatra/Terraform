# Using Multiple AWS Accounts with Terraform

This guide shows how to safely switch between multiple AWS accounts for Terraform and AWS CLI.

---

## 1. Keep Old Account as Default

Your existing account is already configured:

```bash
aws configure
```
- This creates the default profile in ~/.aws/credentials.
- All your current Terraform projects using no profile will use this account.

## 2. Add a New Profile for Demo Account

```bash
aws configure --profile demo
```
Then enter the Access Key, Secret Key, region, and output format for your new demo account.
This creates a demo profile in ~/.aws/credentials.

Now you have:

- default → your old account
- demo → your new account

## 3. Tell Terraform Which Profile to Use

### Option A – Inside the provider block (per project)

```bash
provider "aws" {
  region  = "us-east-1"
  profile = "demo"   # Uses demo account
}
```
✅ Terraform will always use the demo account for this project.

### Option B – Using Environment Variable (temporary)

```bash
export AWS_PROFILE=demo
terraform plan
terraform apply
```
Terraform will pick the demo profile for this session.

To switch back to default account:
```bash
unset AWS_PROFILE
```

## ⚠️ Tips

- Always use profiles instead of exporting keys directly for safety.
- Keep a separate provider block per Terraform project if using multiple accounts.
- For multiple accounts in the same project, consider workspaces or modules with different profiles.