# CI/CD

The app comes complete with a CICD pipeline.  When commits are made to (or PRs are opened against) `main`, changes to files in the `backend/` repo trigger redeploys of the Backend Service cloud container (if tests pass). Alternatively (or additionally), changes made within the `infrastructure/` repo trigger infrastructure changes to take effect in GCP.

To make it possible for the GitHub Actions to take effect, issue the following commands to grant github the appropriate settings.

## Create a Service Account

Assign roles required for your CI/CD tasks (for example, permissions to build, deploy, and manage resources). Adjust the role(s) as needed:

```shell
gcloud iam service-accounts create ci-cd-sa --display-name="CI/CD Service Account"
```

## Grant Necessary Roles

_Note_: In production, you might want to grant only the minimal required roles (e.g., `roles/storage.admin`, `roles/cloudbuild.builds.editor`, `roles/artifactregistry.writer`, etc.).

```shell
gcloud projects add-iam-policy-binding $(gcloud config get-value project) \
  --member "serviceAccount:ci-cd-sa@$(gcloud config get-value project).iam.gserviceaccount.com" \
  --role "roles/editor"
```

```shell
gcloud projects add-iam-policy-binding $(gcloud config get-value project) \
  --member "serviceAccount:ci-cd-sa@$(gcloud config get-value project).iam.gserviceaccount.com" \
  --role="roles/secretmanager.secretAccessor"
```

## Generate a Service Account Key

Run the following command to create a JSON key file:

```shell
gcloud iam service-accounts keys create ~/key-$(gcloud config get-value project).json \
  --iam-account=ci-cd-sa@$(gcloud config get-value project).iam.gserviceaccount.com
```

## GitHub Action Secrets

1.	Open the `~key.json` file and copy its entire contents.
2.	In your GitHub repository, go to **Settings** → **Secrets and variables** → **Actions**.
3.	Create a new secret with the name `GCP_SA_KEY` and paste the JSON content as the value.
4.  🚨 Similarly, make sure to add `GCP_PROJECT_ID` and `GCP_REGION`.  You can find them both by CDing into the `infrastructure` repo and running `terraform output` 