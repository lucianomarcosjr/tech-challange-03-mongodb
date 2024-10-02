
# Terraform with GitHub Actions Integration

This repository demonstrates how to use **Terraform** for infrastructure management, integrated with **GitHub Actions** for CI/CD automation, and uses **GitHub Secrets** to securely manage sensitive data such as AWS credentials.

## Prerequisites

Before using this repository, you need to have the following:

- **Terraform** installed locally (if you plan to run it locally).
- **GitHub Secrets** properly configured with AWS credentials and MongoDB Atlas credentials.
- An AWS account with access to:
  - A **S3 bucket** for storing Terraform state.
  - Proper IAM permissions to create and manage AWS resources.
  
## Repository Structure

```plaintext
├── .github
│   └── workflows
│       └── terraform.yml   # GitHub Actions workflow file
├── main.tf                 # Main Terraform configuration
├── provider.tf             # Provider configuration (AWS, MongoDB Atlas)
├── variables.tf            # Terraform variables
├── outputs.tf              # Output variables (optional)
└── README.md               # This README file
```

## Configuring GitHub Secrets

You need to add the following secrets to your GitHub repository under **Settings > Secrets and Variables > Actions**:

| Secret Name                       | Description                                         |
| ---------------------------------- | --------------------------------------------------- |
| `AWS_ACCESS_KEY`                   | Your AWS Access Key ID                              |
| `AWS_SECRET_KEY`                   | Your AWS Secret Access Key                          |
| `AWS_REGION`                       | AWS region (e.g., `us-east-1`)                      |
| `MONGODB_ATLAS_PUBLIC_KEY`         | Public key for MongoDB Atlas                        |
| `MONGODB_ATLAS_PRIVATE_KEY`        | Private key for MongoDB Atlas                       |
| `MONGODB_USER`                     | MongoDB user                                        |
| `MONGODB_PASSWORD`                 | MongoDB password                                    |
| `ORG_ID`                           | MongoDB Atlas Organization ID                      |
| `PROJECT_NAME`                     | Name of the project being managed                   |

These secrets will be used by GitHub Actions to authenticate Terraform commands.

## GitHub Actions Workflow

The repository includes a GitHub Actions workflow defined in `.github/workflows/terraform.yml` that performs the following tasks:

- **Terraform Init**: Initializes the Terraform backend in S3.
- **Terraform Plan**: Creates a plan for applying Terraform changes.
- **Terraform Apply**: Automatically applies changes when a push is made to the `main` branch.
- **Terraform Destroy**: Optionally, you can configure the destroy step to remove all infrastructure when needed.

### Example Workflow

Here’s a breakdown of the important steps in the workflow:

```yaml
name: Terraform CI

on:
  push:
    branches: [main]

jobs:
  terraform:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v3

      - name: Set up Terraform
        uses: hashicorp/setup-terraform@v2

      - name: Configure AWS Credentials
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_KEY }}
          AWS_DEFAULT_REGION: ${{ secrets.AWS_REGION }}
        run: echo "AWS credentials configured"

      - name: Terraform Init
        run: terraform init
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_KEY }}
          AWS_DEFAULT_REGION: ${{ secrets.AWS_REGION }}

      - name: Terraform Plan
        run: terraform plan
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_KEY }}
          AWS_DEFAULT_REGION: ${{ secrets.AWS_REGION }}
          TF_VAR_aws_access_key: ${{ secrets.AWS_ACCESS_KEY }}
          TF_VAR_aws_secret_key: ${{ secrets.AWS_SECRET_KEY }}
          TF_VAR_aws_region: ${{ secrets.AWS_REGION }}
          TF_VAR_mongodb_atlas_public_key: ${{ secrets.MONGODB_ATLAS_PUBLIC_KEY }}
          TF_VAR_mongodb_atlas_private_key: ${{ secrets.MONGODB_ATLAS_PRIVATE_KEY }}
          TF_VAR_org_id: ${{ secrets.ORG_ID }}
          TF_VAR_project_name: ${{ secrets.PROJECT_NAME }}
          TF_VAR_mongodb_user: ${{ secrets.MONGODB_USER }}
          TF_VAR_mongodb_password: ${{ secrets.MONGODB_PASSWORD }}

      - name: Terraform Destroy
        if: github.ref == 'refs/heads/main'
        run: terraform destroy -auto-approve
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_KEY }}
          AWS_DEFAULT_REGION: ${{ secrets.AWS_REGION }}
          TF_VAR_aws_access_key: ${{ secrets.AWS_ACCESS_KEY }}
          TF_VAR_aws_secret_key: ${{ secrets.AWS_SECRET_KEY }}
          TF_VAR_aws_region: ${{ secrets.AWS_REGION }}
          TF_VAR_mongodb_atlas_public_key: ${{ secrets.MONGODB_ATLAS_PUBLIC_KEY }}
          TF_VAR_mongodb_atlas_private_key: ${{ secrets.MONGODB_ATLAS_PRIVATE_KEY }}
          TF_VAR_org_id: ${{ secrets.ORG_ID }}
          TF_VAR_project_name: ${{ secrets.PROJECT_NAME }}
          TF_VAR_mongodb_user: ${{ secrets.MONGODB_USER }}
          TF_VAR_mongodb_password: ${{ secrets.MONGODB_PASSWORD }}

      - name: Terraform Apply
        if: github.ref == 'refs/heads/main'
        run: terraform apply -auto-approve
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_KEY }}
          AWS_DEFAULT_REGION: ${{ secrets.AWS_REGION }}
          TF_VAR_aws_access_key: ${{ secrets.AWS_ACCESS_KEY }}
          TF_VAR_aws_secret_key: ${{ secrets.AWS_SECRET_KEY }}
          TF_VAR_aws_region: ${{ secrets.AWS_REGION }}
          TF_VAR_mongodb_atlas_public_key: ${{ secrets.MONGODB_ATLAS_PUBLIC_KEY }}
          TF_VAR_mongodb_atlas_private_key: ${{ secrets.MONGODB_ATLAS_PRIVATE_KEY }}
          TF_VAR_org_id: ${{ secrets.ORG_ID }}
          TF_VAR_project_name: ${{ secrets.PROJECT_NAME }}
          TF_VAR_mongodb_user: ${{ secrets.MONGODB_USER }}
          TF_VAR_mongodb_password: ${{ secrets.MONGODB_PASSWORD }}
```

### Workflow Steps:
1. **Checkout repository**: Pulls the code from the GitHub repository.
2. **Set up Terraform**: Sets up the Terraform CLI using the HashiCorp action.
3. **Configure AWS Credentials**: Exports AWS credentials needed to interact with AWS services (S3 backend, EC2, etc.).
4. **Terraform Init**: Initializes Terraform by configuring the backend (`S3` in this case).
5. **Terraform Plan**: Generates and displays an execution plan without making any changes.
6. **Terraform Apply**: Automatically applies the changes when a push is made to the `main` branch.
7. **Terraform Destroy**: Optionally configured to automatically remove resources. Use with caution.

## Terraform Backend Configuration

In the `provider.tf` file, the following configuration is used to set up **S3** as the backend for Terraform state:

```hcl
terraform {
  backend "s3" {
    bucket = "<your-bucket>"
    key    = "terraform-mongodb.tfstate"
    region = "<your-bucket's-region>"
  }
}
```

This configuration ensures that the state of your infrastructure is stored in a remote S3 bucket, allowing for collaboration and state locking.

## Running Terraform Locally

If you want to run Terraform locally instead of relying on GitHub Actions:

1. Install [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) on your machine.
2. Ensure that you have set your AWS credentials locally:
   ```bash
   export AWS_ACCESS_KEY_ID=<your-access-key>
   export AWS_SECRET_ACCESS_KEY=<your-secret-key>
   export AWS_DEFAULT_REGION=<your-default-region>
   ```
3. Run the following commands:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Conclusion

This repository demonstrates a complete CI/CD integration with **Terraform** and **GitHub Actions**, making it easy to automate infrastructure changes and store Terraform state in **S3**. By using **GitHub Secrets**, sensitive information is securely managed and not exposed in the repository.
