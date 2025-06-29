#  CV Hosting on AWS with Terraform

This project demonstrates how to host a personal CV website using **Amazon S3** and **Terraform**.  
The website is a static HTML page (`index.html`) deployed via Infrastructure as Code (IaC).

---

## Project Overview

- **Goal:** Deploy a static resume (CV) webpage to AWS.
- **Tools Used:** Terraform, AWS S3, AWS CLI.
- **Hosting Type:** Static website (HTML only).
- **Infrastructure Style:** Fully automated with Terraform.

---

## Technologies Used

- **AWS S3:** To host the static HTML file publicly.
- **Terraform:** To define and deploy infrastructure as code.
- **AWS CLI:** To authenticate and connect Terraform to AWS.
- **HTML/CSS:** For the visual design of the CV.

---

## website Output 
```bash
http://raghad-cv-hosting-bucket.s3-website-us-east-1.amazonaws.com
```
---

### file structure 
cv-hosting/

- index.html         # Your CV webpage
- main.tf            # Terraform configuration for AWS S3
- outputs.tf         # Optional: to display the website URL
- .gitignore         # To exclude .terraform and tfstate files

---

### future improvements 

- Add CloudFront as a CDN for lower latency

- Buy and connect a custom domain via Route 53

-  Add HTTPS with an SSL certificate

 