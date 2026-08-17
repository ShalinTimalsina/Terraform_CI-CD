# Terraform CI/CD

A simple Terraform CI/CD project using **GitHub Actions** and **AWS**.

## Clone the Repository

```bash id="4l6xhz"
git clone https://github.com/ShalinTimalsina/Terraform_CI-CD.git
cd Terraform_CI-CD
```

## Before Running

First, create an **S3 bucket** in your AWS account. This bucket will be used to store the Terraform remote state.

> The S3 bucket must already exist before running the Terraform workflow.

For example, you can create a bucket with a name like:

```text id="j4zq6v"
remote-backend-bucket-5678
```

After creating the bucket, **copy the bucket name exactly as it appears in AWS**.

For example:

```text id="2uk0d4"
remote-backend-bucket-5678
```

You will add this value to the `TF_STATE_BUCKET` GitHub Secret.

## GitHub Secrets

Go to:

**Repository → Settings → Secrets and variables → Actions → Secrets**

Add the following secrets:

| Secret Name             | Value                 |
| ----------------------- | --------------------- |
| `AWS_ACCESS_KEY_ID`     | AWS Access Key ID     |
| `AWS_SECRET_ACCESS_KEY` | AWS Secret Access Key |
| `TF_STATE_BUCKET`       | Your S3 bucket name   |

Example:

| Secret Name             | Example Value                |
| ----------------------- | ---------------------------- |
| `AWS_ACCESS_KEY_ID`     | `AKIA...`                    |
| `AWS_SECRET_ACCESS_KEY` | `********`                   |
| `TF_STATE_BUCKET`       | `remote-backend-bucket-5678` |

## GitHub Variables

Go to:

**Repository → Settings → Secrets and variables → Actions → Variables**

Add:

| Variable Name | Value           |
| ------------- | --------------- |
| `AWS_REGION`  | Your AWS region |

Example:

```text id="1x3t6s"
AWS_REGION = ap-south-1
```

## AWS Credentials

Create an IAM user in your AWS account and generate an **Access Key ID** and **Secret Access Key**.

Add these values to the corresponding GitHub Secrets.

The IAM user must have sufficient permissions to access the S3 state bucket and create, manage, and destroy the AWS resources defined in this Terraform project.

> **Do not commit your AWS Access Key ID or AWS Secret Access Key to the repository.**

## Run the Terraform Workflow

After configuring the S3 bucket, GitHub Secrets, and GitHub Variable, you can run the Terraform workflow directly from GitHub.

Go to:

**GitHub → Actions → Terraform CI/CD → Run workflow**

Select the `main` branch and click **Run workflow**.

The workflow will run:

```text id="w5gk0m"
Terraform Init
      ↓
Terraform Format Check
      ↓
Terraform Validate
      ↓
Terraform Plan
      ↓
Terraform Apply
```

You do **not** need to make any changes to the Terraform files just to run the workflow.

### Automatic Trigger

The workflow also runs automatically when changes are pushed to `main` that modify:

* Terraform files (`*.tf`)
* `.terraform.lock.hcl`
* The Terraform GitHub Actions workflow file

For example:

```bash id="5y3gaj"
git add .
git commit -m "Update Terraform configuration"
git push origin main
```

Changes such as `README.md` updates will **not** trigger the Terraform workflow.

## Destroy Resources

The **Terraform Destroy** workflow can be run manually from:

**GitHub → Actions → Terraform Destroy → Run workflow**

It uses the same remote Terraform state stored in the S3 bucket and destroys the resources managed by Terraform.

> **Warning:** Terraform Destroy will delete the infrastructure managed by this Terraform state. Use it carefully.
