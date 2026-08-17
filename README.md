# Terraform CI/CD

## Clone the Repository

```bash
git clone https://github.com/ShalinTimalsina/Terraform_CI-CD.git
cd Terraform_CI-CD
```

## Before Running

First, create an **S3 bucket** in your AWS account. This bucket will be used to store the Terraform remote state.

After creating the bucket, copy its **bucket name**. You will add this name to the `TF_STATE_BUCKET` GitHub Secret below.

## GitHub Secrets

Go to:

**Repository → Settings → Secrets and variables → Actions → Secrets**

Add the following secrets:

| Secret Name             | Value                                             |
| ----------------------- | ------------------------------------------------- |
| `AWS_ACCESS_KEY_ID`     | AWS Access Key ID                                 |
| `AWS_SECRET_ACCESS_KEY` | AWS Secret Access Key                             |
| `TF_STATE_BUCKET`       | Name of the S3 bucket created for Terraform state |

## GitHub Variables

Go to:

**Repository → Settings → Secrets and variables → Actions → Variables**

Add:

| Variable Name | Value                              |
| ------------- | ---------------------------------- |
| `AWS_REGION`  | Your AWS region, e.g. `ap-south-1` |

## AWS Credentials

Create an IAM user in your AWS account and generate an **Access Key ID** and **Secret Access Key**.

Add these values to the corresponding GitHub Secrets.

> **Do not commit your AWS Access Key ID or Secret Access Key to the repository.**

## Run the Terraform Workflow

After configuring the S3 bucket, GitHub Secrets, and GitHub Variable, the Terraform code is already present in the repository.

Since GitHub Actions is configured to run on a **push to the `main` branch**, you can trigger the workflow by creating an empty commit:

```bash
git commit --allow-empty -m "Trigger Terraform workflow"
git push origin main
```

This creates a commit without changing any files and triggers the GitHub Actions workflow.

The workflow will then run:

```text
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

## Destroy Resources

The **Terraform Destroy** workflow can be run manually from:

**GitHub → Actions → Terraform Destroy → Run workflow**

This will use the same remote Terraform state stored in the S3 bucket and destroy the resources managed by Terraform.
