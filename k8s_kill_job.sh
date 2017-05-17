STATUS=""
while [[ $STATUS != "Completed" ]]; do
  sleep 2
  echo "Try!"
  STATUS=`kubectl get pods --selector=job-name=migrate -o jsonpath='{.items[*].status.containerStatuses[*].state.terminated.reason}'`
  echo $STATUS
  if [[ $STATUS = "Completed" ]]; then
    envsubst < k8s_job.yml| kubectl delete -f -
  fi
done
