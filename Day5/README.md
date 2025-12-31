# Terraform + AWS

## Day 5: Creating vpc + ec2's + sg's + (alb, alb listener, alb tg, alb tga)

## 📌 Project Overview

This repository contains a **Terraform-based AWS infrastructure project** that provisions a **highly available, secure, and production-style web architecture** using core AWS services.

The setup deploys a **public Application Load Balancer (ALB)** in front of **two private EC2 web servers** distributed across **two Availability Zones**, following AWS best practices.

---

## 🧱 Architecture Summary

> **Design Goal:**
> 
> -   High availability
>     
> -   Network isolation
>     
> -   Secure inbound/outbound traffic
>     
> -   Terraform-managed infrastructure
>     

### 🔹 Components Created

-   **Networking**
    
    -   VPC
        
    -   2 Public Subnets (Infra Tier)
        
    -   2 Private Subnets (Web Tier)
        
    -   Internet Gateway (IGW)
        
    -   NAT Gateway
        
    -   Public Route Table
        
    -   Private Route Table
        
-   **Security**
    
    -   ALB Security Group (Internet-facing)
        
    -   Web Tier Security Group (ALB → EC2 only)
        
-   **Compute**
    
    -   2 EC2 instances (private subnets)
        
    -   Nginx installed using `user_data`
        
-   **Load Balancing**
    
    -   Application Load Balancer (ALB)
        
    -   ALB Listener (HTTP : 80)
        
    -   Target Group
        
    -   Target Group Attachments
        

---

## 🗺️ High-Level Traffic Flow

```
Internet
   │
   ▼
Application Load Balancer (Public Subnets)
   │
   ▼
Target Group
   │
   ▼
EC2 Web Servers (Private Subnets, AZ-A & AZ-B)
   │
   ▼
NAT Gateway → Internet (Outbound Only)
```

---

## 🧩 Folder & File Structure

```
.
├── vpc.tf            # VPC, Subnets, IGW, NAT, Route Tables
├── security.tf       # Security Groups and Rules
├── compute.tf        # EC2 Instances (Web Tier)
├── app_infra.tf      # ALB, Listener, Target Group, Attachments
├── provider.tf       # provider (aws)
├── variables.tf      # Input Variables
├── outputs.tf        # Useful Outputs
└── README.md         # Project Documentation
```

---

## 🌐 Networking Design

### VPC

-   Custom CIDR block (user-defined)
    
-   DNS support and hostnames enabled
    

### Subnets

| Subnet Type | AZ | Purpose |
| --- | --- | --- |
| Public | AZ-A | ALB, NAT |
| Public | AZ-B | ALB |
| Private | AZ-A | Web EC2 |
| Private | AZ-B | Web EC2 |

### Routing

-   **Public Route Table** → `0.0.0.0/0` via IGW
    
-   **Private Route Table** → `0.0.0.0/0` via NAT Gateway
    

---

## 🔐 Security Design

### ALB Security Group

-   **Ingress**: HTTP (80) from `0.0.0.0/0`
    
-   **Egress**: Allow all outbound traffic
    

### Web Tier Security Group

-   **Ingress**: HTTP (80) **only from ALB Security Group**
    
-   **Egress**: Allow all outbound traffic
    

> 🚫 EC2 instances are **not publicly accessible**

---

## 🖥️ Compute Layer

-   Two EC2 instances deployed in **private subnets**
    
-   Instances are spread across **two Availability Zones**
    
-   Public IPs are disabled
    
-   Nginx is installed via `user_data`
    
-   Each instance serves a unique response identifying its AZ
    

---

## ⚖️ Load Balancer Configuration

-   **Type**: Application Load Balancer
    
-   **Scheme**: Internet-facing
    
-   **Listener**: HTTP on port 80
    
-   **Target Group**:
    
    -   Target Type: `instance`
        
    -   Health Check Path: `/`
        

Traffic is automatically distributed between both EC2 instances.

## Target Group, Listener, and Target Group Attachments

### 🔹 Target Group (TG)

# 

The **Target Group** defines **where the ALB should forward traffic**.  
In this project, the target group is configured with:

-   Target type as **EC2 instances**
    
-   Protocol **HTTP** on port **80**
    
-   Health checks on path `/` to ensure only healthy instances receive traffic
    

The ALB continuously monitors the health of registered targets and routes traffic only to healthy EC2 instances.

---

### 🔹 Listener

# 

The **Listener** acts as the **entry point for incoming requests** to the ALB.  
It listens on **port 80 (HTTP)** and defines rules to decide what action to take when traffic arrives.

In this setup:

-   The listener accepts HTTP traffic on port 80
    
-   All incoming requests are **forwarded to the target group**
    

---

### 🔹 Target Group Attachments (TGA)

# 

**Target Group Attachments** register actual EC2 instances with the target group.  
Using `for_each`, both EC2 instances (one in each AZ) are dynamically attached to the target group.

This enables:

-   Automatic load distribution across instances
    
-   Easy scalability by adding more instances in the future

---

## 📤 Outputs

After successful deployment, Terraform exposes the following outputs:

-   **VPC ID**
    
-   **Public Subnet IDs**
    
-   **Private Subnet IDs**
    
-   **ALB DNS Name** (used to access the application)
    

Example:

```
http://<alb-dns-name>
```

---

## 🚀 How to Deploy

### Prerequisites

-   AWS Account
    
-   Terraform >= 1.x
    
-   AWS CLI configured
    
---

## ⚠️ ALB 502 Bad Gateway – Important Note

During deployment, the Application Load Balancer returned **HTTP 502 (Bad Gateway)**.

**What it means:**  
`502 from ALB does NOT mean the ALB is down.`  
It means the **request reached the target (EC2)**, but the target **failed to return a valid HTTP response**.

**Root cause in this setup:**

-   EC2 instances were registered to the ALB target group
    
-   Health checks reached the instances
    
-   **Nginx was not running / not installed**, so no service was listening on the expected port
    
-   As a result, ALB marked targets unhealthy and returned **502**
    

**Key learning:**

-   ALB 502 = *Target-side failure*, not a load balancer failure
    
-   Always verify that:
    
    -   Application is installed and running
        
    -   Correct port is open
        
    -   Health check path returns `200 OK`
        

**Fix applied:**  
After enabling outbound internet access (via NAT Gateway), the `user_data` script successfully installed and started Nginx, targets became healthy, and traffic flow was restored.

**Note**
- ALB routes traffic using target group registrations (instance ID / IP) via AWS control plane.
If you’re getting 502, it means ALB successfully reached the EC2 target, but the application on the instance failed to respond properly.

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

## 🌐 Verify Deployment

- After terraform apply, copy the ALB DNS name from Terraform outputs and open it in a browser.
- You should see the Nginx response, and on refresh, traffic will alternate between Web Server 1 (AZ-A) and Web Server 2 (AZ-B), confirming successful load balancing.

## 🧹 Cleanup (Important)

To avoid AWS charges:
```bash
terraform destroy
```

---

## ⚠️ Design Notes & Considerations

-   A **single NAT Gateway** is used for cost optimization
    
-   For production workloads, consider:
    
    -   One NAT Gateway per AZ
        
    -   HTTPS (443) with ACM certificates
        
    -   Auto Scaling Groups instead of standalone EC2
        
    -   Remote backend for Terraform state
        

---

## 📚 Key Learnings from This Project

-   AWS VPC design using Terraform
    
-   Public vs Private subnet isolation
    
-   Secure ALB → EC2 communication
    
-   Terraform dependency resolution
    
-   Infrastructure as Code (IaC) best practices
    

---

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

---

## ⭐ Final Notes

If you find this project useful:

-   Star ⭐ the repository
    
-   Fork 🍴 and extend it
    
-   Use it as a base for production-grade architectures
    

---

Happy Terraforming 🚀


