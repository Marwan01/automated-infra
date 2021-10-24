1. Set up the environment assuming you are using GCP project `PROJECT_NAME`:

```sh
export TF_ADMIN=${PROJECT_NAME}
export TF_CREDS=~/.config/gcloud/${PROJECT_NAME}.json
```

2. Create the Terraform service account:

```sh
gcloud iam service-accounts create terraform \
  --display-name "Terraform admin account"

gcloud iam service-accounts keys create ~/.config/gcloud/${PROJECT_NAME}.json \
  --iam-account terraform@${PROJECT_NAME}.iam.gserviceaccount.com
  ```

3. Grant the service account permission to view the Admin Project and manage Cloud Storage:

```sh
gcloud projects add-iam-policy-binding ${PROJECT_NAME} \
  --member serviceAccount:terraform@${PROJECT_NAME}.iam.gserviceaccount.com \
  --role roles/viewer

gcloud projects add-iam-policy-binding ${PROJECT_NAME} \
  --member serviceAccount:terraform@${PROJECT_NAME}.iam.gserviceaccount.com \
  --role roles/storage.admin
```

4. Any actions that Terraform performs require that the API be enabled to do so. In this guide, Terraform requires the following:

```sh
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable cloudbilling.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable serviceusage.googleapis.com
```

5. Configure your environment for the Google Cloud Terraform provider:

```sh
export GOOGLE_APPLICATION_CREDENTIALS=~/.config/gcloud/${PROJECT_NAME}.json
export GOOGLE_PROJECT=${PROJECT_NAME}
```


