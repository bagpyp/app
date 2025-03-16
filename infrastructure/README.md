# Infrastructure as Code

This repository is where you will store all your infrastructure changes.  Never modify resources directly in GCP.  Drive all your infrastructure with code and publish the changes using `terraform plan` and `terraform apply` instead.  This will ensure repeatable builds and robust application development throughout the SDLC.

## Prerequisites

**GCP Project Setup**
   - Set up Google Cloud with a payment method and a gmail account by visiting https://console.cloud.google.com/welcome/new?pli=1
   - Note down your Billing ID shown here: https://console.cloud.google.com/billing
   - Install the `gcloud` CLI SDK with brew
      ```shell
      brew install --cask google-cloud-sdk
      ```
     
**Terraform Authentication**
   - Authenticate with GCP to allow Terraform to manage resources:
     ```bash
     gcloud auth application-default login
     ```

## Automated Setup with setup.sh

This repository includes a setup script (`setup.sh`) that automates several steps of the GCP project configuration and Terraform backend setup. The script will:

- Prompt you for your desired GCP project name, region, and billing account ID.
- Open your browser to authenticate with Google.
- Create a new GCP project with a unique project ID.
- Link the project to your specified billing account.
- Enable necessary GCP services.
- Create a Cloud Storage bucket for storing your Terraform state file.
- Generate a `backend.config` file for Terraform initialization
- Initialize your local Terraform repo using said config
- Authenticate your local Docker server with GCP
- Build an initial image of the backend service and push it to the Artifact Registry in GCP
- Generate a .tfvars file to store your project_id, region and image_url for the container 

**Run the Script**  
   If not already executable, change the permission:
   ```bash
   chmod +x setup.sh
   ```
   Then, run it
   ```bash
   ./setup.sh
   ```

**Pouring Concrete**
   This is how you actually provision the cloud infrastructure needed for your application to run
   - Preview the cloud components that this IaC repo will provision:
     ```bash
     terraform plan
     ```
   - Provision them by applying the configuration:
     ```bash
     terraform apply -var-file=terraform.tfvars
     ```

## Additional Notes

- **CI/CD Integration:**  
  After your initial setup, the plan and apply steps should be automated using a CI/CD pipeline to trigger further deployments (only when files inside this file's parent repo change though).

- **Docker & GCP Integration:**  
  Remember, while Terraform provisions your infrastructure, Docker commands are part of your application deployment workflow. Any changes to your application logic will need to trigger a re-build and re-deploy of the image in GCP.  That should happen much, much more frequently than changes to your infrastructure.
