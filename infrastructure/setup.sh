#!/bin/bash

cd "$(dirname "$0")" || exit 1

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

read -p "Proceed with creating project (will open browser to authenticate with Google)? (y/n): " confirm
if [[ $confirm != "y" ]]; then
  echo "Setup aborted."
  exit 1
fi

# Interactive GCP login
gcloud auth login

# Create unique project ID with random 5-digit code
RANDOM_SUFFIX=$(( ( RANDOM % 90000 ) + 10000 ))
PROJECT_ID="${PROJECT_NAME}-${RANDOM_SUFFIX}"

echo "Creating project: ${PROJECT_ID} in region: ${REGION}"

# Create project
gcloud projects create "${PROJECT_ID}" --name="${PROJECT_NAME}"

# Set current project
gcloud config set project "${PROJECT_ID}"

# Link billing account
gcloud billing projects link "${PROJECT_ID}" --billing-account="${BILLING_ACCOUNT_ID}"

# Enable necessary APIs
gcloud services enable \
  storage.googleapis.com \
  cloudbuild.googleapis.com \
  artifactregistry.googleapis.com \
  run.googleapis.com \
  sqladmin.googleapis.com \
  vpcaccess.googleapis.com \
  secretmanager.googleapis.com \
  servicenetworking.googleapis.com

# Create Terraform state bucket
BUCKET_NAME="tf-state-${PROJECT_ID}"
gsutil mb -p "${PROJECT_ID}" -l "${REGION}" -b on "gs://${BUCKET_NAME}"

echo "Creating Terraform backend config file with bucket: ${BUCKET_NAME}"

cat <<EOF > backend.config
bucket = "${BUCKET_NAME}"
prefix = "terraform/state"
EOF

echo "✅ Project setup complete!"
echo "  Project ID: ${PROJECT_ID}"
echo "  Terraform state bucket: gs://${BUCKET_NAME}"

# Create Artifact Registry repository for Docker images
REPO_NAME="backend-repo"
echo "Creating Artifact Registry repository: ${REPO_NAME} in region: ${REGION}"
gcloud artifacts repositories create "${REPO_NAME}" \
    --repository-format=docker \
    --location="${REGION}" \
    --description="Docker repository for backend images"

# Build the Docker image using the Dockerfile in your repository
# Artifact Registry image URL format: REGION-docker.pkg.dev/PROJECT_ID/REPO_NAME/IMAGE:TAG
CONTAINER_URL="${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO_NAME}/backend:latest"
echo "Building Docker image: ${CONTAINER_URL}"
docker build --platform linux/amd64 -t "${CONTAINER_URL}" ../backend

# Authenticate Docker to use Artifact Registry
echo "Authenticating Docker with Artifact Registry..."
gcloud auth configure-docker "${REGION}-docker.pkg.dev"

# Push the image to Artifact Registry
echo "Pushing Docker image to Artifact Registry..."
docker push "${CONTAINER_URL}"

# Dynamically create terraform.tfvars file with necessary variables
cat <<EOF > terraform.tfvars
project_id = "${PROJECT_ID}"
region     = "${REGION}"
image_url  = "${CONTAINER_URL}"
EOF
echo "Terraform variable definitions file 'terraform.tfvars' created."

# Initialize Terraform using the generated backend configuration
terraform init -backend-config=backend.config