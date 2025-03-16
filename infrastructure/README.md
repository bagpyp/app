# Terraform GCP Template

This repository is a template for deploying your Cloud Run service on Google Cloud Platform (GCP) using Terraform.

## Prerequisites

1. **GCP Project Setup**
   - Set up Google Cloud with a payment method and a gmail account by visiting https://console.cloud.google.com/welcome/new?pli=1
   - Note down your Billing ID shown here: https://console.cloud.google.com/billing
   - Install the `gcloud` CLI SDK with brew
      ```shell
      brew install --cask google-cloud-sdk
      ```

2. **Create a Bucket for Terraform State**
   - Use the following command to create a bucket for your Terraform state. Replace `my-gcp-project` with your project ID and adjust the bucket name if needed:
     ```bash
     gcloud storage buckets create gs://tf-state-my-gcp-project --location=us-central1
     ```
   - The bucket name (`tf-state-my-gcp-project`) is hard-coded in the `backend` block in `main.tf`.

3. **Terraform Authentication**
   - Authenticate with GCP to allow Terraform to manage resources:
     ```bash
     gcloud auth application-default login
     ```

4. **Docker Build and Push**
   Terraform handles your infrastructure, but deploying your application requires you to build and push a Docker image:
   
   - **Build the Docker Image:**
     Using the `Dockerfile` for the app, run:
     ```bash
     docker build -t gcr.io/my-gcp-project/my-app:latest .
     ```
     Replace `my-gcp-project` with your actual project ID and `my-app` with your application name.

   - **Authenticate Docker with GCP Container Registry:**
     This command configures Docker to use your GCP credentials:
     ```bash
     gcloud auth configure-docker
     ```
     
   - **Push the Docker Image:**
     Once built and authenticated, push your image:
     ```bash
     docker push gcr.io/my-gcp-project/my-app:latest
     ```

5. **Using the Repository Template**
   - Update `variables.tf` if necessary, especially the default project ID.
   - Adjust any module configuration in `main.tf` as needed.
   - Initialize Terraform:
     ```bash
     terraform init
     ```
   - Preview the changes:
     ```bash
     terraform plan
     ```
   - Apply the configuration:
     ```bash
     terraform apply
     ```

## Additional Notes

- **Backend Configuration:**  
  The Terraform backend in `main.tf` hardcodes the bucket name. If you need to change it, update the value in the file or use a separate backend configuration file during initialization.
  
- **CI/CD Integration:**  
  After your initial setup, consider integrating this template with a CI/CD pipeline to automate further deployments.

- **Docker & GCP Integration:**  
  Remember, while Terraform provisions your infrastructure, Docker commands are part of your application deployment workflow. Make sure you have your image built and pushed before applying Terraform changes that reference the image URL.

This repository serves as a boilerplate for a GCP project using Terraform. Customize it further based on your project's needs.
