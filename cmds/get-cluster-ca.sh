KUBECONFIG=$1
cat  $KUBECONFIG |grep certificate-authority-data | awk -F ' ' '{print $2}' |base64 -d