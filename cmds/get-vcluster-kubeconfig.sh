VCLUSTER=$1
kubectl get secret vc-$VCLUSTER-app -n $VCLUSTER --template={{.data.config}} | base64 -d