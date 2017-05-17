# Prerequisites

- GCP
- Project
- Cluster
- Cloud SQL
  - root:pass
  - credentials
- Secrete
- cloudsql_proxy

# Deployment

## At first

```
$ export TAG=`date +"%Y-%m-%d_%H-%M-%S"`
$ docker build -t gcr.io/${PROJECT_ID}/${IMAGE_RAILS}:${TAG} -f Dockerfile.rails .
$ gcloud docker -- push gcr.io/${PROJECT_ID}/${IMAGE_RAILS}:${TAG}
$ envsubst < k8s_deploy.yml | kubectl create -f -

$ gcloud compute ssh <NODE>
$ docker exec <RAILS-CONTAINER> rails db:create
$ docker exec <RAILS-CONTAINER> rails db:migrate
```



## Rolling deploy

```
$ sh k8s_rollout.sh
```
