# CV Hosting on AWS – Terraform-based Cloud Deployment

This project showcases how to host a personal CV website using a scalable and production-like cloud architecture with **Amazon Web Services (AWS)** and **Terraform**.  
It includes both **S3 static hosting** and **EC2 auto-scaled deployment**, fully provisioned through Infrastructure as Code (IaC).

---

## Project Objectives

- Deploy a **static CV website** in the cloud.
- Use **Terraform** for full automation.
- Ensure high availability, global accessibility, and scalability.
- Implement both **S3 + CloudFront** and **EC2 with Load Balancer + Auto Scaling** solutions.

---

## Technologies & Services Used

| Service          | Purpose                                      |
|------------------|----------------------------------------------|
| **Amazon S3**    | Static website hosting for `index.html`.     |
| **CloudFront**   | CDN to cache and serve content globally.     |
| **EC2**          | Backend hosting for auto-scaled environments.|
| **ALB**          | Load balancing across EC2 instances.         |
| **Auto Scaling** | Automatically adjusts number of EC2s.        |
| **Terraform**    | Infrastructure as Code to provision AWS.     |
| **IAM**          | Secure access management for automation.     |
| **HTML/CSS**     | Front-end for the CV design.                 |

---

## Project Output Links
CV website (CV Hosted on S3)

```bash
http://raghad-cv-hosting-bucket.s3-website-us-east-1.amazonaws.com

```
Static hosting of the CV webpage using Amazon S3 (EC2 Instance Test Page)

```bash
http://44.204.120.179

```
Apache running on a single EC2 instance as part of the backend infrastructure (Load Balancer URL)

```bash
http://cv-alb-1432520488.us-east-1.elb.amazonaws.com

```
Application Load Balancer distributing traffic between multiple EC2 instances to ensure high availability and auto scaling (CloudFront Distribution)
```bash
https://d2i8soqm4xrnh2.cloudfront.net

```

---

 ## How to Deploy Locally

 Clone the repo

```bash
git clone https://github.com/RaghadIU/CV-hosting.git
```
```bash
cd CV-hosting
```
Initialize Terraform

```bash
terraform init

```
Preview Infrastructure Changes

```bash
terraform plan

```
Apply the infrastructure

```bash
terraform apply

```
---

## future improvements 

- Add a custom domain via Route 53.

- Enable HTTPS for both ALB and CloudFront using SSL.

- Add CI/CD for automated CV updates.
