export TAG=`date +"%Y-%m-%d_%H-%M-%S"`
docker build -t gcr.io/${PROJECT_ID}/${IMAGE_RAILS}:${TAG} -f Dockerfile.rails .
gcloud docker -- push gcr.io/${PROJECT_ID}/${IMAGE_RAILS}:${TAG}
envsubst < k8s_job.yml | kubectl create -f -
sh k8s_kill_job.sh
kubectl set image deploy/sample rails=gcr.io/${PROJECT_ID}/${IMAGE_RAILS}:${TAG}
