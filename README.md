# go-automated-infra

[Set up terraform credentials to be able to run config locally](https://medium.com/@marouen.helali/terraform-credentials-setup-in-gcp-c81c8ebaff5d)


create an artifact registry repo to host our image:
```
gcloud artifacts repositories create hello-repo \
    --project=PROJECT_ID \
    --repository-format=docker \
    --location=LOCATION \
    --description="Docker repository"
```
publish go image container to Artifact Registry:
```
docker build . --tag us-west2-docker.pkg.dev/go-automated-infra/go-automated-infra-repo/go-automated-infra
docker push us-west2-docker.pkg.dev/go-automated-infra/go-automated-infra-repo/go-automated-infra
gcloud builds submit --tag us-west2-docker.pkg.dev/go-automated-infra/go-automated-infra-repo/go-automated-infra .
```

find a way to handle creds file being ignored in gcb build via the gitignore.


This will fail for not having GCB API enabled, and then fail again for GCB service account not having enough access:
```
gcloud projects add-iam-policy-binding LOCATION --member serviceAccount:GCB_ACCT@cloudbuild.gserviceaccount.com --role roles/storage.admin
```