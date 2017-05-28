# Deployment to GCP Container Engine

Ruby on Rails + CloudSQL (CloudSQL proxy).

## Requirements

- gcloud
- kubectl
- envsubst
- Docker for Mac

### envsubst(gettext) install

For mac.

```
$ brew install gettext
$ brew link --force gettext
```

## CloudSQL setting

- Created a CloudSQL instance.
  - Select **Access Control** > **Users**. Find the root user and select **Change password**
  - Input password (ex. `pass`, ref: `config/database.yml`) and click OK.
- Created a [service account](https://console.cloud.google.com/iam-admin/serviceaccounts/project).
  - Click **Create service account**.
  - In the Create service account dialog, provide a descriptive name for the service account(ex. `sample-sql`).
  - For Role, select **Cloud SQL** > **Cloud SQL Client**.
  - Click Furnish a new private key(JSON).
  - Click Create.
  - Move the downloaded JSON file to `./secrets/cloudsql/`
- Enabled [CloudSQL API in API Manager](https://console.cloud.google.com/apis/library)

### Creating secret

- `<SECRET-NAME>` refers to `secretName` of k8s_deploy.yml file.

```
$ kubectl create secret generic <SECRET-NAME> --from-file=./secrets/cloudsql/***.json
$ kubectl get secrets
```

## Kubernates setting

### Deploy contaiers

- `<CLOUDSQL_INSTANCE_NAME>` is copy your instance connection name from the Instance details page.

```
$ export PROJECT_ID="<PROJECT_ID>" IMAGE_RAILS="<RAILS_NAME>" IMAGE_NGINX="<NGINX_NAME>" INSTANCE_CONNECTION_NAME="<CLOUDSQL_INSTANCE_NAME>" CREDENTIALS="<CREDENTIAL_FILENAME>"

$ export TAG=`date +"%Y-%m-%d_%H-%M-%S"`

$ docker build -t gcr.io/${PROJECT_ID}/${IMAGE_RAILS}:${TAG} -f Dockerfile.rails .
$ docker build -t gcr.io/${PROJECT_ID}/${IMAGE_NGINX} -f Dockerfile.nginx .

$ gcloud docker -- push gcr.io/${PROJECT_ID}/${IMAGE_RAILS}:${TAG}
$ gcloud docker -- push gcr.io/${PROJECT_ID}/${IMAGE_NGINX}

$ envsubst < k8s_deploy.yml | kubectl create -f -
```

Checke the status of pods.

```
$ watch kubectl pod all
```

Delete pod.

```
$ envsubst < k8s_deploy.yml | kubectl delete -f -
```

#### Rails DB migration

Get node name and ssh login.

```
$ kubectl get pod -o wide
$ gcloud compute ssh <NODE>
```

Rails db migration in rails conteiner.

```
$ docker exec <RAILS-CONTAINER> rails db:create
$ docker exec <RAILS-CONTAINER> rails db:migrate
```

## Rolling deploy

```
$ sh k8s_rollout.sh
```
