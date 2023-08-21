# Terraform AWS Infrastructure Repository

This repository contains Terraform configurations for provisioning and managing AWS infrastructure in both production (prod) and user acceptance testing (uat) environments. It also includes reusable modules in the `modules` folder for creating common infrastructure components.

## Folder Structure

The repository has the following folder structure:

- `prod/`: Contains Terraform configurations and variables for the production environment.
  - `main.tf`: Main Terraform configuration for the production environment.
  - `variables.tf`: Variable definitions specific to the production environment.
  - `prod.tfvars`: Variable values for the production environment.

- `uat/`: Contains Terraform configurations and variables for the user acceptance testing environment.
  - `main.tf`: Main Terraform configuration for the UAT environment.
  - `variables.tf`: Variable definitions specific to the UAT environment.
  - `uat.tfvars`: Variable values for the UAT environment.

- `modules/`: Contains reusable Terraform modules for creating common infrastructure components.

## Usage

### Setting Up AWS Credentials

Before using this repository, ensure that you have AWS credentials configured on your system. You can set up credentials using the AWS CLI or environment variables. Refer to the [AWS documentation](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html) for detailed instructions.

### Provisioning Infrastructure

1. Navigate to the `prod/` or `uat/` directory based on the environment you want to work with:
   ```
   cd prod/    # For the production environment
   # OR
   cd uat/     # For the UAT environment
   ```

2. Initialize the Terraform configuration:
   ```
   terraform init
   ```

3. Review the variables defined in `variables.tf` and customize them as needed.

4. Apply the Terraform configuration using the respective `.tfvars` file:
   ```
   terraform apply -var-file=<environment>.tfvars
   ```
   Replace `<environment>` with `prod` or `uat` based on the environment you are provisioning.

### Destroying Infrastructure

To tear down the infrastructure created by Terraform, you can use the following steps:

1. Navigate to the appropriate environment directory (`prod/` or `uat/`).

2. Run the following command to destroy the infrastructure:
   ```
   terraform destroy -var-file=<environment>.tfvars
   ```
   Replace `<environment>` with `prod` or `uat`.

## Important Notes

- Make sure to review and customize the variables and configurations in the `.tf` and `.tfvars` files before applying any changes.

- Each environment folder has a main.tf that calls the resusable modules from `modules/` , set resource count values as 1 or 0 which will include or ignore the resource, respectively, while terraform plan/apply. 

- Use caution when destroying infrastructure with `terraform destroy`, as it will permanently delete resources.

- The `modules/` folder contains reusable modules that can be used in both production and UAT environments. Make sure to customize the module variables and configurations as needed. 

- Always follow best practices for version control and collaboration when working with infrastructure as code.

For any questions or issues related to this repository, please reach out to the repository owner or maintainers.
