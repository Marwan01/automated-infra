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
 gcloud builds submit \
    --tag LOCATION-docker.pkg.dev/PROJECT_ID/hello-repo/helloworld-gke .
```