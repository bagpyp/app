#!/bin/bash

# Interactive prompts for input if not provided via command line
read -p "Enter your desired GCP Project Name [default: project]: " PROJECT_NAME
read -p "Enter your preferred GCP Region [default: us-central1]: " REGION
read -p "Enter your GCP Billing Account ID: " BILLING_ACCOUNT_ID

# Set defaults if input was empty
PROJECT_NAME=${PROJECT_NAME:-project}
REGION=${REGION:-us-central1}

# Confirm details with user
echo ""
echo "Configuration:"
echo "  Project Name: $PROJECT_NAME"
echo "  Region: $REGION"
echo "  Billing Account ID: $BILLING_ACCOUNT_ID"
echo ""

read -p "Proceed with creating project? (y/n): " confirm
if [[ $confirm != "y" ]]; then
  echo "Setup aborted."
  exit 1
fi

# Interactive GCP login
gcloud auth login

# Create unique project ID with timestamp
PROJECT_ID="${PROJECT_NAME}-$(date +%s)"

echo "Creating project: ${PROJECT_ID} in region: ${REGION}"

# Create project
gcloud projects create "${PROJECT_ID}" --name="${PROJECT_NAME}"

# Set current project
gcloud config set project "${PROJECT_ID}"

# Link billing account
gcloud billing projects link "${PROJECT_ID}" --billing-account="${BILLING_ACCOUNT_ID}"

# Enable necessary APIs
gcloud services enable compute.googleapis.com \
  storage.googleapis.com \
  cloudbuild.googleapis.com \
  artifactregistry.googleapis.com \
  run.googleapis.com

# Create Terraform state bucket
BUCKET_NAME="tf-state-${PROJECT_ID}"
gsutil mb -p "${PROJECT_ID}" -l "${REGION}" -b on "gs://${BUCKET_NAME}"

echo "✅ Project setup complete!"
echo "  Project ID: ${PROJECT_ID}"
echo "  Terraform state bucket: gs://${BUCKET_NAME}"