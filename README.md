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


before running GCB:
give GCB access to create iam keys
```
gcloud projects add-iam-policy-binding go-automated-infra --member serviceAccount:799505015079@cloudbuild.iam.gserviceaccount.com --role roles/iam.serviceAccountUser
```

Use cloud builders community and edit it to upload the terraform builder image to artifact registry

to check your new GKE cluster run this to connect to it:
```
gcloud container clusters get-credentials cluster-1 --zone ZONE --project PROJECT_ID
```

TODO: automated GCB trigger creation for CI and apply